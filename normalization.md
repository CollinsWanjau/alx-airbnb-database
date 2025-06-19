# Third Normal Form (3NF) Normalization Analysis

## Overview
Third Normal Form (3NF) requires:

1. The database must be in 2NF
2. No transitive dependencies - Non-key attributes should not depend on other non-key attributes
3. All non-key attributes must depend directly on the primary key

# Current Schema Analysis

## Identified 3NF Violations

1. User Table Violations

* <b>Issue</b> : User's role determines permissions and capabilities.
* <b>Transitive Dependency</b>: `user_id → role → role_permissions`
* <b>Solution</b>: Extract role information to separate tables

2. Property Table Violations

* <b>Issue</b>: Location creates transitive dependencies
* <b>Transitive Dependencies</b>: `property_id → location → (city, state, country)`
* <b>Solution</b>: Normalize location data into seperate tables.

3. Booking Table Violations

* <b>Issue</b>:  Total price depends on dates and property pricing
* <b>Transitive Dependencies</b>: `booking_id → (start_date, end_date, property_id) → total_price`
* <b>Solution</b>:  Remove calculated fields, create pricing breakdown tables

4. Payment Table Violations

* <b>Issue</b>: Payment method details create dependencies.
* <b>Transitive Dependencies</b>: `payment_id → payment_method → (card_type, provider_details)`

* <b>Solution</b>:  Normalize payment method information

5. Review Table Violations

* <b>Issue</b>: Property information accessible through review.
* <b>Transitive Dependencies</b>: `review_id → property_id → (property_name, host_info)`
* <b>Solution</b>: Ensure direct relationships only


# Initial Denormalized State Analysis

## Problems Identified in Original Schema

1. First Normal Form Violations

* Ensure that each table in the database has primary key and that each column in the table contains atomic values.

* Location field in Property table: Single field storing complex address info.

```sql
location: VARCHAR -- Could contain "123 Main St, New York, NY 10001, USA"
```

Phone number without country context: No way to internationally validate numbers.

2. Second Normal Form (2NF) Violations
* <b>Transitive dependencies</b>: Several fields on other non-key fields
* <b>Repeated category</b>: ENUMS storing values that could change or expand.

3. Third Normal Form (3NF) Violations
* Role info: Users role stored as ENUM instead of flexible role system
* Payment method: Limited ENUM preventing expansion
* Status info: Hard-coded values without descriptions
* Currency assumptions: No support for multi-currency operations.
* Geographical data: Location as single field prevents proper geographic queries.

## Normalization Steps

### Step 1: Achieving First Normal Form (1NF)

#### 1.1 Address Decomposition

<b>Problem</b> location field contained multiple pieces of info.

```sql
-- Before (Denormalized)
location: VARCHAR -- "123 Main St, New York, NY 10001, USA"

-- After (1NF)
street_address: VARCHAR(200)
street_address_2: VARCHAR(200)
city: VARCHAR(100)
state: VARCHAR(100)
country: VARCHAR(100)
postal_code: VARCHAR(20) 
```

#### 1.2 Phone Number Normalization

<b>Problem</b>: Phone numbers without country context

```sql
-- Before

phone_number: VARCHAR

-- After
phone_number: VARCHAR(20)
country_code: VARCHAR(10)
phone_type: ENUM('mobile', 'home', 'work')
```

### Step 2: Achieving Second Normal Form (2NF)

#### 2.1 Eliminate Partial Dependencies

<b>Problem</b>: Non-key attributes depending on part of composite keys

<b>Solution</b>: Ensured all non-key attributes depend on the entire primary key

#### 2.2 Seperate Reference Data

<b>Problem</b>: ENUM values hard-coded in table definitions

```sql
-- Before
role: ENUM('guest', 'host', 'admin')
status: ENUM('pending', 'confirmed', 'canceled')
payment_method: ENUM('credit_card', 'paypal', 'stripe')


-- After - Created Reference Tables

CREATE TABLE Role (
    role_id UUID PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_decription TEXT
)

CREATE TABLE BookingStatus (
    status_id UUID PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL,
    status_description TEXT,
    is_final BOOLEAN DEFAULT FALSE
);

CREATE TABLE PaymentProvider (
    provider_id UUID PRIMARY KEY,
    provider_name VARCHAR(50) UNIQUE NOT NULL,
    provider_type ENUM('credit_card', 'debit_card', 'digital_wallet', 'bank_transfer')
);
```

### Step 3: Achieving 3NF

#### 3.1 Eliminate Transitive Dependencies

Geographic Data Normalization

<b>Problem</b>: City, State and country info has dependencies

```sql

-- Before

city: VARCHAR(100)
state: VARCHAR(100) -- Depends on country
country: VARCHAR(100) -- independent

-- After - Hierachical Structure
CREATE TABLE Country (
    country_id UUID PRIMARY KEY,
    country_code CHAR(2) UNIQUE NOT NULL
    country_name VARCHAR(100) UNIQUE NOT NULL 
);

CREATE TABLE StateProvince (
    state_id UUID PRIMARY KEY,
    country_code CHAR(2) UNIQUE NOT NULL,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE City (
    postal_id UUID PRIMARY KEY,
    city_id UUID REFERENCES City(city_id),
    postal_code VARCHAR(20)  NOT NULL
)
```

Currency Normalization

<b>Problem</b>: Assumed single currency, prices without currency context

```sql
-- Before
pricepernight: DECIMAL
total_price: DECIMAL

-- After

CREATE TABLE Currency (
    currency_id UUID PRIMARY KEY,
    currency_code CHAR(3) UNIQUE NOT NULL,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VACHAR(5)
)

CREATE TABLE PropertyPricing (
    pricing_id UUID PRIMARY KEY,
    property_id UUID REFERENCES Property(property_id),
    currency_id UUID REFERENCES Currency(currency_id),
    price_per_night DECIMAL(10, 2) NOT NULL
)
```

### Role and Permission System

<b>Problem</b> Fixed role ENUM couldn't handle complex permissions

```sql

-- Before
role: ENUM('guest', 'host', 'admin')

-- After - Flexible Role-Permission System

CREATE TABLE Permission (
    permission_id UUID PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    permission_category VARCHAR(50) NOT NULL
);

CREATE TABLE RolePermission (
    role_id UUID REFERENCES Role(role_id),
    permission_id UUID REFERENCES Permission(permission_id),
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE UserRole (
    user_id UUID REFERENCES User(user_id),
    role_id UUID REFERENCES Role(role_id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id)
);
```
