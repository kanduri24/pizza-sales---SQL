# Hints

Try each question yourself first. If you're stuck, read **one** hint, then go back and try again before reading the next.

**Quick reminder of how the tables link:**

```
order_details.pizza_id   →  pizzas.pizza_id
pizzas.pizza_type_id     →  pizza_types.pizza_type_id
order_details.order_id   →  orders.order_id
```

Anything involving **revenue** needs `order_details.quantity × pizzas.price`, so it needs a join between those two tables.

---

## Basic

**Q1 — Total orders**
1. Each row in `orders` is one order.
2. `COUNT()` counts rows.

**Q2 — Total revenue**
1. Join `order_details` to `pizzas` on `pizza_id`.
2. `SUM(quantity * price)`
3. Wrap it in `ROUND(..., 2)`.

**Q3 — Highest-priced pizza**
1. The price is in `pizzas`, the name is in `pizza_types` — join them.
2. `ORDER BY price DESC`
3. `LIMIT 1`

**Q4 — Most common size**
1. Join `order_details` to `pizzas` to get the size of each pizza ordered.
2. `GROUP BY size`
3. Decide: count rows, or sum `quantity`? (Think about what "ordered most often" means — both are defensible, just say which you used.)

**Q5 — Top 5 by quantity**
1. You need three tables: `order_details` → `pizzas` → `pizza_types`.
2. `GROUP BY` the pizza name, `SUM(quantity)`.
3. Sort descending, `LIMIT 5`.

## Intermediate

**Q6 — Quantity by category**
1. Same three-table join as Q5.
2. Group by `category` instead of name.

**Q7 — Orders by hour**
1. Only the `orders` table is needed.
2. `HOUR(time)` pulls the hour out of a time.
3. Group by that, count orders.

**Q8 — Revenue by month**
1. Join `order_details` → `pizzas` (for price) and `order_details` → `orders` (for date).
2. `MONTH(date)` gives a month number; `MONTHNAME(date)` gives the name.
3. Group by the month number so they sort Jan–Dec.

**Q9 — Average pizzas per day**
1. Do it in two steps: first get total quantity **per date**.
2. Put that query inside brackets as a subquery (or a CTE using `WITH`), then take the `AVG()` of it.

**Q10 — Top 3 by revenue**
1. Same joins as Q5, but `SUM(quantity * price)` instead of `SUM(quantity)`.

## Advanced

**Q11 — Category % of revenue**
1. You need two numbers: revenue per category, and total revenue.
2. Total revenue is your Q2 query — you can use it as a subquery in the `SELECT`.
3. `category_revenue / total_revenue * 100`, rounded.
4. *Alternative:* `SUM(...) OVER ()` gives the grand total without a subquery.

**Q12 — Running total**
1. First build revenue **per date** (a CTE works well: `WITH daily AS (...)`).
2. Then select from it and add `SUM(revenue) OVER (ORDER BY date)`.
3. This is a **window function** — worth reading up on, they come up in interviews a lot.

---

### General tips
- Build big queries in small steps: get the join working first, check a few rows with `LIMIT 10`, then add `GROUP BY`.
- Give columns clear names with `AS`, e.g. `SUM(quantity) AS total_sold`.
- Sense-check answers: does the total revenue look like a realistic year for a restaurant?
