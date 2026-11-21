# Getting the data

The CSV files aren't stored in this repo — download them free from Maven Analytics.

## 1. Download

1. Go to <https://mavenanalytics.io/data-playground>
2. Search for **Pizza Place Sales** and download the zip.
3. Unzip it. You should have:
   - `orders.csv`
   - `order_details.csv`
   - `pizzas.csv`
   - `pizza_types.csv`
   - `data_dictionary.csv` (descriptions of each column — worth a read)

## 2. Install MySQL (one-time)

- Download **MySQL Community Server** and **MySQL Workbench** from <https://dev.mysql.com/downloads/>
  (on Windows, the "MySQL Installer" sets up both at once).
- During setup, choose a root password and write it down.

## 3. Create the tables

1. Open MySQL Workbench and connect to your local server.
2. File → Open SQL Script → `sql/01_create_tables.sql`
3. Click the ⚡ lightning bolt to run it. You should see `pizza_sales` appear under **Schemas** (click refresh if not).

## 4. Import the CSVs

Import in this order (parent tables first, so the links between tables work):

1. `pizza_types`
2. `pizzas`
3. `orders`
4. `order_details`

For each one:

1. In the Schemas panel, expand `pizza_sales` → `Tables`.
2. Right-click the table → **Table Data Import Wizard**.
3. Pick the matching CSV file.
4. Choose **Use existing table** and select the same table name.
5. Check the column mapping, then Next → Next → Finish.

> ⚠️ **If `pizza_types` fails or shows odd characters:** that file contains accented characters. In the wizard's options, set the encoding to `latin1`, or open the file in Excel and *Save As → CSV UTF-8* first.

## 5. Check it worked

Run this — you should get roughly these counts:

```sql
USE pizza_sales;
SELECT 'orders'        AS tbl, COUNT(*) FROM orders
UNION ALL SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL SELECT 'pizzas',        COUNT(*) FROM pizzas
UNION ALL SELECT 'pizza_types',   COUNT(*) FROM pizza_types;
```

| tbl | approx. rows |
|---|---|
| orders | 21,350 |
| order_details | 48,620 |
| pizzas | 96 |
| pizza_types | 32 |
