
USE [practice];


-- Read the tables:
SELECT TOP (10) * FROM igaming.players ORDER BY player_id;
SELECT * FROM igaming.games ORDER BY game_id;
SELECT TOP (10) * FROM igaming.payments ORDER BY payment_id;
SELECT TOP (10) * FROM igaming.gaming_activity ORDER BY activity_id;


-- Task: Calculate total stakes, total winnings and gross gaming revenue.

SELECT
    SUM(stakes) AS total_stakes,
    SUM(winnings) AS total_winnings,
    SUM(stakes - winnings) AS gross_gaming_revenue,
    COUNT(DISTINCT player_id) AS active_players,
    SUM(rounds) AS total_rounds
FROM practice.igaming.gaming_activity;

-- Task: Compare activity for each of the 3 months;
SELECT
    DATEFROMPARTS(YEAR(activity_date), MONTH(activity_date), 1) AS activity_month,
    COUNT(DISTINCT player_id) AS active_players,
    SUM(stakes) AS total_stakes,
    SUM(winnings) AS total_winnings,
    SUM(stakes - winnings) AS ggr
FROM practice.igaming.gaming_activity
GROUP BY
    DATEFROMPARTS(YEAR(activity_date), MONTH(activity_date), 1)
ORDER BY activity_month;


-- Task: See the depostis for each month and provider

SELECT
    DATEFROMPARTS(YEAR(submitted_at), MONTH(submitted_at), 1) AS payment_month,
    provider,
    COUNT(*) AS deposit_attempts,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_deposits,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed_deposits,
    SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_deposits,
    CAST(
        100.0 * SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS success_rate_pct
FROM practice.igaming.payments
WHERE payment_type = 'Deposit'
GROUP BY
    DATEFROMPARTS(YEAR(submitted_at), MONTH(submitted_at), 1),
    provider
ORDER BY payment_month, provider;


--Task: 7-day deposit
WITH first_deposits AS (
    SELECT
        player_id,
        MIN(submitted_at) AS first_deposit_at
    FROM practice.igaming.payments
    WHERE payment_type = 'Deposit'
      AND status = 'Completed'
    GROUP BY player_id
),
conversion AS (
    SELECT
        p.player_id,
        p.acquisition_channel,
        CASE
            WHEN f.first_deposit_at >= p.registration_date
             AND f.first_deposit_at < DATEADD(day, 7, p.registration_date)
            THEN 1 ELSE 0
        END AS converted
    FROM practice.igaming.players p
    LEFT JOIN first_deposits f ON p.player_id = f.player_id
    WHERE DATEADD(day, 7, p.registration_date) <= '2026-04-01'
)
SELECT
    acquisition_channel,
    COUNT(*) AS registered_players,
    SUM(converted) AS converted_players,
    CAST(
        100.0 * SUM(converted) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS conversion_rate_pct
FROM conversion
GROUP BY acquisition_channel
ORDER BY conversion_rate_pct DESC;


WITH player_cohorts AS (
    SELECT
        player_id,
        DATEFROMPARTS(
            YEAR(MIN(activity_date)),
            MONTH(MIN(activity_date)), 1
        ) AS cohort_month
    FROM practice.igaming.gaming_activity
    GROUP BY player_id
),
cohort_sizes AS (
    SELECT cohort_month, COUNT(*) AS cohort_size
    FROM player_cohorts
    GROUP BY cohort_month
),
active_months AS (
    SELECT DISTINCT
        player_id,
        DATEFROMPARTS(
            YEAR(activity_date), MONTH(activity_date), 1
        ) AS activity_month
    FROM practice.igaming.gaming_activity
),
months AS (
    SELECT DISTINCT
        DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) AS activity_month
    FROM practice.igaming.calendar
)
SELECT
    c.cohort_month,
    DATEDIFF(month, c.cohort_month, m.activity_month) AS months_since_first_activity,
    c.cohort_size,
    COUNT(a.player_id) AS returning_players,
    CAST(
        100.0 * COUNT(a.player_id) / c.cohort_size
        AS DECIMAL(5,2)
    ) AS retention_pct
FROM cohort_sizes c
JOIN months m ON m.activity_month >= c.cohort_month
JOIN player_cohorts p ON p.cohort_month = c.cohort_month
LEFT JOIN active_months a
    ON a.player_id = p.player_id
   AND a.activity_month = m.activity_month
GROUP BY c.cohort_month, m.activity_month, c.cohort_size
ORDER BY c.cohort_month, months_since_first_activity;


SELECT
    g.game_name,
    g.game_category,
    COUNT(DISTINCT a.player_id) AS active_players,
    SUM(a.rounds) AS total_rounds,
    SUM(a.stakes) AS total_stakes,
    SUM(a.winnings) AS total_winnings,
    SUM(a.stakes - a.winnings) AS ggr,
    CAST(
        100.0 * SUM(a.stakes - a.winnings)
        / NULLIF(SUM(a.stakes), 0)
        AS DECIMAL(6,2)
    ) AS ggr_pct_of_stakes
FROM practice.igaming.gaming_activity a
JOIN practice.igaming.games g ON a.game_id = g.game_id
GROUP BY g.game_name, g.game_category
ORDER BY ggr DESC;