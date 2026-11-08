# QuickBazaar-SQL-Functions-Stored-Procedures-Cursors-Project

## Project Overview
This project demonstrates advanced MySQL programming concepts implemented on the `quickbazaar_db` schema. It showcases custom database logic using stored functions, modular automation through stored procedures, and iterative row-level data processing utilizing explicit database cursors for inventory valuation and customer loyalty management.

---

## Database & Schema Context
* **Database Name:** `quickbazaar_db`
* **Core Tables Involved:** `customers`, `products`, `orders`, `order_items`

---

## Key SQL Modules Implemented

### 1. User-Defined Functions (UDFs)
* **`fn_calculate_margin`**: Computes product profit margins dynamically based on retail price and unit cost parameters.
* **`fn_tier`**: Classifies customer loyalty tiers into 'GOLD', 'SILVER', or 'BRONZE' based on historical loyalty points balance.
* **`fn_format_full_name`**: Standardizes string manipulation by formatting and capitalizing compound text values (e.g., concatenating customer first and last names into `"LASTNAME, Firstname"`).

### 2. Stored Procedures & Automation
* **`get_customers`**: Basic modular retrieval query wrapping customer demographic data.
* **`proc_customers_order`**: Multi-query transaction block fetching integrated data from both customer and order tables simultaneously.
* **`all_city_customers`**: Parameterized procedure (`IN city_name`) utilizing multi-table `JOIN` operations to filter customer transactions and order totals by specific geographic regions (e.g., Mumbai).

### 3. Advanced Cursors & Procedural Logic
* **`sp_audit_inventory_valuation`**: Implements a cursor-driven loop to iterate through warehouse product records, computing aggregate inventory asset valuation.
* **`bonus_evaluation`**: Employs conditional procedural flow control and row-by-row cursor logic to calculate and increment regional customer loyalty point bonuses dynamically.

---

## Repository Structure
```text
├── function_practice.sql    # Complete source code for functions, procedures, and cursor routines
└── README.md                # Professional documentation and module overview
