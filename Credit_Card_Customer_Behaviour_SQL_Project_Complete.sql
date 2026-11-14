/*
PROJECT: Credit Card Customer Behaviour & Portfolio Analysis
TOOLS: MySQL 8.0+
DATABASE: credit_card_project
MAIN TABLE: credit_card_customers_cleaned
EXPECTED ROWS: 8,950

IMPORTANT:
- This script is designed for the existing cleaned table.
- It does not drop, truncate, or overwrite tables.
- Run analytical SELECT sections as needed; running the script again is not
  required if you already executed the queries successfully.
- Descriptive patterns are not causal conclusions or credit-risk classifications.
*/

USE credit_card_project;

-- ============================================================
-- SECTION 0: DATASET VALIDATION
-- ============================================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    SUM(customer_id IS NULL) AS missing_customer_ids
FROM credit_card_customers_cleaned;

-- ============================================================
-- SECTION 1: OVERALL PORTFOLIO KPIs
-- ============================================================
SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(cash_advance), 2) AS average_cash_advance,
    ROUND(AVG(payments), 2) AS average_payments,
    ROUND(AVG(minimum_payments_clean), 2) AS average_cleaned_minimum_payment,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit,
    ROUND(AVG(tenure), 2) AS average_tenure_months
FROM credit_card_customers_cleaned;

-- ============================================================
-- SECTION 2: PURCHASE ACTIVITY
-- Verified result from user's Workbench:
-- Has purchases: 6,906 (77.16%); avg purchases 1,300.13;
-- avg balance 1,390.82; avg payments 1,756.83.
-- No purchases recorded: 2,044 (22.84%); avg balance 2,151.20;
-- avg payments 1,653.13.
-- ============================================================
SELECT
    CASE WHEN purchases > 0 THEN 'Has purchases'
         ELSE 'No purchases recorded' END AS purchase_group,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_card_customers_cleaned), 2)
        AS customer_percentage,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(payments), 2) AS average_payments
FROM credit_card_customers_cleaned
GROUP BY purchase_group
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 3: CASH ADVANCE BEHAVIOUR
-- Verified result from user's Workbench:
-- No cash advance: 4,628 (51.71%); avg purchases 1,348.17;
-- avg balance 792.73; avg payments 1,433.04.
-- Cash advance users: 4,322 (48.29%); avg cash advance 2,027.05;
-- avg purchases 633.82; avg balance 2,390.86; avg payments 2,054.49.
-- ============================================================
SELECT
    CASE WHEN cash_advance > 0 THEN 'Cash advance user'
         ELSE 'No cash advance' END AS cash_advance_group,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_card_customers_cleaned), 2)
        AS customer_percentage,
    ROUND(AVG(cash_advance), 2) AS average_cash_advance,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(payments), 2) AS average_payments
FROM credit_card_customers_cleaned
GROUP BY cash_advance_group
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 4: PURCHASE TYPE (ONE-OFF / INSTALMENTS)
-- ============================================================
SELECT
    CASE
        WHEN oneoff_purchases > 0 AND installments_purchases > 0 THEN 'Both types'
        WHEN oneoff_purchases > 0 THEN 'One-off only'
        WHEN installments_purchases > 0 THEN 'Instalments only'
        ELSE 'No purchase amount recorded'
    END AS purchase_type_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchases), 2) AS average_total_purchases,
    ROUND(AVG(oneoff_purchases), 2) AS average_oneoff_purchases,
    ROUND(AVG(installments_purchases), 2) AS average_instalment_purchases
FROM credit_card_customers_cleaned
GROUP BY purchase_type_segment
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 5: PURCHASE FREQUENCY
-- ============================================================
SELECT
    CASE
        WHEN purchases_frequency = 0 THEN 'No purchase frequency'
        WHEN purchases_frequency < 0.34 THEN 'Low frequency'
        WHEN purchases_frequency < 0.67 THEN 'Medium frequency'
        ELSE 'High frequency'
    END AS purchase_frequency_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(purchases_trx), 2) AS average_purchase_transactions,
    ROUND(AVG(balance), 2) AS average_balance
