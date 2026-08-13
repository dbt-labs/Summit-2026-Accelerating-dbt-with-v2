# Exploring dbt Fusion: static analysis in action

In this exercise, you'll use Fusion's static analysis features — hover-over insights, SQL correctness checks, and column definition tracing — to add a new column to a model and trace where its inputs come from.

**Step 1: Open the model**
Navigate to dim_customers.sql in your dbt project.

**Step 2: Define the task**
You need to classify customers who have spent more than $1,000 over their lifetime as high_spender, and everyone else as low_spender.

**Step 3: Preview the model**
Preview dim_customers.sql and review the existing columns before making changes.

**Step 4: Add the new column**
In the final CTE, add a new column under total_tax_paid. Starting on line 50, add the following code:

```
case
    when customer_orders_summary.total_spend_pretax > 1000 then 'high_spender'
    else 'low_spender'
    customer_spend_level
```

**Step 5: Save and check for errors**
Save the file. You should see a red underline under customer_spend_level.

**Step 6: Read the error**
Hover over the underlined text to read the error message. See if you can spot the mistake before moving on.

**Step 7: Fix the error**
The case statement is missing end as before the column alias. Add end as after 'low_spender', then save again. This is Fusion giving you real-time feedback on SQL correctness.

**Step 8: Read the second error**
Now there's a red underline underneath 'total_spend'. Hover over it to understand what's wrong. See if you can figure out what's wrong.

**Step 9: Fix the second error**
The case statement is missing a comma after customer_spend_level. Add it, and re-save.

**Step 10: Confirm the data type**
Hover over customer_spend_level to confirm its data type. Since this column is built from a string transformation, you should see it's a VARCHAR.

**Step 11: Trace the source column**
Highlight total_spend_pretax, right-click, and choose Peek Definition. Confirm that it's defined as subtotal, summed and grouped by customer.

**Step 12: Go to the next definition**
Scroll up to where subtotal is summed, around line 25. Right-click it and choose Go to Definition to jump to stg_jaffle_shop_orders.sql, where subtotal was first defined.

## Wrap-up

You've now used three important static analysis features covered in this lesson: hover-over insights, correctness checks, and column definition tracing to build a new column and trace its lineage back to the source.
