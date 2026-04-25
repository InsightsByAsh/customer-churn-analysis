-- ================================================
-- Customer Churn Analysis - Telco Dataset
-- Tool: MySQL | Author: Ashutosh Saini
-- ================================================

USE churn_analysis;

-- ================================================
-- Query 1: Overall Churn Rate
-- Business Question: What is the overall churn rate?
-- ================================================
SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM customer_churn;

-- ================================================
-- Query 2: Churn by Contract Type
-- Business Question: Which contract type has highest churn?
-- ================================================
SELECT 
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM customer_churn
GROUP BY Contract
ORDER BY Churn_Rate_Percentage DESC;

-- ================================================
-- Query 3: Churn by Tenure Groups
-- Business Question: Do new customers churn more than loyal ones?
-- ================================================
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 Months (New)'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months (Loyal)'
    END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percentage
FROM customer_churn
GROUP BY Tenure_Group
ORDER BY Churn_Rate_Percentage DESC;

-- ================================================
-- Query 4: Revenue at Risk
-- Business Question: How much monthly revenue is at risk due to churn?
-- ================================================
SELECT 
    Churn,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(MonthlyCharges), 2) AS Total_Monthly_Revenue,
    ROUND(AVG(MonthlyCharges), 2) AS Avg_Monthly_Charges
FROM customer_churn
GROUP BY Churn;

-- ================================================
-- Query 5: Churn by Internet Service
-- Business Question: Which internet service has highest churn?
-- ================================================
SELECT 
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percentage,
    ROUND(AVG(MonthlyCharges), 2) AS Avg_Monthly_Charges
FROM customer_churn
GROUP BY InternetService
ORDER BY Churn_Rate_Percentage DESC;

-- ================================================
-- Query 6: High Risk Customers
-- Business Question: Which specific customers are at highest risk?
-- ================================================
SELECT 
    customerID,
    tenure,
    Contract,
    InternetService,
    MonthlyCharges,
    CASE 
        WHEN tenure <= 12 AND Contract = 'Month-to-month' 
             AND InternetService = 'Fiber optic' THEN 'Very High Risk'
        WHEN tenure <= 24 AND Contract = 'Month-to-month' THEN 'High Risk'
        WHEN Contract = 'Month-to-month' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Category
FROM customer_churn
WHERE Churn = 'No'
ORDER BY MonthlyCharges DESC
LIMIT 20;

-- ================================================
-- Query 7: Customer Segmentation using CTE
-- Business Question: How many customers are in each risk segment?
-- ================================================
WITH Risk_Segments AS (
    SELECT 
        customerID,
        MonthlyCharges,
        Churn,
        CASE 
            WHEN tenure <= 12 AND Contract = 'Month-to-month' 
                 AND InternetService = 'Fiber optic' THEN 'Very High Risk'
            WHEN tenure <= 24 AND Contract = 'Month-to-month' THEN 'High Risk'
            WHEN Contract = 'Month-to-month' THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS Risk_Category
    FROM customer_churn
)
SELECT 
    Risk_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Already_Churned,
    ROUND(SUM(MonthlyCharges), 2) AS Total_Monthly_Revenue,
    ROUND(AVG(MonthlyCharges), 2) AS Avg_Monthly_Charges
FROM Risk_Segments
GROUP BY Risk_Category
ORDER BY Avg_Monthly_Charges DESC;

-- ================================================
-- Query 8: Final Retention Recommendations using CTE
-- Business Question: Which segments need immediate action?
-- ================================================
WITH Churn_Summary AS (
    SELECT 
        Contract,
        InternetService,
        COUNT(*) AS Total_Customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned,
        ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate,
        ROUND(AVG(MonthlyCharges), 2) AS Avg_Revenue
    FROM customer_churn
    GROUP BY Contract, InternetService
)
SELECT 
    Contract,
    InternetService,
    Total_Customers,
    Churned,
    Churn_Rate,
    Avg_Revenue,
    CASE 
        WHEN Churn_Rate >= 40 THEN 'Immediate Action Required'
        WHEN Churn_Rate >= 20 THEN 'Monitor Closely'
        ELSE 'Stable'
    END AS Action_Required
FROM Churn_Summary
ORDER BY Churn_Rate DESC;