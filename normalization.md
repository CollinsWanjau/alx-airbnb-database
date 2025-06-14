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
