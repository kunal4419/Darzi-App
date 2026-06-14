

🧵

**Product Requirements Document**

Darzi App — Sewing Worker Order Manager

**Darzi App — सिलाई कारीगर के लिए**

Version 1.0  |  June 2026


# **1. Overview**
The Darzi App is a simple, Hindi-language mobile application designed for a sewing worker (darzi) to manage customer orders. It is built for someone with limited smartphone and English literacy.

## **1.1 Problem Statement**
Sewing workers manage orders manually using notebooks — names get lost, payments are forgotten, and measurement records are misplaced. There is no simple digital tool built for this audience in Hindi.

## **1.2 Goals**
**•** Enable easy entry of customer orders with Hindi UI

**•** Record advance payments and total bill amounts

**•** Search saved orders by name or phone number

**•** Support voice input for every text field

**•** Store all data securely in Supabase cloud

## **1.3 Non-Goals (v1)**
**•** No WhatsApp/SMS notifications

**•** No online payment processing

**•** No multi-user or shop management

**•** No barcode/QR scanning

# **2. Users**

|**User**|**Description**|**Key Need**|
| :- | :- | :- |
|Primary|Sewing worker (darzi), semi-literate|Simple Hindi UI, voice input|
|Secondary|Shop owner or helper|View saved orders, search|

# **3. Features**
## **3.1 Core Features (v1 — Must Have)**

|**#**|**Feature**|**Screen**|**Details**|
| :- | :- | :- | :- |
|1|Add Customer Order|Add Customer|Form with Hindi labels + voice|
|2|Save to Supabase|Add Customer|Single save button, auto timestamp|
|3|View All Orders|Saved Orders|List with name, date, bill amount|
|4|Search Orders|Saved Orders|By name or phone, voice + keyboard|
|5|Voice Input|All screens|Tap mic icon on any text field|

## **3.2 Optional Features (v2 — Nice to Have)**
**•** Digital bill / receipt generation (PDF)

**•** Monthly earnings report

**•** Order status tracking (pending / ready / delivered)

**•** Photo attachment for cloth/design reference

**•** Offline mode with sync

# **4. Technical Stack**

|**Layer**|**Technology**|**Reason**|
| :- | :- | :- |
|Frontend|Flutter|Cross-platform, voice plugin support|
|Backend / DB|Supabase (PostgreSQL)|Free tier, easy REST API|
|State Mgmt|GetX or Provider|Simple for beginners|
|Voice Input|speech\_to\_text plugin|Flutter package, supports Hindi|
|Localization|Flutter intl / hardcoded Hindi|Full Hindi UI labels|

# **5. Success Metrics**
**•** Worker can add a new order in under 60 seconds

**•** Voice input works for name and notes fields

**•** Orders are saved and retrievable after app restart

**•** Search returns correct results within 1 second

**•** App works on a basic Android phone (4GB RAM, Android 10+)
