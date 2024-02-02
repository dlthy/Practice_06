--Bài 1
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description) AS job_count_cte
WHERE job_count > 1;
--Bài 2
FROM pages
WHERE page_id NOT IN 
( SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL);
--Bài 3
SELECT COUNT(policy_holder_id) AS member_count
FROM 
(SELECT
    policy_holder_id,
    COUNT(case_id) AS call_count
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >= 3 ) AS call_records;
--Bài 4
SELECT page_id
FROM pages
WHERE page_id NOT IN 
( SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL);
--Bài 5
SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);
--Bài 6
select date_format(trans_date,"%Y-%m") as month, country, 
    count(id) as trans_count,
    sum(case 
    when state='approved' then 1  
    else 0 
    end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case 
    when state='approved' then amount  
    else 0 
    end) as approved_total_amount
from transactions
group by month, country
--Bài 7
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year)
    FROM Sales
    GROUP BY product_id)
-- Bài 8 
SELECT customer_id
FROM   customer
GROUP  BY customer_id
HAVING Count(DISTINCT product_key) =
(SELECT
Count(DISTINCT product_key) AS totl_prdct
FROM product) 
--Bài 9 
select employee_id from Employees
    where salary < 30000
    and manager_id not in (select employee_id from Employees)
    order by employee_id;
--Bài 10: Em thấy link ra giống bài 1 ạ
--Bài 11
select results
from (
  select u.name results
  from MovieRating mr
  join users u on mr.user_id = u.user_id
  group by u.name
  order by count(mr.rating) desc, name
  limit 1 ) as ratings
union all
select results 
from (
  select m.title results
  from MovieRating mr2
  join Movies m on mr2.movie_id = m.movie_id 
  where DATE_FORMAT(mr2.created_at, "%Y-%m") = '2020-02'
  group by m.title
  order by avg(mr2.rating) desc, m.title 
  limit 1)  as movie_ratings
--Bài 12
WITH
    Friend AS (
        SELECT requester_id, accepter_id FROM RequestAccepted
        UNION
        SELECT accepter_id, requester_id FROM RequestAccepted)
SELECT requester_id AS id, COUNT(accepter_id) AS num
FROM Friend
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;



