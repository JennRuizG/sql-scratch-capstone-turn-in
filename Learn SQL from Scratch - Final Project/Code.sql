-- 1. Select first 10 rows of the Survey table:
 SELECT *
 FROM survey
 LIMIT 10;
 
--2. What is the number of responses for each question?
 SELECT question, 
 	COUNT(DISTINCT user_id) AS 'response count'
 FROM survey
 GROUP BY 1;
 
 --4. Examine first 5 rows of each table:
 SELECT *
 FROM quiz
 LIMIT 5;
 
 SELECT * 
 FROM home_try_on
 LIMIT 5;
 
 SELECT *
 FROM purchase
 LIMIT 5;
 
 --5. Combine the three tables starting from the top of the funnel (browse) and ending with the bottom of the funnel (purchase)
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as 'q'
LEFT JOIN
home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON p.user_id = q.user_id
LIMIT 10;

--6. Calculate overall conversion rates by aggregating across all rows
WITH Funnel AS (
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as 'q'
LEFT JOIN
home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON p.user_id = q.user_id
)
SELECT COUNT(*) AS 'num_browse', 
SUM(Funnel.is_home_try_on) AS 'num_home_try_on',
SUM(Funnel.is_purchase) As 'num_purchase',
ROUND(1.0*SUM(is_home_try_on)/COUNT(user_id),2) AS '% browse to try on',
ROUND(1.0*SUM(is_purchase)/SUM(is_home_try_on),2) AS '% Try on to purchase',
ROUND(1.0*SUM(is_purchase)/COUNT(user_id),2) AS '% browse to purchase'
FROM Funnel;

--7. Find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.
WITH Funnel AS (
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz as 'q'
LEFT JOIN
home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON p.user_id = q.user_id
)
SELECT number_of_pairs, COUNT(*) AS 'num_browse', 
SUM(Funnel.is_home_try_on) AS 'num_home_try_on',
SUM(Funnel.is_purchase) As 'num_purchase',
ROUND(1.0*SUM(is_purchase)/SUM(is_home_try_on),2) AS '% Try on to purchase'
FROM Funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;

--8. What are the most common results of the Style Quiz?
SELECT response, 
 	COUNT(DISTINCT user_id) AS 'response count', question
 FROM survey
 GROUP BY 1
 ORDER BY 2 DESC;  

 --9. What are the most common types of purchase made?
SELECT product_id, COUNT(DISTINCT user_id) AS 'Purchase count', price, model_name, style, color
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;