FROM credit_card_customers_cleaned
GROUP BY purchase_frequency_segment
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 6: CREDIT LIMIT BANDS
-- Verified result from user's Workbench:
-- Below 2,000: 2,619; avg balance 635.02; avg purchases 421.73;
-- avg payments 761.92.
-- 2,000-4,999: 3,044; avg balance 1,093.87; avg purchases 740.82;
-- avg payments 1,302.86.
-- 5,000-9,999: 2,446; avg balance 2,233.83; avg purchases 1,357.16;
-- avg payments 2,317.77.
-- 10,000 and above: 841; avg balance 4,215.51; avg purchases 2,734.24;
-- avg payments 4,614.76.
-- ============================================================
SELECT
    CASE
        WHEN credit_limit IS NULL THEN 'Missing credit limit'
        WHEN credit_limit < 2000 THEN 'Below 2,000'
        WHEN credit_limit < 5000 THEN '2,000-4,999'
        WHEN credit_limit < 10000 THEN '5,000-9,999'
        ELSE '10,000 and above'
    END AS credit_limit_band,
    COUNT(*) AS customer_count,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(payments), 2) AS average_payments
FROM credit_card_customers_cleaned
GROUP BY credit_limit_band
ORDER BY MIN(credit_limit);

-- ============================================================
-- SECTION 7: BALANCE-TO-CREDIT-LIMIT RATIO
-- Descriptive grouping; not an official credit score.
-- ============================================================
SELECT
    CASE
        WHEN credit_limit IS NULL OR credit_limit <= 0 THEN 'No valid credit limit'
        WHEN balance / credit_limit < 0.30 THEN 'Below 30%'
        WHEN balance / credit_limit < 0.70 THEN '30%-69%'
        ELSE '70% or higher'
    END AS balance_to_limit_band,
    COUNT(*) AS customer_count,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit,
    ROUND(AVG(purchases), 2) AS average_purchases
FROM credit_card_customers_cleaned
GROUP BY balance_to_limit_band
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 8: FULL-PAYMENT FREQUENCY
-- Verified result from user's Workbench:
-- No full payment recorded: 5,903; avg frequency 0; avg payments
-- 1,315.85; avg balance 2,065.01; avg cleaned minimum payment 1,089.39.
-- Frequency below 0.50: 1,771; avg frequency 0.19; avg payments
-- 2,769.88; avg balance 886.14; avg cleaned minimum payment 494.28.
-- Frequency 0.50 or higher: 1,276; avg frequency 0.815; avg payments
-- 2,224.71; avg balance 190.40; avg cleaned minimum payment 200.52.
-- ============================================================
SELECT
    CASE
        WHEN prc_full_payment = 0 THEN 'No full payment recorded'
        WHEN prc_full_payment < 0.50 THEN 'Full-payment frequency below 0.50'
        ELSE 'Full-payment frequency 0.50 or higher'
    END AS full_payment_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(prc_full_payment), 3) AS average_full_payment_frequency,
    ROUND(AVG(payments), 2) AS average_payments,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(minimum_payments_clean), 2) AS average_cleaned_minimum_payment
FROM credit_card_customers_cleaned
GROUP BY full_payment_segment
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 9: MINIMUM-PAYMENT IMPUTATION STATUS
-- ============================================================
SELECT
    COALESCE(min_payment_status, 'Status not recorded') AS minimum_payment_status,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_card_customers_cleaned), 2)
        AS customer_percentage,
    ROUND(AVG(minimum_payments_clean), 2) AS average_cleaned_minimum_payment
FROM credit_card_customers_cleaned
GROUP BY COALESCE(min_payment_status, 'Status not recorded')
ORDER BY customer_count DESC;

-- ============================================================
-- SECTION 10: TENURE GROUPS
-- ============================================================
SELECT
    CASE
        WHEN tenure < 6 THEN 'Less than 6 months'
        WHEN tenure < 12 THEN '6-11 months'
        ELSE '12 months'
    END AS tenure_group,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(payments), 2) AS average_payments
FROM credit_card_customers_cleaned
GROUP BY tenure_group
ORDER BY MIN(tenure);

-- ============================================================
-- SECTION 11: TOP 10 CUSTOMERS BY PURCHASE AMOUNT
-- Avoid publishing row-level customer IDs in public screenshots.
-- ============================================================
SELECT customer_id, purchases, oneoff_purchases, installments_purchases,
       purchases_trx, purchases_frequency
FROM credit_card_customers_cleaned
ORDER BY purchases DESC
LIMIT 10;

