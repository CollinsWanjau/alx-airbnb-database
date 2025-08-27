-- ================================
-- PHASE 1: Core Foundation Tables
-- ================================
-- These are the most basic tables that other tables depend on
-- This ensures that we can re-run the script without errors
-- if the tables already exist. We drop tables with foreign keys first.

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS PropertyPricing;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS State;
DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS UserRole;
DROP TABLE IF EXISTS RolePermission;
DROP TABLE IF EXISTS Permission;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Currency;
DROP TABLE IF EXISTS PropertyStatus;

-- Step 1: Create Currency table (referenced by User)
CREATE TABLE IF NOT EXISTS Currency (
  currency_id CHAR(36) PRIMARY KEY,
  currency_code CHAR(3) UNIQUE NOT NULL,
  currency_name VARCHAR(50) NOT NULL,
  currency_symbol VARCHAR(5)
);

-- Step 2: Create User table (core entity)
CREATE TABLE IF NOT EXISTS User (
  user_id CHAR(36) PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  preffered_currency_id CHAR(36),
  is_active BOOLEAN DEFAULT TRUE,
  email_verified BOOLEAN DEFAULT FALSE, -- Good to track email verification
  last_login TIMESTAMP NULL,  -- track user activity
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY(preffered_currency_id) REFERENCES Currency(currency_id)
);

-- Step 3: Create Role and Permission tables (for user management)
CREATE TABLE IF NOT EXISTS Role (
  role_id CHAR(36) PRIMARY KEY,
  role_name VARCHAR(100) UNIQUE NOT NULL,
  role_description TEXT
);

CREATE TABLE IF NOT EXISTS Permission (
  permission_id CHAR(36) PRIMARY KEY,
  permission_name VARCHAR(100) UNIQUE NOT NULL,
  permission_category VARCHAR(50) NOT NULL
);

-- Step 4: Create junction tables for user roles and permissions
CREATE TABLE IF NOT EXISTS RolePermission (
  role_id CHAR(36),
  permission_id CHAR(36),
  PRIMARY KEY(role_id, permission_id),
  FOREIGN KEY(role_id) REFERENCES Role(role_id),
  FOREIGN KEY(permission_id) REFERENCES Permission(permission_id)
);

CREATE TABLE IF NOT EXISTS UserRole (
  user_id CHAR(36),
  role_id CHAR(36),
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(user_id, role_id),
  FOREIGN KEY(user_id) REFERENCES User(user_id),
  FOREIGN KEY(role_id) REFERENCES Role(role_id)
);

-- ============================================
-- PHASE 2: Location Hierarchy & Property Management
-- ============================================
-- Depends on: Currency, User (from Phase 1)

-- Step 1: Create location Hierarchy (Country -> State -> City)
CREATE TABLE IF NOT EXISTS Country (
  country_id CHAR(36) PRIMARY KEY,
  country_code CHAR(2) UNIQUE NOT NULL,
  country_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS State (
  state_id CHAR(36) PRIMARY KEY,
  country_id CHAR(36) NOT NULL,
  state_name VARCHAR(100) NOT NULL,
  FOREIGN KEY(country_id) REFERENCES Country(country_id)
);

CREATE TABLE IF NOT EXISTS City (
  city_id CHAR(36) PRIMARY KEY,
  state_id CHAR(36) NOT NULL,
  city_name VARCHAR(100),
  FOREIGN KEY(state_id) REFERENCES State(state_id)
);

-- Step 2: Create Property table (main property entity)
CREATE TABLE IF NOT EXISTS Property (
  property_id CHAR(36) PRIMARY KEY,
  user_id CHAR(36) NOT NULL,
  property_name VARCHAR(100) NOT NULL,
  property_description TEXT,
  property_type ENUM('apartment', 'house', 'condo', 'villa', 'cabin', 'loft', 'studio', 'townhouse', 'cottage', 'mansion', 'other') NOT NULL,
  street_address TEXT,
  city_id CHAR(36) NOT NULL,
  max_guests INT NOT NULL,
  bedrooms INT,
  bathrooms INT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES User(user_id),
  FOREIGN KEY(city_id) REFERENCES City(city_id)
);

-- Step 3: Create Property Status table (for property lifecycle management)
CREATE TABLE IF NOT EXISTS PropertyStatus (
  status_id CHAR(36) PRIMARY KEY,
  status_name VARCHAR(50) NOT NULL,
  status_description TEXT
);

-- Step 4: Create Property Pricing table (flexible pricing over time)
CREATE TABLE IF NOT EXISTS PropertyPricing (
  pricing_id CHAR(36) PRIMARY KEY,
  property_id CHAR(36) NOT NULL,
  currency_id CHAR(36) NOT NULL,
  price_per_night DECIMAL(10, 2) NOT NULL,
  effective_from DATE NOT NULL,
  effective_to DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(property_id) REFERENCES Property(property_id),
  FOREIGN KEY(currency_id) REFERENCES Currency(currency_id)
);

-- Step 5: Add indexes for better performance
CREATE INDEX idx_user_email ON User(email); -- For login lookups
CREATE INDEX idx_user_active ON User(is_active);  -- For filtering active users
CREATE INDEX idx_user_created_at ON User(created_at); -- For date-based queries
CREATE INDEX idx_user_preferred_currency ON User(preffered_currency_id);  -- For currency-based queries

CREATE INDEX idx_country_code ON Country(country_code);
CREATE INDEX idx_state_country ON State(country_id);
CREATE INDEX idx_city_state ON City(state_id);
CREATE INDEX idx_property_user ON Property(user_id);
CREATE INDEX idx_property_city ON Property(city_id);
CREATE INDEX idx_property_type ON Property(property_type);
CREATE INDEX idx_property_active ON Property(is_active);
CREATE INDEX idx_pricing_property ON PropertyPricing(property_id);
CREATE INDEX idx_pricing_dates ON PropertyPricing(effective_from, effective_to);
