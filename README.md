# CowJacket dbt Project

## Overview

The CowJacket dbt project is a production-grade analytics engineering project built on **Databricks + Unity Catalog**.  
It implements a **three-layer modeling approach** with **staging**, **intermediate**, and **marts** layers to standardize, transform, and aggregate transactional data.

Key goals:

- Provide clean, reliable analytics-ready tables
- Ensure data quality via dbt tests
- Maintain CI/CD practices with PR validation
- Track dashboard dependencies via exposures
- Support incremental processing for large datasets

---

## Architecture

```
.
├── models/
│   ├── staging/          # Cleaned raw data
│   ├── intermediate/     # Aggregated & transformed tables
│   └── marts/            # Business-level fact & dimension tables
├── seeds/                # Optional reference data
├── macros/               # Reusable sql and jinja logic
├── sources/              # Source definitions
├── tests/                # Generic & custom tests
├── exposures/            # Dashboard/report lineage
└── dbt_project.yml       # Project configuration
```

- **Staging layer**: Cleans raw source tables and applies basic quality checks.
- **Intermediate layer**: Combines staging tables to prepare analytical datasets.
- **Marts layer**: Dimensions and facts used for reporting and BI tools.

---

## Environments

| Environment | Schema |
|------------|--------|
| Dev        | `cowjacket_dev` |
| Staging    | `cowjacket_staging` |
| Prod       | `cowjacket_prod` |

- **Dev**: Used for local development  
- **Staging**: CI jobs run here to validate PRs  
- **Prod**: Only builds approved code from `main` branch

---

## Sources

- **Customers**: Raw customer data  
- **Products**: Product catalog  
- **Orders**: Customer orders  
- **Order Items**: Line-level order data  
- **Loyalty Points**: Customer loyalty transactions

All sources are defined in `models/sources/raw.yml` with **column-level documentation**.

---

## Staging Models

- `stg_customers`  
- `stg_products`  
- `stg_orders`  
- `stg_order_items`  
- `stg_loyalty_points`

Features:

- Standardized columns
- Primary & foreign key tests
- Not null and unique constraints where applicable
- Ready for downstream transformations

---

## Intermediate Models

- `int_customer_orders`: Combines customers with their order history  
- `int_customer_loyalty`: Combines customers with their loyalty points 

Purpose:

- Prepares cleaned datasets for marts
- Simplifies complex transformations

---

## Marts

### Dimensions

- `dim_customers`: One row per customer, aggregated metrics

### Facts

- `fct_sales`: Fact table at order-item grain

---

## Testing & CI/CD

- **Generic tests**: Not null, unique, relationships  
- **Custom tests**: Business rules (e.g., total_amount >= sum of line totals)  
- **CI Job**: Runs on every PR against `staging` environment
  - Failing tests block merges to `main`
- **Production job**: Scheduled daily on `main` branch

---

## Exposures

- Tracks Looker dashboards
- Documents which dbt models power dashboards  
- Example:

```yaml
- name: looker_sales_dashboard
  type: dashboard
  depends_on:
    - ref('fct_sales')
    - ref('dim_customers')
  owner:
    name: Analytics Team
    email: analytics@cowjacket.com
```

---

## Observability & Logging

- Each dbt run logs:
  - Model name  
  - Environment  
  - Duration  
  - Status  
  - Row counts  
- Helps monitor performance, debug issues, and track changes over time

---

## Running the Project

### Install dbt and dependencies

```bash
pip install dbt-databricks
```

### Run models

```bash
# Run staging models
dbt run --select staging

# Run all models
dbt run

# Run tests
dbt test
```

### Generate documentation

```bash
dbt docs generate
dbt docs serve
```

---

## Notes

- Guardrails prevent production builds from running in dev.  
- Unity Catalog is used to manage schemas and ensure secure access control.  

---

## Contact

**Analytics Team**  
Email: analytics@cowjacket.com

