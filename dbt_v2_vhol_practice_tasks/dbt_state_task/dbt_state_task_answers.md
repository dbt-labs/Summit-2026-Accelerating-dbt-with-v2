# Answer key: dbt state behavior

## First dbt state run

- **customers → Reused**
  - It did not meet its lag_tolerance: 3 hours threshold.
  - Check the logs to ensure they say that the model was reused due to lag_tolerance timing.
- **stg_orders → Rebuilt**
  - Changes were detected.
  - Its lag_tolerance: 2 minutes threshold was satisfied – data were only updated once in this workshop.

## Second dbt state run

- **Both models → Reused**
  - No additional changes detected.
  - No models qualified for rebuild under their freshness and update rules.
