

📱

**App Flow Document**

Screen-by-Screen Navigation & Interactions

**Darzi App — सिलाई कारीगर के लिए**

Version 1.0  |  June 2026


# **1. App Entry**
When the user opens the app, it loads directly to the Home Screen with two bottom navigation tabs. No login or signup is required in v1.

# **2. Tab Navigation**

|**Tab**|**Hindi Label**|**Purpose**|
| :- | :- | :- |
|Tab 1|नया ऑर्डर (New Order)|Form to add a new customer order|
|Tab 2|सभी ऑर्डर (All Orders)|List + search all saved orders|

# **3. Screen 1 — नया ऑर्डर (Add Order)**
## **3.1 Fields**

|**Field (Hindi)**|**Type**|**Required**|**Notes**|
| :- | :- | :- | :- |
|ग्राहक का नाम|Text + Voice|Yes|Voice mic icon on right|
|फ़ोन नंबर|Number|No|10-digit, numeric keyboard|
|कपड़े का प्रकार|Dropdown / Chips|No|Blouse, Saree, Suit, etc.|
|नाप / पुराने कपड़े|Text + Voice|No|Free text or voice note|
|अतिरिक्त नोट्स|Text + Voice|No|Any special instructions|
|अग्रिम भुगतान (₹)|Number|No|Advance amount paid|
|कुल बिल (₹)|Number|No|Total expected bill|

## **3.2 Buttons**
**•** सहेजें (Save) — large green button at bottom, saves to Supabase

**•** साफ़ करें (Clear) — small secondary button, resets all fields

## **3.3 Flow**
**•** User taps field → types OR taps mic icon → speaks → text auto-fills

**•** User selects cloth type from quick-tap chips (blouse, saree, suit, dress, other)

**•** User taps Save → loading spinner → success snackbar in Hindi → form resets

**•** If Supabase call fails → error message in Hindi with retry button

# **4. Screen 2 — सभी ऑर्डर (Saved Orders)**
## **4.1 Search Bar**
**•** Always visible at top of screen

**•** Placeholder text: 'नाम या नंबर से खोजें...'

**•** Mic icon on right for voice search

**•** Filters list in real-time as user types

## **4.2 Order Card**

|**Element**|**Content**|
| :- | :- |
|Top Row|Customer Name (bold) + Date (right)|
|Middle Row|Cloth type chip + Phone number (if provided)|
|Bottom Row|Advance: ₹XX  |  Total: ₹YY  |  Pending: ₹ZZ|

## **4.3 Tap Order Card**
**•** Opens Order Detail screen (bottom sheet or new screen)

**•** Shows all saved fields in Hindi

**•** Edit and Delete buttons available

# **5. Voice Input Flow**
**•** User taps 🎤 mic icon next to any field

**•** App shows recording indicator (animation + 'बोलिए...' text)

**•** User speaks in Hindi

**•** Speech converted to text, filled into field

**•** User can re-tap to re-record or manually edit

# **6. Data Flow Summary**

|**Action**|**From**|**To**|**Result**|
| :- | :- | :- | :- |
|Save Order|Add Screen|Supabase DB|Row inserted, success toast|
|Load Orders|App Launch|Supabase DB|List fetched and displayed|
|Search|Search Bar|Local filter / Supabase query|Filtered list shown|
|Voice Input|Mic button|speech\_to\_text plugin|Text filled in field|

