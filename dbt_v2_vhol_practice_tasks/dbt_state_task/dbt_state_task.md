# dbt State activity: configuring model freshness

## Goal

In this activity, you'll modify model-level lag_tolerance configs and observe how a dbt State job behaves as a result.

You will:
- Add lag_tolerance to two models
- Run the same job twice
- Predict what will happen before each run
- Explain the results using dbt state logic

Reference documentation: https://docs.getdbt.com/docs/deploy/dbt-state-lag-tolerance?version=2.0

## Part 1: Run env on custom branch, ensure dbt State is enabled

1. Copy your branch name from dbt Studio.
2. In dbt Platform, navigate to Orchestration → Environments.
3. Open "Production Environment"
4. Click into the environment's Settings.
5. Click "Edit"
6. Under 'Environment settings' click the "Only run on a custom branch" checkbox.
7. In the resulting text box, paste your branch name.
8. Save.
9. Navigate to Orchestration → Jobs.
10. Click 'Prod Job'
11. Underneath the "Prod Job" heading, you should see a checkmark icon with 'dbt State' to verify state is enabled. If it's not enabled, you should have text boxes prompting you to enable it.

## Part 2: Update model freshness configs

You will edit two YAML files:
- customers.yml
- stg_orders.yml

### Step 1: Update customers.yml

**Objective**

Set lag_tolerance to 3 hours for customers model.

**Instructions**

1. Open models/marts/customers.yml.
2. Add the following config: block directly under the description:

```yaml
- name: customers
  description: This model....
  config:
    state:
      lag_tolerance: 3h
  columns:
    - name: customer_id
```

This means:
- Even if upstream data changes, this model will only rebuild if at least 3 hours have passed since its last build.

Save the file, and commit your changes.

### Step 2: Update stg_orders.yml

Now you'll update two staging models inside the same YAML file.

Open models/staging/jaffle_shop/stg_orders.yml.

**Objective**

Set lag_tolerance to 2 minutes on stg_orders.

**Instructions**

1. Open models/staging/stg_orders.yml.
2. Add the following config: block directly under the description:

```yaml
- name: stg_orders
  description: This model....
  config:
    state:
      lag_tolerance: 2m
  columns:
    - name: order_id
```

This means:
- Even if upstream data changes, this model will only rebuild if at least 2 minutes have passed since its last build.

Save the file and commit your changes

## Part 3: Run the job

You are about to run the job. Your workshop leader (if you attended live!) is about to introduce new data into your sources.

‼️ If you are performing these exercises async–you will not see any change as no new data will be introduced asynchronously. You'll only see new data if you attend live.

Before you click Run, pause.

### Prediction Exercise — Run #1

For each model below, write down:
- Will it build?
- Will it be reused?
- Why?

Models to evaluate:
- customers
- stg_orders

Consider:
- Has enough time passed since the last build to satisfy your configured lag_tolerance?
- Did upstream data change?

Once you've written your predictions:

1. Go to Orchestration → Jobs
2. Click Run now on the Prod Job.

As the run executes:
- Watch which models are marked as built.
- Watch which models are reused/skipped.

After the run completes, record what actually happened.

## Part 4: Run the job again

Now, without changing anything else, you will run the same job again. Your instructor will not introduce new data this time.

Before clicking Run:

### Prediction Exercise — Run #2

For each model:
- What will happen this time?
- Why?

Write your predictions.

Then:

1. Click Run now again.
2. Observe the results.
3. Compare expected vs actual behavior.
