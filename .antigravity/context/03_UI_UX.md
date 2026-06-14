

🎨

**UI/UX Guidelines**

Design Principles for Hindi-First Mobile App

**Darzi App — सिलाई कारीगर के लिए**

Version 1.0  |  June 2026


# **1. Design Principles**
**•** Hindi First — every label, button, and message in Hindi

**•** Touch Friendly — all tap targets minimum 48×48dp

**•** Voice First — mic icon visible on every text input

**•** Big and Clear — large fonts, high contrast, minimal clutter

**•** Forgiveness — easy to clear or redo, no destructive one-tap actions

# **2. Typography**

|**Element**|**Size**|**Weight**|**Usage**|
| :- | :- | :- | :- |
|Screen Title|22sp|Bold|Top AppBar title|
|Section Header|18sp|SemiBold|Form group labels|
|Field Label|16sp|Medium|Above input fields|
|Input Text|16sp|Regular|Inside text fields|
|Button Text|16sp|Bold|Save, Clear buttons|
|Card Info|14sp|Regular|Order card details|
|Helper / Error|13sp|Regular|Below fields, error messages|

# **3. Color Palette**

|**Color Name**|**Hex Code**|**Usage**|
| :- | :- | :- |
|Primary Blue|#1E88E5|AppBar, Save button, active tab|
|Success Green|#2E7D32|Success messages, confirm actions|
|Warning Amber|#F57F17|Pending payment, alerts|
|Error Red|#C62828|Validation errors, required fields|
|Background|#F5F5F5|App background / card fill|
|Surface White|#FFFFFF|Cards, input fields|
|Text Dark|#212121|Primary text|
|Text Gray|#757575|Placeholder, helper text|

# **4. Component Specs**
## **4.1 Text Field with Voice**
**•** Height: 56dp minimum

**•** Border radius: 12dp

**•** Mic icon (32×32dp) inside field on right side

**•** Tapping mic triggers speech\_to\_text recording

**•** During recording: mic icon turns red + pulse animation

**•** After recording: text appears in field, user can edit

## **4.2 Cloth Type Chips**
Quick-tap chips instead of dropdown to reduce typing:

**•** ब्लाउज़ (Blouse)

**•** साड़ी (Saree)

**•** सूट (Suit)

**•** फ्रॉक (Frock)

**•** अन्य (Other)

Style: Outlined chip, turns filled blue when selected. Max 2 rows, wraps automatically.

## **4.3 Save Button**
**•** Full-width, 56dp height

**•** Background: Primary Blue #1E88E5

**•** Text: 'सहेजें ✓' in white, bold 18sp

**•** On tap: shows CircularProgressIndicator

**•** On success: snackbar 'ऑर्डर सहेज लिया गया! ✓'

## **4.4 Order Card**
**•** Card elevation: 2dp, border radius: 12dp

**•** Padding: 12dp all sides

**•** Pending balance highlighted in amber if > 0

**•** Tap anywhere on card to view full details

# **5. Navigation**
**•** Bottom Navigation Bar with 2 tabs

**•** Tab 1: 📝 icon + 'नया ऑर्डर'

**•** Tab 2: 📋 icon + 'सभी ऑर्डर'

**•** Active tab: blue color, filled icon

**•** Inactive tab: gray color, outlined icon

# **6. Error & Validation Messages (Hindi)**

|**Situation**|**Hindi Message**|
| :- | :- |
|Name empty on save|कृपया ग्राहक का नाम दर्ज करें|
|Invalid phone|फ़ोन नंबर 10 अंक का होना चाहिए|
|No internet|इंटरनेट नहीं है, दोबारा कोशिश करें|
|Save success|ऑर्डर सहेज लिया गया! ✓|
|Delete confirm|क्या आप यह ऑर्डर हटाना चाहते हैं?|
|No orders found|कोई ऑर्डर नहीं मिला|

