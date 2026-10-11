# iGaming Performance Analysis

**SQL Server | Tableau | Revenue Analysis | Payment Performance | Cohort Retention**

A business intelligence portfolio project analysing gaming revenue, deposit success and player retention using **synthetic data** for January–March 2026. All monetary amounts are in euros.

## Objectives

- Track monthly gross gaming revenue (GGR).
- Compare revenue across games.
- Evaluate payment-provider deposit success.
- Analyse player retention across monthly cohorts.
- Present findings in a Tableau dashboard.

## Dashboard

Open **[iGaming-Portfolio.twbx](iGaming-Portfolio.twbx)** in Tableau Public or Tableau Desktop. The packaged workbook includes its reporting data and four worksheets:

| Worksheet | Purpose |
| --- | --- |
| Monthly GGR | Track revenue across the quarter. |
| GGR by Game | Compare individual game revenue. |
| Deposit Success by Provider | Compare completed deposit-request rates. |
| Cohort Retention | Track players returning in subsequent months. |

## Key metrics

| Metric | Q1 2026 result |
| --- | ---: |
| Total stakes | €1,070,821.90 |
| Total winnings | €997,210.51 |
| Gross gaming revenue | €73,611.39 |
| Active players | 941 |
| Hold rate | 6.87% |

## Findings

- **Revenue grew across the quarter:** GGR increased from €11,016.07 in January to €25,492.72 in February and €37,102.60 in March. Active-player growth and revenue per player would need further analysis to explain the change.
- **Slots contributed 64.54% of GGR:** Aurora Slots and Ocean Spins generated €47,512.08 combined. Aurora Slots was the highest-revenue game at €26,249.75.
- **CardPay showed a February decline:** deposit success fell from 95.59% in January to 78.25% in February, recovering to 94.29% in March. Its quarterly rate was 88.83%, compared with 95.47% for BankTransfer and 95.62% for SwiftWallet. This warrants investigation; the dataset does not establish a root cause.
- **Observed retention was high:** the January cohort retained 98.81% in month 1 and 97.92% in month 2. The February cohort retained 99.11% in month 1. These values reflect synthetic data, not industry benchmarks.

## Files

- `iGaming-Portfolio.twbx` — Tableau dashboard, four worksheets and embedded reporting data.
- `gaming.csv` — 12,100 player/game/date activity records, including stakes, winnings and GGR.
- `payments.csv` — 6,715 deposit and withdrawal requests with provider and status.
- `retention.csv` — six cohort/month records with cohort size, active players and retention rate.
- `Tableau tables.sql` — SQL Server schema and underlying table definitions.
- `Tableau project script.sql` — SQL queries to filter data.

The CSVs are exported reporting datasets. The SQL script defines the underlying raw-data tables; it does not import these reporting CSVs. The Tableau workbook can be opened directly without setting up SQL Server.

## KPI definitions

- **GGR:** stakes minus winnings; revenue, not profit.
- **Active players:** distinct players with gaming activity during the selected period.
- **Hold:** GGR divided by stakes.
- **Deposit success:** completed deposit requests divided by all deposit requests, including failed and pending requests.
- **Retention:** active cohort players in month N divided by cohort size. Cohorts use the first observed gaming month. Month 0 is 100% by definition; unobserved future months remain blank.

## Validation

Record IDs were checked for uniqueness. GGR arithmetic, currency, dashboard totals, payment success rates and all six retention values were independently checked against the CSVs. All four charts were visually inspected together in Tableau.

## Skills demonstrated

SQL reporting, data validation, KPI calculation, revenue analysis, payment performance analysis, cohort analysis and Tableau dashboard development.

## Data scope

All data is fictional and generated for this portfolio project. It contains no real customer. Findings demonstrate analytical methods.
