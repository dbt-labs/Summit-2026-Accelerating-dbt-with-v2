# Task 1: Build fct_orders by Debugging a Broken Starter Model

Your team wants a reliable orders fact table for downstream analytics. It should have exactly one row per order, with clean order totals in dollars, item counts, and store tax context.

A colleague started the fct_orders model, but it's currently broken: some issues will stop the query from running, and others will produce incorrect results even after it runs.

Your job is to use dbt dbt v2 to debug and complete the model.

## Use dbt v2 Features Intentionally

While working, lean on dbt v2's:
- Real-time error messages (fix compile and SQL issues quickly)
- Hover tooltips (confirm column names and data types)
- CTE previews (validate row counts and grain)
- Go to Definition / Peek Definition (inspect upstream staging models)
- Rename Symbol (refactor safely if needed)

## Your Task

Open the dbt_v2_vhol_practice_tasks folder and the task_1 subfolder. Inside, you'll find a file called:

```
task_1_fct_orders_buggy.sql
```

Move this file into your models/marts directory.

Fix the query so that it produces an orders fact table with:

- One row per order_id
- Dollars-based measures from stg_jaffle_shop__orders:
  - subtotal
  - tax_paid
  - order_total
- Store context from stg_jaffle_shop__stores:
  - tax_rate
  - store_location
- Item-level rollups from stg_jaffle_shop__order_items:
  - items_count
  - distinct_products_count
- Calculated fields:
  - expected_tax = subtotal * tax_rate
  - tax_delta = tax_paid - expected_tax

Use CTE previews to confirm:
- Item rollups are at true order grain
- The final model does not duplicate orders

## Acceptance Criteria

- The model runs successfully with zero errors.
- The final result contains exactly one row per order_id.
- tax_rate is populated.
- expected_tax and tax_delta calculate without type issues.
- Results are sorted cleanly by order date.
