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

DELETE FROM Role;

-- Step 2: Insert sample Permissions
INSERT INTO Role (
  role_id, role_name , role_description
) VALUES 
  ('r1', 'Guest', 'Regular user who can search and book properties'),
  ('r2', 'Host', 'Property owner who can list and manage properties'),
  ('r3', 'Admin', 'System administrator with full access'),
  ('r4', 'SuperHost', 'Experienced host with additional privileges'),
  ('r5', 'Moderator', 'Can review and moderate content');

DELETE FROM Permission;

-- Step 3: Insert sample Permissions
INSERT INTO Permission (
  permission_id, permission_name, permission_category
) VALUES 
  -- User Management
  ('p1', 'view_profile', 'User Management'),
  ('p2', 'edit_profile', 'User Management'),
  ('p3', 'delete_user', 'User Management'),
  ('p4', 'manage_users', 'User Management'),

  -- Property Management
  ('p5', 'view_properties', 'Property Management'),
  ('p6', 'create_property', 'Property Management'),
  ('p7', 'edit_property', 'Property Management'),
  ('p8', 'delete_property', 'Property Management'),
  ('p9', 'approve_property', 'Property Management'),

  -- Booking Management
  ('p10', 'make_booking', 'Booking Management'),
  ('p11', 'cancel_booking', 'Booking Management'),
  ('p12', 'view_all_bookings', 'Booking Management'),
  ('p13', 'manage_bookings', 'Booking Management'),

  -- Financial
  ('p14', 'view_earnings', 'Financial'),
  ('p15', 'process_payments', 'Financial'),
  ('p16', 'view_reports', 'Financial'),

  -- Content moderation
  ('p17', 'moderate_reviews', 'Content Moderation'),
  ('p18', 'moderate_properties', 'Content Moderation');

-- Step 4: Assign Permissions to Roles
INSERT INTO RolePermission (role_id, permission_id) VALUES
  -- Guest Permissions
  ('r1', 'p1'), -- view_profile
  ('r1', 'p2'), -- edit_profile
  ('r1', 'p5'), -- view_properties
  ('r1', 'p10'),  -- make_booking
  ('r1', 'p11'),  -- cancel_booking

  -- Host Permissions (includes Guest permissions)
  ('r2', 'p1'), -- view_profile
  ('r2', 'p2'), -- edit_profile
  ('r2', 'p5'), -- view_properties
  ('r2', 'p6'), -- create_property
  ('r2', 'p7'), -- edit_property
  ('r2', 'p10'), -- make_booking
  ('r2', 'p11'), -- cancel_booking
  ('r2', 'p13'), -- manage_bookings
  ('r2', 'p14'), -- view_earnings

  -- SuperHost Permissions (Host + extras)
  ('r4', 'p1'), -- view_profile
  ('r4', 'p2'), -- edit_profile
  ('r4', 'p5'), -- view_properties
  ('r4', 'p6'), -- create_property
  ('r4', 'p7'), -- edit_property
  ('r4', 'p10'),  -- make_booking
  ('r4', 'p11'),  -- cancel_booking
  ('r4', 'p13'),  -- manage_bookings
  ('r4', 'p14'),  -- view_earnings
  ('r4', 'p16'),  -- view_reports

  -- Moderator permissions
  ('r5', 'p1'),  -- view_profile
  ('r5', 'p2'), -- edit_profile
  ('r5', 'p5'), -- view_properties
  ('r5', 'p17'),  -- moderate_reviews
  ('r5', 'p18'),  -- moderate_properties

  -- Admin permissions (everything)
  ('r3', 'p1')  -- view_profile
  ('r3', 'p2')  -- edit_profile
  ('r3', 'p3'), -- delete_user
  ('r3', 'p4'), -- manage_users
  ('r3', 'p5'), -- view_properties
  ('r3', 'p6'), -- create_property
  ('r3', 'p7'), -- edit_property
  ('r3', 'p8'), -- delete_property

  ('r3', 'p9'), -- approve_property
  ('r3', 'p10'),  -- make_booking
  ('r3', 'p11'),  -- cancel_booking
  ('r3', 'p12'), i -- view_all_bookings
  ('r3', 'p13'),  -- manage_bookings
  ('r3', 'p14'),  -- view_earnings
  ('r3', 'p15'),  -- process_payments
  ('r3', 'p16'),  -- view_reports
  ('r3', 'p17'),  -- moderate_reviews
  ('r3', 'p18');  -- moderate_properties

-- Step 4: Sample User Role Assignments (UserRole)
-- Note: Replace these user_ids with actual user_ids from your User table
-- You can check your users with: SELECT user_id, first_name, last_name FROM User;
INSERT INTO UserRole (
  user_id, role_id
) VALUES
-- Example assignments (update user_ids to match your actual users)
('user_1', 'r3'), -- User 1(John) is Admin
('user_1', 'r2'), -- user_1(John) is also a host
('user_2', 'r2'), -- User 2(Jane) is host
('user_3', 'r1'); -- User 3(Michael) is Guest

-- Query to verify the setup
SELECT 'RBAC Setup Complete!' as status;
SELECT 'Roles created:' as info, COUNT(*) as count FROM Role;
SELECT 'Permissions created:' as info, COUNT(*) as count FROM Permission;
SELECT 'Role-Permission mappings:' as info, COUNT(*) as count FROM RolePermission;
SELECT 'User-Role assignments:' as info, COUNT(*) as count FROM UserRole;
