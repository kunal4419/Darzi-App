import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../core/constants/hindi_strings.dart';
import '../core/constants/darzi_colors.dart';

/// Reusable text field with built-in Hindi voice input support.
///
/// Features:
/// - Standard TextField with a mic button on the right
/// - Mic turns red + pulses while listening
/// - Speech recognized in Hindi (hi-IN locale)
/// - Fills the field with recognized text (user can still edit)
/// - Handles microphone permission denial gracefully
///
/// Usage:
/// ```dart
/// VoiceInputField(
///   controller: _nameController,
///   label: HindiStrings.customerName,
///   hint: HindiStrings.customerNameHint,
/// )
/// ```
class VoiceInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool readOnly;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const VoiceInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<VoiceInputField>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  // Pulse animation for mic button while listening
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Setup pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initSpeech();
  }

  /// Initialize speech recognition on widget creation.
  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) {
        if (mounted) setState(() => _isListening = false);
        _pulseController.stop();
        _pulseController.reset();
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
          _pulseController.stop();
          _pulseController.reset();
        }
      },
    );
    if (mounted) setState(() {});
  }

  /// Start or stop voice listening.
  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(HindiStrings.voiceNotAvailable),
          backgroundColor: DarziColors.error,
        ),
      );
      return;
    }

    if (_isListening) {
      // Stop listening
      await _speech.stop();
      setState(() => _isListening = false);
      _pulseController.stop();
      _pulseController.reset();
    } else {
      // Start listening in Hindi
      setState(() => _isListening = true);
      _pulseController.repeat(reverse: true);

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            widget.controller.text = result.recognizedWords;
            widget.onChanged?.call(result.recognizedWords);
            setState(() => _isListening = false);
            _pulseController.stop();
            _pulseController.reset();
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: 'hi_IN', // Hindi (India)
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Field Label ──
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: DarziColors.textDark,
          ),
        ),
        const SizedBox(height: 6),

        // ── Text Field + Mic Button ──
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 16,
            color: DarziColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: _isListening ? HindiStrings.speakNow : widget.hint,
            hintStyle: TextStyle(
              color: _isListening ? DarziColors.error : DarziColors.textGray,
              fontSize: 15,
              fontStyle:
                  _isListening ? FontStyle.italic : FontStyle.normal,
            ),
            suffixIcon: _buildMicButton(),
            // Remove bottom padding for multiline fields
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.maxLines > 1 ? 14 : 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMicButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _pulseAnimation.value : 1.0,
            child: IconButton(
              onPressed: widget.enabled ? _toggleListening : null,
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? DarziColors.error : DarziColors.textGray,
                size: 26,
              ),
              tooltip: HindiStrings.tapToSpeak,
            ),
          );
        },
      ),
    );
  }
}
