-- ================================
-- PHASE 1: Core foundation Tables
-- ================================
-- These are the most basic tables that other tables depend

-- This ensures that we can re-run the script without errors
-- if the tables already exist. We drop tables with foreign keys first.
DROP TABLE IF EXISTS UserRole;
DROP TABLE IF EXISTS RolePermission;
DROP TABLE IF EXISTS Permission;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Currency;

-- Step 1: Create Currency table (referenced by User)
CREATE TABLE Currency (
  currency_id CHAR(36) PRIMARY KEY,
  currency_code CHAR(36) UNIQUE NOT NULL,
  currency_name VARCHAR(50) NOT NULL,
  currency_symbol VARCHAR(5)
);

-- Step 2: Create User table (core entity)
CREATE TABLE User (
  user_id CHAR(36) PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  preffered_currency_id CHAR(36),
  is_active BOOLEAN DEFAULT TRUE,
  email_verified BOOLEAN DEFAULT FALSE, -- Good to track email verfication
  last_login TIMESTAMP NULL,  -- track user activity
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY(preffered_currency_id) REFERENCES Currency(currency_id)
);

-- Step 3: Create Role and Permission tables (for user managment) 
CREATE TABLE  Role(
  role_id CHAR(36) PRIMARY KEY,
  role_name VARCHAR(100) UNIQUE NOT NULL,
  role_description TEXT
);

CREATE TABLE Permission (
  permission_id CHAR(36) PRIMARY KEY,
  permission_name VARCHAR(100) UNIQUE NOT NULL,
  permission_category VARCHAR(50) NOT NULL
);

-- Step 4: Create junction tables for user roles and permissions
CREATE TABLE RolePermission (
  role_id CHAR(36),
  permission_id CHAR(36),
  PRIMARY KEY(role_id, permission_id),
  FOREIGN KEY(role_id) REFERENCES Role(role_id),
  FOREIGN KEY(permission_id) REFERENCES Permission(permission_id)
);

CREATE TABLE UserRole (
  user_id CHAR(36),
  role_id CHAR(36),
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(user_id, role_id),
  FOREIGN KEY(user_id) REFERENCES User(user_id),
  FOREIGN KEY(role_id) REFERENCES Role(role_id)
);

-- step 5: Add indexes for better perfomance
CREATE INDEX idx_user_email ON User(email); -- For login lookups
CREATE INDEX idx_user_active ON User(is_active);  -- For filtering active users
CREATE INDEX idx_user_created_at ON User(created_at); -- For data-based queries
CREATE INDEX idx_user_preferred_currency ON User(preffered_currency_id);  -- For currency-based queries

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
