-- Sample data to test the core tables
INSERT INTO Currency (
  currency_id, currency_code, currency_name, currency_symbol
) VALUES 
  (UUID(), 'USD', 'US Dollar', '$'),
  (UUID(), 'EUR', 'Euro', '€'),
  (UUID(), 'GBP', 'British Pound', '£');

INSERT INTO Role (
  role_id, role_name , role_description
) VALUES 
  (UUID(), 'Admin', 'System administrator with full access'),
  (UUID(), 'Host', 'Property owner who can list properties'),
  (UUID(), 'Guest', 'Regular user who can make bookings');

INSERT INTO Permission (
  permission_id, permission_name, permission_category
) VALUES 
  (UUID(), 'manage_users', 'User Management'),
  (UUID(), 'create_property', 'Property Management'),
  (UUID(), 'make_booking', 'Booking Management');
