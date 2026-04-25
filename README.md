# 📊 Customer Churn Analysis
### Tools: MySQL | Dataset: Telco Customer Churn

## Business Problem
A telecom company was losing customers but had no clear 
understanding of why. The goal was to analyze 7,032 customer 
records to identify churn patterns and provide actionable 
retention strategies.

## Tools Used
- MySQL — Data analysis and querying

## Key Findings
- Overall churn rate: 26.58%
- Month-to-month + Fiber optic customers: 54.61% churn rate
- New customers (0-12 months): 47.68% churn rate
- Monthly revenue at risk: $139,130
- High value customers ($74.44 avg) churn more than retained ($61.31 avg)

## Analysis Performed
- Overall churn rate calculation
- Churn by contract type
- Churn by customer tenure groups
- Revenue at risk calculation
- Churn by internet service type
- High risk customer identification
- Customer segmentation using CASE WHEN
- Final recommendations using CTE

## Key Insights
1. Month-to-month contracts have 42.71% churn vs 2.85% for two year contracts
2. Fiber optic users churn at 41.89% despite paying $91.50/month
3. New customers (0-12 months) are most at risk at 47.68% churn
4. Very High Risk segment: 916 customers with 47% already churned

## Business Recommendations
- Convert month-to-month customers to long-term contracts with discounts
- Investigate Fiber optic service quality issues immediately
- Launch first year retention program for new customers
- Prioritize high value churned customers for win-back campaigns

## Dataset
- Source: Kaggle Telco Customer Churn Dataset
- Total Records: 7,032 customers
- Features: 21 columns including demographics and service details
