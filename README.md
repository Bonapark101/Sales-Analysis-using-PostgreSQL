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
   - The view_to_cart conversion rate is significantly lower than every other stage. though it depends on industry, this suggests possible bottlenecks early in the funnel.
   - It would be worth investigating if the marketing efforts via current traffic sources are reaching the right audience.
   
3. Funnel by Traffic Source
   -  Email is the most effective traffic source with a 62% view_to_cart_conversion_rate.
   -  Social is the least effective traffic source with a 13% view_to_cart_conversion_rate.
     *In regards to volumes, social drives three times higher traffic than email, the conversion rate of the social is only 13%.
   -  The cart_to_purchase_conversion_rate shows a balanced rate across the traffic sources, averaging around 53%. In this case, view_to_cart_conversion_rate is meaningful stage in determining whether a user goes on to purchase.
   -  The conversion rate of view_to_purchase drops significantly across all traffic source compares to view_to_cart.
   - It would be worth auditing marketing campaigns for social to find bottlenecks. Additionally, analysing user behaviour across email and social could provide insights for the marketing team to inform the future campaigns.

4. Time-To-Conversion Analysis
   - The average total time from view to purchase is about 25 minutes, with view_to_cart averaging 11.16 minutes and cart_to_purchase averaging 13.47 minutes. It is worth investigating checkout process flow. Reducing friction and bringing the checkout time closer to the view_to_cart time would help shape a better customer experience.
   
5. Revenue Funnel Analysis
   - Out of total visitors, 826 became buyers, generating $87,975.11.
   - The revenue per visitor is $17.60. The company can use it as a benchmark against customer acquisition cost and assess overall profitability by channels.

## Recommendation
1. Investigate and improve the view_to_cart stage
2. Reassess the social media channel
3. Understand why email channel performs well and inform improvements to other channels.
4. Review the checkout flow
5. Establish a CAC benchmark


## Dataset
Columns: event_id, user_id, event_type, event_date, product_id, amount, traffic_source

## Tool
PostgreSQL_data import, transformation, and analysis
SQL features: CTEs, Conditional aggregation, type conversion

