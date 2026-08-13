# Task 2 Answer Key: fct_daily_store_sales

## Walkthrough & Explanation

### 1️⃣ Incorrect ref() to staging model

Bug in starter:
```
from {{ ref('stg_jaffle_shop__order') }}
```

Correct version:
```
from {{ ref('stg_jaffle_shop__orders') }}
```

dbt v2 feature highlight: Hover over insights on the error shows unresolved node.

### 2️⃣ Misspelled column names in orders CTE

Bug in starter:
```
orderedat, sub_total
```

Correct version:
```
ordered_at, subtotal
```

dbt v2 feature highlight: Hover over the error message to see available column names.

### 3️⃣ Misspelled column names in stores CTE

Bug in starter:
```
store_locaton, taxrate
```

Correct version:
```
store_location, tax_rate
```

dbt v2 feature highlight: Hover over the error message to see available column names.

### 4️⃣ Selecting a column that doesn't exist

Bug in starter:
```
is_open
```

Problem: This column does not exist in the stores dataset.

Correct version: Removed from the CTE entirely.

dbt v2 feature highlight: Real-time error detection flags unresolved column references.

### 5️⃣ GROUP BY missing non-aggregated columns

Bug in starter: store_location and tax_rate selected but not included in GROUP BY.

Problem: Every non-aggregated column in the SELECT must appear in the GROUP BY to hit the store + day grain.

Correct version:
```
group by
    orders.store_id,
    stores.store_location,
    stores.tax_rate,
    order_date
```

dbt v2 feature highlight: dbt v2 surfaces GROUP BY errors immediately with clear messages such as "column must appear in the GROUP BY clause or be used in an aggregate function." Hovering the error highlights exactly which column is missing.

### 6️⃣ Divide-by-zero risk in avg_order_total

Bug in starter:
```
daily_order_total / orders_count
```

Problem: Causes a divide-by-zero error on days with no orders.

Correct version:
```
daily_order_total / nullif(orders_count, 0)
```

dbt v2 feature highlight: Use CTE previews to sanity-check calculated fields — even when SQL runs successfully, previewing results helps catch logic errors that do not produce compilation failures.

### 7️⃣ Reversed date difference in days_since_store_open

Bug in starter:
```
datediff('day', order_date, stores.opened_at)
```

Problem: A reversed date difference calculation will run successfully but produce negative values for most rows.

Correct version:
```
datediff('day', stores.opened_at, order_date)
```

Why this matters: The corrected calculation ensures values are 0 or positive, and the direction of the date difference reflects "order date minus opened date."

dbt v2 feature highlight: Preview results to sanity-check calculated fields even when SQL compiles successfully.

## Final Validation Checklist

You are done when:
- It runs with zero errors
- The output contains exactly one row per store_id per day
- Aggregated totals are consistent and plausible
- avg_order_total is reasonable
- days_since_store_open is never negative
- Results are sorted by order_date desc, store_id
