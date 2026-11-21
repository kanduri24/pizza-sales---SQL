# 🍕 Pizza Sales Analysis — SQL

Analysing a full year of orders from a pizza restaurant to answer real business questions: what sells, when customers order, and where the revenue comes from.

**Tools:** MySQL 8 · MySQL Workbench
**Skills shown:** joins, aggregation, filtering, date/time functions, subqueries, CTEs, window functions

---

## The business problem

The restaurant owner wants to know:

- How busy are we, and how much are we making?
- Which pizzas and sizes sell best — and which earn the most?
- What times of day are busiest, so staffing can match demand?
- Which menu categories drive revenue?

## The data

Four tables covering ~21,000 orders (~48,000 pizzas) placed during one year.

| Table | What it holds |
|---|---|
| `orders` | One row per order — date and time |
| `order_details` | Each pizza on an order and its quantity |
| `pizzas` | Each pizza on the menu, its size and price |
| `pizza_types` | Pizza name, category (Classic, Veggie, Supreme, Chicken) and ingredients |

```
pizza_types 1──* pizzas 1──* order_details *──1 orders
```

Source: [Maven Analytics — Pizza Place Sales](https://mavenanalytics.io/data-playground) (free). See [`data/README.md`](data/README.md) for download and import steps.

## Project structure

```
├── data/README.md                  how to get and import the data
├── sql/01_create_tables.sql        creates the database and tables
├── sql/02_analysis.sql             the 12 business questions + my queries
└── docs/HINTS.md                   hints used while solving
```

## Questions answered

**Basic**
1. Total number of orders placed
2. Total revenue generated
3. Highest-priced pizza
4. Most common pizza size ordered
5. Top 5 pizza types by quantity sold

**Intermediate**

6. Total quantity sold per category
7. Orders by hour of the day
8. Revenue by month
9. Average number of pizzas sold per day
10. Top 3 pizza types by revenue

**Advanced**

11. Each category's percentage share of total revenue
12. Cumulative (running total) revenue over the year

## Key findings

> ✏️ *Fill these in once your queries are done — this is the section recruiters read first. Write each as one plain-English sentence with a number.*

- **Revenue:** …
- **Best seller:** …
- **Peak hours:** …
- **Size:** …
- **Category mix:** …

## Recommendations

> ✏️ *2–3 actions the owner could take based on the findings (e.g. staffing at peak hours, promoting a slow seller, menu changes).*

1. …
2. …

## What I learned

> ✏️ *One or two sentences — e.g. which SQL concept clicked, what was tricky.*

---

*Part of my data analytics portfolio — [github.com/kanduri24](https://github.com/kanduri24)*
