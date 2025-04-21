-- Add migration script here
-- Enable foreign keys in SQLite
PRAGMA foreign_keys = ON;

-- ===================================
-- Table: transactions
-- ===================================
CREATE TABLE transactions (
    id TEXT PRIMARY KEY,     -- UUID stored as TEXT
    data BLOB,
    createdOn TIMESTAMP
);

-- ===================================
-- Table: categories
-- ===================================
CREATE TABLE categories (
    id TEXT PRIMARY KEY,     -- UUID stored as TEXT
    data BLOB                -- Store serialized category data (e.g. JSON)
);

-- ===================================
-- Table: transaction_categories (Join Table)
-- ===================================
CREATE TABLE transaction_categories (
    transaction_id TEXT NOT NULL,
    category_id TEXT NOT NULL,
    PRIMARY KEY (transaction_id, category_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- ===================================
-- Recommended Indexes
-- ===================================

-- Index to quickly find categories for a transaction
CREATE INDEX idx_transaction_categories_transaction_id
ON transaction_categories(transaction_id);

-- Index to quickly find transactions by category
CREATE INDEX idx_transaction_categories_category_id
ON transaction_categories(category_id);
