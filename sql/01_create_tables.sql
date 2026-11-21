-- =====================================================================
-- Pizza Sales Analysis — database setup
-- Run this once in MySQL Workbench, then import the CSVs
-- (see data/README.md for the import order).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS pizza_sales;
USE pizza_sales;

-- Drop in reverse dependency order so the script can be re-run safely
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS pizza_types;

-- Menu items: name, category and ingredients
CREATE TABLE pizza_types (
    pizza_type_id  VARCHAR(50)  NOT NULL,
    name           VARCHAR(100) NOT NULL,
    category       VARCHAR(50)  NOT NULL,
    ingredients    TEXT,
    PRIMARY KEY (pizza_type_id)
);

-- Each pizza type comes in several sizes, each with its own price
CREATE TABLE pizzas (
    pizza_id       VARCHAR(50)   NOT NULL,
    pizza_type_id  VARCHAR(50)   NOT NULL,
    size           VARCHAR(5)    NOT NULL,
    price          DECIMAL(6,2)  NOT NULL,
    PRIMARY KEY (pizza_id),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types (pizza_type_id)
);

-- One row per customer order
CREATE TABLE orders (
    order_id    INT   NOT NULL,
    date        DATE  NOT NULL,
    time        TIME  NOT NULL,
    PRIMARY KEY (order_id)
);

-- One row per pizza line on an order
CREATE TABLE order_details (
    order_details_id  INT          NOT NULL,
    order_id          INT          NOT NULL,
    pizza_id          VARCHAR(50)  NOT NULL,
    quantity          INT          NOT NULL,
    PRIMARY KEY (order_details_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas (pizza_id)
);
