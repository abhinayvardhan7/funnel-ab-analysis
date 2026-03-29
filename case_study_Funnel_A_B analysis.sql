-- PROBLEM : Users were not completing purchases?

-- What I did:
-- Performed funnel analysis and A/B testing

-- Funnel:
-- Visit → View → Cart → Purchase

SELECT 
	COUNT(DISTINCT CASE WHEN event_name='visit'THEN user_id END)  AS visitors,
	COUNT(DISTINCT CASE WHEN event_name='view_product'THEN user_id END)  AS viewers,
	COUNT(DISTINCT CASE WHEN event_name='add_to_cart'THEN user_id END)  AS add_to_carts,
	COUNT(DISTINCT CASE WHEN event_name='purchase'THEN user_id END)  AS purchasers
	FROM user_events;

-- Results:
-- Visitors: 41
-- Viewers: 35
-- Cart Users: 26
-- Purchasers: 17

-- Funnel Conversion & Drop-off

SELECT 
    -- Visit → View
    COUNT(DISTINCT CASE WHEN event_name='view_product' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name='visit' THEN user_id END) AS visit_to_view,

    100 - (
        COUNT(DISTINCT CASE WHEN event_name='view_product' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_name='visit' THEN user_id END)
    ) AS visit_drop_off,

    -- View → Cart
    COUNT(DISTINCT CASE WHEN event_name='add_to_cart' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name='view_product' THEN user_id END) AS view_to_cart,

    100 - (
        COUNT(DISTINCT CASE WHEN event_name='add_to_cart' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_name='view_product' THEN user_id END)
    ) AS view_drop_off,

    -- Cart → Purchase
    COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name='add_to_cart' THEN user_id END) AS cart_to_purchase,

    100 - (
        COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_name='add_to_cart' THEN user_id END)
    ) AS cart_drop_off

FROM user_events;
   
-- Most users drop at the checkout stage (Add to Cart → Purchase),
-- which is the biggest bottleneck in the funnel.
-- Improving checkout flow and payment options can help increase conversions.


-- A/B ANALYSIS
SELECT 
    group_name,
    COUNT(DISTINCT CASE WHEN event_name='purchase' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name='visit' THEN user_id END) AS conversion_rate
FROM user_events
GROUP BY group_name;


-- -- conversion_rate
-- A → 26.6
-- B → 50.0

-- A/B Testing:
-- Group B has significantly higher conversion than Group A,
-- indicating that the new version improves user completion rate.


-- This suggests that the changes in version B help users
-- complete their purchases more easily.

-- Recommendation:
-- Implement version B to improve overall conversion.














