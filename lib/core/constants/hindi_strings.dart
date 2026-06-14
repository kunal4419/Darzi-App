/// All Hindi UI strings centralized in one place.
///
/// Every label, button, message, and placeholder is defined here.
/// This makes it easy to update any text without searching the codebase.
class HindiStrings {
  HindiStrings._();

  // ── App ──
  static const String appName = 'Rakhi Tailors';
  static const String appTagline = 'सिलाई के लिए';

  // ── Bottom Navigation ──
  static const String newOrder = 'नया ऑर्डर';
  static const String allOrders = 'सभी ऑर्डर';

  // ── Add Order Screen ──
  static const String addOrderTitle = 'नया ऑर्डर जोड़ें';
  static const String editOrderTitle = 'ऑर्डर संपादित करें';
  static const String saveButton = 'सेव करें ✓';
  static const String clearButton = 'साफ़ करें';
  static const String updateButton = 'अपडेट करें ✓';

  // ── Form Fields ──
  static const String customerName = 'ग्राहक का नाम';
  static const String customerNameHint = 'नाम बोलें या टाइप करें...';
  static const String phoneNumber = 'फ़ोन नंबर';
  static const String phoneNumberHint = '10 अंक का नंबर';
  static const String clothType = 'कपड़े का प्रकार';
  static const String measurements = 'नाप / पुराना नाप';
  static const String measurementsHint = 'नाप बोलें या लिखें...';
  static const String notes = 'अतिरिक्त नोट्स';
  static const String notesHint = 'कोई खास बात...';
  static const String advancePayment = 'जमा (₹)';
  static const String advancePaymentHint = '0';
  static const String totalBill = 'कुल बिल (₹)';
  static const String totalBillHint = '0';
  static const String pendingAmount = 'बाकी राशि';

  // ── Multiple Clothes ──
  static const String addClothButton = 'दूसरा कपड़ा जोड़ें';
  static const String clothNumberLabel = 'कपड़ा';
  static const String napOption = 'नाप लिखें';
  static const String puraneKapadeOption = 'पुराना नाप';
  static const String clothDetails = 'नाप';

  // ── Orders List Screen ──
  static const String ordersListTitle = 'सभी ऑर्डर';
  static const String searchHint = 'नाम या नंबर से खोजें...';
  static const String noOrdersFound = 'कोई ऑर्डर नहीं मिला';
  static const String noOrdersSubtext = 'नया ऑर्डर जोड़ने के लिए\nनीचे "नया ऑर्डर" टैब दबाएं';
  static const String pullToRefresh = 'नीचे खींचें';

  // ── Order Detail ──
  static const String orderDetails = 'ऑर्डर विवरण';
  static const String editOrder = 'संपादित करें';
  static const String deleteOrder = 'हटाएं';
  static const String close = 'बंद करें';

  // ── Order Status ──
  static const String statusPending = 'बाकी है';
  static const String statusReady = 'तैयार है';
  static const String statusDelivered = 'दे दिया';

  // ── Payment Labels ──
  static const String advance = 'जमा';
  static const String total = 'कुल';
  static const String pending = 'बाकी';

  // ── Voice Input ──
  static const String speakNow = 'बोलिए...';
  static const String voiceNotAvailable = 'आवाज़ सेवा उपलब्ध नहीं है';
  static const String permissionDenied = 'माइक्रोफोन की अनुमति नहीं है';
  static const String tapToSpeak = 'बोलने के लिए माइक दबाएं';

  // ── Success Messages ──
  static const String orderSaved = 'ऑर्डर सेव कर लिया गया! ✓';
  static const String orderUpdated = 'ऑर्डर अपडेट हो गया! ✓';
  static const String orderDeleted = 'ऑर्डर हटा दिया गया।';

  // ── Error Messages ──
  static const String errorSaving = 'सेव करने में गड़बड़ी, दोबारा कोशिश करें।';
  static const String errorLoading = 'ऑर्डर लोड नहीं हो सके।';
  static const String errorDeleting = 'हटाने में गड़बड़ी, दोबारा कोशिश करें।';
  static const String noInternet = 'इंटरनेट नहीं है, दोबारा कोशिश करें।';
  static const String retry = 'फिर कोशिश करें';

  // ── Validation ──
  static const String nameRequired = 'कृपया ग्राहक का नाम दर्ज करें';
  static const String invalidPhone = 'फ़ोन नंबर 10 अंक का होना चाहिए';

  // ── Delete Dialog ──
  static const String deleteConfirmTitle = 'ऑर्डर हटाएं?';
  static const String deleteConfirmMessage =
      'क्या आप यह ऑर्डर हटाना चाहते हैं?\nयह वापस नहीं आएगा।';
  static const String confirmDelete = 'हाँ, हटाएं';
  static const String cancelDelete = 'नहीं';

  // ── Filters ──
  static const String filterAll = 'सभी';
  static const String filterBaki = 'बाकी';
  static const String filterPuraHua = 'पूरा हुआ';
  static const String filterDate = 'तारीख';

  // ── Date ──
  static const String today = 'आज';
  static const String yesterday = 'कल';
}
