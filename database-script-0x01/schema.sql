-- ================================
-- PHASE 1: Core foundation Tables
-- ================================
-- These are the most basic tables that other tables depend

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
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
  PRIMARY KEY(user_id, role_id)
  FOREIGN KEY(user_id) REFERENCES User(user_id),
  FOREIGN KEY(role_id) REFERENCES Role(role_id)
);
