# Task 3 Answer Key: fct_perishable_product_daily

## Walkthrough & Explanation

### 1️⃣ Incorrect ref() to order_items staging model

Bug in starter:
```
from {{ ref('stg_jaffle_shop__order_item') }}
```

Correct version:
```
from {{ ref('stg_jaffle_shop__order_items') }}
```

dbt v2 feature highlight: Hover over insights on the error shows unresolved node.

### 2️⃣ Incorrect ref() to products staging model

Bug in starter:
```
from {{ ref('stg_jaffle_shop__product') }}
```

Correct version:
```
from {{ ref('stg_jaffle_shop__products') }}
```

dbt v2 feature highlight: Hover over insights on the error shows unresolved node.

### 3️⃣ Incorrect column name in supplies CTE

Bug in starter:
```
is_perishable
```

Correct version:
```
is_perishable_supply
```

dbt v2 feature highlight: Hover over the error message to see available column names.

### 4️⃣ Incorrect GROUP BY in perishable_supply_costs

Bug in starter:
```
group by supply_id
```

Problem: This does not produce one row per product.

Correct version:
```
group by product_id
```

dbt v2 feature highlight: Preview the CTE to confirm one row per product_id.

### 5️⃣ Incorrect date_trunc() function call

Bug in starter:
```
date_trunc(orders.ordered_at)
```

Problem: Wrong number of arguments — date_trunc requires a precision argument.

Correct version:
```
date_trunc('day', orders.ordered_at)
```

dbt v2 feature highlight: Function signature hints appear when arguments are incorrect.

### 6️⃣ GROUP BY breaks day grain

Bug in starter:
```
group by order_date, order_items.product_id, orders.ordered_at
```

Problem: Including orders.ordered_at alongside the truncated order_date breaks the intended day grain.

Correct version:
```
group by order_date, order_items.product_id
```

dbt v2 feature highlight: Preview the CTE to confirm one row per product_id per day.

### 7️⃣ Missing default value in coalesce()

Bug in starter:
```
coalesce(perishable_supply_costs.perishable_supply_cost)
```

Problem: coalesce needs a fallback value, otherwise products with no perishable supplies null out or error.

Correct version:
```
coalesce(perishable_supply_costs.perishable_supply_cost, 0)
```

dbt v2 feature highlight: Function signature hints flag incorrect argument counts.

### 8️⃣ Duplicate/conflicting daily_perishable_cost and daily_profit logic

Bug in starter: The final CTE contains a redundant/duplicated daily_perishable_cost calculation and an inline (uncoalesced) perishable_supply_cost reference inside daily_profit, both of which conflict with the corrected definitions above. Both should be coalesced!

Correct version: Keep a single, consistent calculation for each field:
```
coalesce(perishable_supply_costs.perishable_supply_cost, 0) as perishable_supply_cost,
coalesce(perishable_supply_costs.perishable_supply_cost, 0) * daily_product_sales.items_sold as daily_perishable_cost,
daily_revenue - daily_perishable_cost as daily_profit
```

dbt v2 feature highlight: CTE preview surfaces duplicate/conflicting column definitions and unexpected nulls in downstream calculations.

## Acceptance Criteria

You're done when:
- It runs with zero errors
- The output contains exactly one row per product per day
- The results are sorted by order_date desc, product_id
