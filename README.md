# Sales-Analysis-using-PostgreSQL

Analysis of a mock sales dataset to identify sales performance throughout the funnel.

*Note: This is a **mock portfolio project** designed to practice and demonstrate SQL querying capabilities and business intelligence extraction.*

- Built following a tutorial by loresowhat (conducted by GoogleCloud), with my own modifications(PostgreSQL)
https://www.youtube.com/watch?v=U-JlXWDqvco

- Analysis and Recommendations are my own

## Analyses
1. Funel Overview
    - Each row represent end-to-end purchase data, including how much revenue earned from what
    product via which traffic source.
    - The user journey in sales: page_view, add_to_cart, checkout_start, payment_info, purchase
    - The traffic source: organic, paid_ads,email, social
2. Conversion Rate Through funnel
   - Overall conversion rate = 16%
   - view_to_cart = 31%, cart_to_checkout = 71%, checkout_to_payment = 81%, payment_to_purchase = 91%
   - The view_to_cart conversion rate is significantly lower than every other stage. though it depends on industry, this suggests possible bottlenecks early in the funnel. For example, it would be worth investigating if the marketing efforts via current traffic sources are reaching the right audience.
   
4. Funnel by Traffic Source
5. Time-To-Conversion Analysis
6. Revenue Funnel Analysis


## Recommendation



## Dataset
Columns: event_id, user_id, event_type, event_date, product_id, amount, traffic_source

## Tool
PostgreSQL_data import, transformation, and analysis
SQL features: CTEs, Conditional aggregation, type conversion

