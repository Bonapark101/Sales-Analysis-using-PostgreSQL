--- Data Prep
CREATE TABLE public.user_events (
  event_id text,
  user_id text,
  event_type text,
  event_date text,
  product_id text,
  amount text,
  traffic_source text
);

---ANALYSIS PREP
SELECT *
FROM public.user_events
LIMIT 100;

SELECT DISTINCT event_type FROM public.user_events;
-- (payment_info,add_to_cart, purchase, checkout_start, page_view)
__
ALTER TABLE public.user_events 
ALTER COLUMN event_date TYPE timestamp USING event_date::timestamp;
--
SELECT MIN(event_date), MAX(event_date) FROM public.user_events;
--2025-12-30 04:58:24.517006 ~ 2026-02-03 04:10:18.555901

---ANALYSIS
--- 1) DEFINE SALES FUNNEL AND THE DIFFERENT STAGES
WITH funnel_stages AS (

	SELECT
		COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
		COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
		COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) stage_3_checkout,
		COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
		COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
	FROM public.user_events
	
)
SELECT * FROM funnel_stages

--- 2) CONVERSION RATE THROUGH THE FUNNEL
WITH funnel_stages AS (

	SELECT
		COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
		COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
		COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) stage_3_checkout,
		COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
		COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
	FROM public.user_events
	
) 
SELECT
	stage_1_views,
	stage_2_cart,
	ROUND(stage_2_cart * 100 / stage_1_views) AS view_to_cart_Rate,
	
	stage_3_checkout,
	ROUND(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate,
	
	stage_4_payment,
	ROUND(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,

	stage_5_purchase,
	ROUND(stage_5_purchase * 100 / stage_4_payment) AS payment_to_purchase_rate,

	ROUND(stage_5_purchase * 100 / stage_1_views) AS overall_conversion_rate

FROM funnel_stages

--- 3) FUNNEL BY SOURCE
WITH source_funnel AS (
	SELECT
	traffic_source,
		COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
		COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
		COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
	FROM public.user_events
	GROUP BY traffic_source
)
SELECT 
	traffic_source,
	views,
	carts,
	purchases,
	ROUND(carts * 100 / views) AS cart_conversion_rate,
	ROUND(purchases * 100 / views) AS purcahse_conversion_rate,
	ROUND(purchases * 100 / carts) AS cart_to_purcahse_conversion_rate
FROM source_funnel
ORDER BY purchases DESC

--- 4) TIME TO CONVERSION ANALYSIS
WITH user_journey AS (
	SELECT
		user_id,
		MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
		MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
		MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time

	FROM public.user_events
	GROUP BY user_id
	HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL

)
SELECT 
	COUNT(*) AS converted_users,
	ROUND(AVG(EXTRACT(EPOCH FROM (cart_time - view_time)) / 60),2) AS avg_view_to_cart_minutes,
	ROUND(AVG(EXTRACT(EPOCH FROM (purchase_time - cart_time)) / 60),2) AS avg_cart_to_purchase_minutes,
	ROUND(AVG(EXTRACT(EPOCH FROM (purchase_time - view_time)) / 60),2) AS avg_tota_journey_minutes
FROM user_journey

--- 5) REVENUE FUNNEL ANALYSIS
WITH funnel_revenue AS (
	SELECT
		COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
		COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
		SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
		COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders
	FROM public.user_events
)

SELECT
	total_visitors,
	total_buyers,
	total_orders,
	total_revenue,
	ROUND((total_revenue / total_orders),2) AS avg_order_value,
	ROUND((total_revenue / total_buyers),2) AS revenue_per_buyer,
	ROUND((total_revenue / total_visitors),2) AS revenue_per_visitor
FROM funnel_revenue