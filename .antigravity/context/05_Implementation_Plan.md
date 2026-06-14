

🛠️

**Implementation Plan**

Step-by-Step Build Guide for Darzi App

**Darzi App — सिलाई कारीगर के लिए**

Version 1.0  |  June 2026


# **Overview**
Total estimated time: 2–3 weeks for a beginner Flutter developer working part-time. The plan is split into 4 phases. Complete each phase fully before moving to the next.

# **Phase 1 — Project Setup (Day 1–2)**
## **Step 1.1 — Flutter Project**
**•** Run: flutter create darzi\_app

**•** Set min SDK: android minSdkVersion 21, iOS 12+

**•** Clean the default counter app code from main.dart

## **Step 1.2 — Add Dependencies (pubspec.yaml)**

|**Package**|**Version**|**Purpose**|
| :- | :- | :- |
|supabase\_flutter|^2.x|Database connection|
|speech\_to\_text|^6.x|Voice input on all fields|
|get|^4.x|State management (GetX)|
|intl|^0.18.x|Date formatting|
|uuid|^4.x|Generate UUIDs locally if needed|

## **Step 1.3 — Supabase Setup**
**•** Create project at supabase.com (free tier)

**•** Copy Project URL and anon key to a .env or constants file

**•** Run the orders table SQL in Supabase SQL Editor

**•** Initialize Supabase in main.dart before runApp()

## **Step 1.4 — Folder Structure**
**lib/**\
`  `models/     → order\_model.dart\
`  `services/   → supabase\_service.dart\
`  `screens/    → add\_order\_screen.dart, orders\_list\_screen.dart\
`  `widgets/    → voice\_input\_field.dart, order\_card.dart\
`  `controllers/ → order\_controller.dart (GetX)\
`  `constants/  → strings.dart (all Hindi labels), colors.dart\
`  `main.dart

# **Phase 2 — Core Features (Day 3–7)**
## **Step 2.1 — Order Model**
**•** Create OrderModel class with all fields matching the DB schema

**•** Add fromJson() and toJson() methods for Supabase conversion

**•** Add computed getter: double get pendingAmount => totalBill - advancePayment

## **Step 2.2 — Supabase Service**
**•** Create SupabaseService class with methods: insertOrder(), getAllOrders(), searchOrders(), updateOrder(), deleteOrder()

**•** Wrap all calls in try/catch, return proper error strings

## **Step 2.3 — Voice Input Widget**
**•** Create reusable VoiceInputField widget

**•** Wraps standard TextField + mic IconButton

**•** Initialize SpeechToText on widget creation

**•** On mic tap: start listening, show red pulsing mic

**•** On result: set text controller value

**•** Handle permission denied gracefully with Hindi message

## **Step 2.4 — Add Order Screen**
**•** Build form with all fields using VoiceInputField

**•** Add ClothTypeChips widget (row of FilterChip)

**•** Wire Save button to SupabaseService.insertOrder()

**•** Show CircularProgressIndicator during save

**•** Show SnackBar with Hindi success/error message

## **Step 2.5 — Orders List Screen**
**•** Fetch orders from Supabase on screen load

**•** Display using ListView.builder with OrderCard widget

**•** Add pull-to-refresh (RefreshIndicator)

**•** Show empty state: 'कोई ऑर्डर नहीं मिला' with icon

# **Phase 3 — Search & Detail (Day 8–11)**
## **Step 3.1 — Search Bar**
**•** Add VoiceInputField at top of Orders List Screen

**•** On text change: filter local list OR call searchOrders() on Supabase

**•** Debounce search by 300ms to avoid excessive API calls

## **Step 3.2 — Order Detail / Edit**
**•** On card tap: show BottomSheet with full order details

**•** Add Edit button → opens pre-filled Add Order form

**•** Add Delete button → show AlertDialog confirmation in Hindi

**•** On confirm delete: call deleteOrder(), refresh list

## **Step 3.3 — Bottom Navigation**
**•** Wrap screens in Scaffold with BottomNavigationBar

**•** 2 tabs: नया ऑर्डर (index 0) and सभी ऑर्डर (index 1)

**•** Persist selected tab state with GetX or setState

# **Phase 4 — Polish & Test (Day 12–14)**
## **Step 4.1 — UI Polish**
**•** Apply all colors from colors.dart constants

**•** Apply all Hindi strings from strings.dart constants

**•** Test on a real Android device (not just emulator)

**•** Verify voice input works in Hindi language

## **Step 4.2 — Testing Checklist**

|**Test Case**|**Pass**|**Fail**|
| :- | :- | :- |
|Add order with only name → saves correctly|☐|☐|
|Add order with all fields → all data saved to Supabase|☐|☐|
|Voice input fills correct text in Hindi|☐|☐|
|Search by name shows correct orders|☐|☐|
|Search by phone shows correct orders|☐|☐|
|Delete order removes from list|☐|☐|
|Pending amount calculated correctly|☐|☐|
|Error shown when saving with no name|☐|☐|
|Error shown when no internet|☐|☐|
|App works on Android 10+ physical device|☐|☐|

## **Step 4.3 — Build for Android**
**•** Run: flutter build apk --release

**•** APK found at: build/app/outputs/flutter-apk/app-release.apk

**•** Transfer APK to phone via USB or WhatsApp for testing

# **Phase Summary**

|**Phase**|**Name**|**Key Output**|**Days**|
| :- | :- | :- | :- |
|1|Setup|Project + Supabase table ready|1–2|
|2|Core Features|Add order + list screen working|3–7|
|3|Search & Detail|Search + edit + delete working|8–11|
|4|Polish & Test|Tested APK ready to install|12–14|

