

🗄️

**Backend Schema**

Supabase / PostgreSQL Database Design

**Darzi App — सिलाई कारीगर के लिए**

Version 1.0  |  June 2026


# **1. Database: Supabase (PostgreSQL)**
All data is stored in a single Supabase project. No authentication in v1 — the app uses an anonymous/public key. Row Level Security (RLS) can be added in v2.

# **2. Tables**
## **2.1 orders (Main Table)**

|**Column**|**Type**|**Required**|**Description**|
| :- | :- | :- | :- |
|id|uuid|Yes|Primary key, auto-generated (gen\_random\_uuid())|
|customer\_name|text|Yes|ग्राहक का नाम — voice or typed|
|phone\_number|text|No|फ़ोन नंबर — 10 digits, stored as text|
|cloth\_type|text|No|Blouse / Saree / Suit / Frock / Other|
|measurements|text|No|Free text for नाप / पुराने कपड़े|
|notes|text|No|अतिरिक्त नोट्स — voice or typed|
|advance\_payment|numeric(10,2)|No|अग्रिम भुगतान in INR|
|total\_bill|numeric(10,2)|No|कुल बिल in INR|
|pending\_amount|numeric(10,2)|No|Auto-calculated: total - advance|
|status|text|Yes|Default: 'pending' | 'ready' | 'delivered'|
|created\_at|timestamptz|Yes|Auto set by Supabase (now())|
|updated\_at|timestamptz|No|Updated on every edit|

## **2.2 SQL — Create Table**
create table orders (\
`  `id uuid default gen\_random\_uuid() primary key,\
`  `customer\_name text not null,\
`  `phone\_number text,\
`  `cloth\_type text,\
`  `measurements text,\
`  `notes text,\
`  `advance\_payment numeric(10,2) default 0,\
`  `total\_bill numeric(10,2) default 0,\
`  `pending\_amount numeric(10,2) generated always as\
`    `(total\_bill - advance\_payment) stored,\
`  `status text default 'pending',\
`  `created\_at timestamptz default now(),\
`  `updated\_at timestamptz\
);

## **2.3 Useful Indexes**
-- For fast search by name\
create index idx\_customer\_name on orders (lower(customer\_name));\
-- For fast search by phone\
create index idx\_phone on orders (phone\_number);

# **3. API Calls (Flutter → Supabase)**

|**Action**|**Method**|**Supabase Call**|
| :- | :- | :- |
|Add Order|INSERT|supabase.from('orders').insert({...})|
|Get All Orders|SELECT|supabase.from('orders').select().order('created\_at')|
|Search by Name|SELECT + filter|.ilike('customer\_name', '%query%')|
|Search by Phone|SELECT + filter|.eq('phone\_number', query)|
|Update Order|UPDATE|.update({...}).eq('id', orderId)|
|Delete Order|DELETE|.delete().eq('id', orderId)|

# **4. Environment Setup**
**•** Create a free Supabase project at supabase.com

**•** Copy Project URL and anon/public API key

**•** Add to Flutter: flutter pub add supabase\_flutter

**•** Initialize in main.dart: Supabase.initialize(url: ..., anonKey: ...)

**•** Run the SQL above in Supabase SQL Editor to create the table

# **5. v2 — Future Schema Additions**

|**Addition**|**Purpose**|
| :- | :- |
|order\_photos table|Store cloth/design photo references|
|deleted\_at column|Soft delete instead of hard delete|
|shop\_id column|Multi-shop support|
|RLS policies|Secure data per device/user|

