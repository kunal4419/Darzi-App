import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

/// दर्ज़ी ऐप — Application entry point.
///
/// Initializes:
/// 1. flutter_dotenv — loads SUPABASE_URL and SUPABASE_ANON_KEY from .env
/// 2. Supabase — connects to the cloud database
/// 3. Runs the app with GetX (configured in app.dart)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Load environment variables ───
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    // ignore: deprecated_member_use
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const DarziApp());
}

/// Global Supabase client accessor — use anywhere in the app.
/// Example: supabase.from('orders').select()
final supabase = Supabase.instance.client;