-- ============================================================
-- SECTION 12: TOP 10 CUSTOMERS BY CASH ADVANCE
-- Avoid publishing row-level customer IDs in public screenshots.
-- ============================================================
SELECT customer_id, cash_advance, cash_advance_trx, cash_advance_frequency,
       balance, credit_limit
FROM credit_card_customers_cleaned
ORDER BY cash_advance DESC
LIMIT 10;

-- ============================================================
-- SECTION 13: MISSING-VALUE CHECKS
-- ============================================================
SELECT
    SUM(customer_id IS NULL) AS missing_customer_ids,
    SUM(balance IS NULL) AS missing_balance,
    SUM(purchases IS NULL) AS missing_purchases,
    SUM(cash_advance IS NULL) AS missing_cash_advance,
    SUM(credit_limit IS NULL) AS missing_credit_limit,
    SUM(minimum_payments_original IS NULL) AS missing_original_minimum_payments,
    SUM(minimum_payments_clean IS NULL) AS missing_cleaned_minimum_payments
FROM credit_card_customers_cleaned;

-- ============================================================
-- SECTION 14: DUPLICATE CUSTOMER-ID CHECK
-- Expected: no rows returned if IDs are unique.
-- ============================================================
SELECT customer_id, COUNT(*) AS occurrences
FROM credit_card_customers_cleaned
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- ============================================================
-- SECTION 15: BUSINESS SUMMARY
-- Verified result from user's Workbench:
-- 8,950 total; 6,906 with purchases (77.16%); 4,322 cash-advance
-- users (48.29%); avg balance 1,564.47; avg purchases 1,003.20;
-- avg payments 1,733.14.
-- ============================================================
SELECT
    COUNT(*) AS total_customers,
    SUM(purchases > 0) AS customers_with_purchases,
    ROUND(100.0 * SUM(purchases > 0) / COUNT(*), 2) AS purchase_rate_pct,
    SUM(cash_advance > 0) AS cash_advance_users,
    ROUND(100.0 * SUM(cash_advance > 0) / COUNT(*), 2) AS cash_advance_user_pct,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(purchases), 2) AS average_purchases,
    ROUND(AVG(payments), 2) AS average_payments
FROM credit_card_customers_cleaned;

-- ============================================================
-- FINAL DOCUMENTED BUSINESS INSIGHTS (verified values only)
-- ============================================================
/*
1. PURCHASE ACTIVITY
6,906 records (77.16%) have purchases; 2,044 (22.84%) have none.
Average balance is 2,151.20 for the no-purchase group and 1,390.82
for the purchase group (about 54.7% higher in the no-purchase group).
This is an association, not proof of why the balances differ.

2. CASH ADVANCE BEHAVIOUR
4,322 records (48.29%) have positive cash advances.
Average balance is 2,390.86 among cash-advance users versus 792.73
among non-users. Average payments are 2,054.49 versus 1,433.04.
This does not establish that cash advances cause higher balances.

3. CREDIT LIMIT SEGMENTATION
The 10,000-and-above group has average balance 4,215.51, average
purchases 2,734.24 and average payments 4,614.76. The below-2,000
group has average balance 635.02 and purchases 421.73.
Higher-limit groups show higher average activity in this dataset;
this is descriptive and not causal.

4. FULL-PAYMENT FREQUENCY
The no-full-payment-recorded group (5,903 records) has average
balance 2,065.01. The frequency-0.50-or-higher group (1,276 records)
has average balance 190.40. This is a descriptive relationship,
not proof that payment frequency alone explains balances.

5. OVERALL PORTFOLIO
Average balance 1,564.47; average purchases 1,003.20; average
payments 1,733.14. Payments may relate to previous balances or
cash advances, so average payments exceeding average purchases
does not prove full repayment.

RECOMMENDATIONS
- Explore customers with no recorded purchases and compare other
  activity indicators before suggesting engagement actions.
- Compare cash-advance users and non-users across payment patterns.
- Use credit-limit and purchase-frequency bands for descriptive
  customer segmentation.
- Review balances alongside full-payment frequency and minimum
  payment measures; avoid unsupported credit-risk conclusions.

LIMITATIONS
- Findings are descriptive, not causal.
- A zero purchase amount does not necessarily mean a card is inactive.
- Averages can hide variation within customer segments.
- Minimum-payment metrics use the cleaned/imputed field where stated.
- Currency units are those represented in the source dataset.
*/
-- END OF PROJECT SCRIPT
