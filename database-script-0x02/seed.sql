-- Sample data to test the core tables
INSERT IGNORE INTO Currency (
  currency_id, currency_code, currency_name, currency_symbol
) VALUES 
  (UUID(), 'USD', 'US Dollar', '$'),
  (UUID(), 'EUR', 'Euro', '€'),
  (UUID(), 'GBP', 'British Pound', '£');

DELETE FROM User;

INSERT  INTO User (
  user_id, first_name, last_name, email, password_hash
) VALUES  
  ('user_1', 'John', 'Doe', 'john.doe@example.com', 'hashed_password_123'),
  ('user_2', 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_456'),
  ('user_3', 'Michael', 'Johnson', 'michael.j@example.com', 'hashed_password_789'),
  ('user_4', 'Emily', 'Williams', 'emily.w@example.com', 'hashed_password_abc'),
  ('user_5', 'Robert', 'Brown', 'robert.brown@example.com', 'hashed_password_def');

INSERT IGNORE INTO Role (
  role_id, role_name , role_description
) VALUES 
  (UUID(), 'Admin', 'System administrator with full access'),
  (UUID(), 'Host', 'Property owner who can list properties'),
  (UUID(), 'Guest', 'Regular user who can make bookings');

INSERT IGNORE INTO Permission (
  permission_id, permission_name, permission_category
) VALUES 
  (UUID(), 'manage_users', 'User Management'),
  (UUID(), 'create_property', 'Property Management'),
  (UUID(), 'make_booking', 'Booking Management');
