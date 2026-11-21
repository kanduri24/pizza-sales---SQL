-- =====================================================================
-- Pizza Sales Analysis — business questions
--
-- Run each query in MySQL Workbench (click inside it, then Ctrl+Enter)
-- and note the answer on its "-- Result:" line. Then copy the most
-- interesting findings into the README's "Key findings" section.
-- =====================================================================

USE pizza_sales;


-- ---------------------------------------------------------------------
-- BASIC
-- ---------------------------------------------------------------------

-- Q1. How many orders were placed in total?
-- Each row in `orders` is one order, so we just count the rows.
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Result:


-- Q2. What was the total revenue?
-- Revenue for one line = quantity × price. Price lives in `pizzas`,
-- so we join it to `order_details` and add up every line.
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id;

-- Result:


-- Q3. Which is the highest-priced pizza?
-- Price is in `pizzas`, the name is in `pizza_types`. Sort by price,
-- highest first, and keep the top row.
SELECT pt.name,
       p.size,
       p.price
FROM pizzas AS p
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Result:


-- Q4. Which pizza size is ordered most often?
-- Sum quantity (not just count rows) so an order of 3 large pizzas
-- counts as 3.
SELECT p.size,
       SUM(od.quantity) AS pizzas_sold
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY pizzas_sold DESC;

-- Result:


-- Q5. What are the top 5 pizza types by quantity sold?
-- Three-table join: order line → pizza (size/price) → pizza type (name).
SELECT pt.name,
       SUM(od.quantity) AS pizzas_sold
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizzas_sold DESC
LIMIT 5;

-- Result:


-- ---------------------------------------------------------------------
-- INTERMEDIATE
-- ---------------------------------------------------------------------

-- Q6. How many pizzas were sold in each category?
-- Same joins as Q5, grouped by category instead of name.
SELECT pt.category,
       SUM(od.quantity) AS pizzas_sold
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY pizzas_sold DESC;

-- Result:


-- Q7. How many orders were placed in each hour of the day?
-- HOUR() pulls the hour (0–23) out of the order time.
SELECT HOUR(time)       AS order_hour,
       COUNT(order_id)  AS total_orders
FROM orders
GROUP BY HOUR(time)
ORDER BY order_hour;

-- Result:


-- Q8. What was the revenue for each month?
-- Needs the date (from `orders`) and the price (from `pizzas`).
-- Group by month number so the months come out January → December.
SELECT MONTH(o.date)                          AS month_num,
       MONTHNAME(o.date)                      AS month_name,
       ROUND(SUM(od.quantity * p.price), 2)   AS revenue
FROM order_details AS od
JOIN orders AS o
    ON od.order_id = o.order_id
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY MONTH(o.date), MONTHNAME(o.date)
ORDER BY month_num;

-- Result:


-- Q9. On average, how many pizzas are sold per day?
-- Two steps, using a CTE (a named temporary result):
--   1) total pizzas for each date
--   2) the average of those daily totals
WITH daily_totals AS (
    SELECT o.date,
           SUM(od.quantity) AS pizzas_sold
    FROM orders AS o
    JOIN order_details AS od
        ON o.order_id = od.order_id
    GROUP BY o.date
)
SELECT ROUND(AVG(pizzas_sold), 0) AS avg_pizzas_per_day
FROM daily_totals;

-- Result:


-- Q10. What are the top 3 pizza types by revenue?
-- Like Q5, but adding up money (quantity × price) instead of quantity.
SELECT pt.name,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- Result:


-- ---------------------------------------------------------------------
-- ADVANCED
-- ---------------------------------------------------------------------

-- Q11. What percentage of total revenue does each category bring in?
-- SUM(...) OVER () is a window function: it adds up revenue across ALL
-- categories without collapsing the rows, giving the grand total on
-- every row so we can divide by it.
SELECT pt.category,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue,
       ROUND(
           SUM(od.quantity * p.price)
           / SUM(SUM(od.quantity * p.price)) OVER () * 100
       , 2) AS pct_of_revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- Result:


-- Q12. Revenue per day, with a running (cumulative) total.
-- Step 1 (CTE): revenue for each date.
-- Step 2: SUM(...) OVER (ORDER BY date) keeps adding each day onto the
--         total so far — the final row equals the Q2 total revenue.
WITH daily_revenue AS (
    SELECT o.date,
           SUM(od.quantity * p.price) AS revenue
    FROM orders AS o
    JOIN order_details AS od
        ON o.order_id = od.order_id
    JOIN pizzas AS p
        ON od.pizza_id = p.pizza_id
    GROUP BY o.date
)
SELECT date,
       ROUND(revenue, 2)                             AS daily_revenue,
       ROUND(SUM(revenue) OVER (ORDER BY date), 2)   AS cumulative_revenue
FROM daily_revenue
ORDER BY date;

-- Result:

