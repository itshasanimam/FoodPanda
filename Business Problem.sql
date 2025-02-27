--1. Find the total number of customers by gender, as well as the total number of customers.

--Approach 1:

SELECT gender, COUNT(*) as counts
FROM customer
GROUP BY gender

UNION ALL

SELECT 'Total' AS gender, COUNT(*) as counts
FROM customer
ORDER BY count ASC;

--Approach 2:

WITH total_count AS (
    SELECT gender, COUNT(*) AS counts
    FROM customer
    GROUP BY gender
)

SELECT gender, counts 
FROM total_count

UNION ALL

SELECT 'Total', SUM(counts) 
FROM total_count;





--2. List all unique cuisines available in the menu in each reasturant.

SELECT DISTINCT r.name, 
      UNNEST(STRING_TO_ARRAY(m.cuisine, ',')) as cuisine
FROM menu m
LEFT JOIN restaurant r ON m.r_id = r.id
ORDER BY r.name DESC;



--3. Find the average age of customers, averafe age of femle and male customer.ABORT

SELECT gender, ROUND(AVG(age),2) FROM customer GROUP BY gender
UNION ALL
SELECT 'ALL', ROUND(AVG(age),2) FROM customer
ORDER BY gender DESC;



--4. Count the number of restaurants in each city.

SELECT  city, count(name) 
FROM restaurant  
GROUP BY city
ORDER BY 2 DESC;

--5. Find the most expensive food item in each city with price.


WITH ranked_foods AS (
    SELECT 
        r.city,
        f.item,
        m.price,
        ROW_NUMBER() OVER (PARTITION BY r.city ORDER BY m.price DESC) AS f_rank
    FROM food f
    JOIN menu m ON f.f_id = m.f_id
    JOIN restaurant r ON m.r_id = r.id
)
SELECT city, item, price
FROM ranked_foods
WHERE f_rank = 1
ORDER BY city, price DESC;



-6. List all customers with a monthly income above TK 50000.

--Approach 1:


SELECT 
    Name, 
    monthly_income
FROM customer
WHERE 
        CASE 
           WHEN monthly_income ILIKE '%MORE THAN%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT >=50000
           WHEN monthly_income ILIKE '%LESS THAN%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT >=50000
		   WHEN monthly_income ILIKE '%BELOW%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT >=50000
		   WHEN monthly_income ILIKE '%TO%' THEN SPLIT_PART(monthly_income, ' ', 1)::INT  >=50000
           ELSE FALSE
       END;




--Approach 2:


WITH all_list AS
(SELECT name,
       CASE 
           WHEN monthly_income ILIKE '%MORE THAN%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
           WHEN monthly_income ILIKE '%LESS THAN%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
		   WHEN monthly_income ILIKE '%BELOW%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
		   WHEN monthly_income ILIKE '%TO%' THEN SPLIT_PART(monthly_income, ' ', 1)::INT
           ELSE 0
       END as income
FROM customer)
SELECT name, income 
FROM all_list
WHERE income >=50000; 





--7. Find the top 25 restaurants by the total number of menu items.


SELECT r.name, COUNT(menu_id) FROM restaurant r
JOIN menu m ON r.id = m.r_id
GROUP BY r.name
ORDER BY 2 DESC
LIMIT 25;

--8. Calculate the average rating of all restaurants.

SELECT name, ROUND(AVG(rating),1) as average FROM restaurant
GROUP BY 1



--9. Find the most common occupation among customers.

SELECT occupation, COUNT(*)
FROM customer
GROUP BY occupation
ORDER BY 2 DESC
LIMIT 1;


--10. List all food items with a price greater than  TK 2500.

SELECT DISTINCT item, price FROM food f
JOIN menu m ON m.f_id=f.f_id
WHERE m.price >2500 AND item IS NOT NULL
ORDER BY 2 DESC;






--11. Find the total number of male and female customers in each city.

--Apporoch-1
SELECT r.city, c.gender, COUNT(*)   from customer c
LEFT JOIN orders o ON o.user_id = c.user_id
JOIN restaurant r ON r.id = o.r_id
GROUP BY r.city, c.gender;

--Apporoch-2
SELECT 
    r.city, 
    COUNT(CASE WHEN c.gender = 'Male' THEN 1 END ) AS Male,
    COUNT(CASE WHEN c.gender = 'Female' THEN 1 END) AS Female,
    COUNT(*) AS Total
FROM customer c
LEFT JOIN orders o ON o.user_id = c.user_id
right JOIN restaurant r ON r.id = o.r_id
GROUP BY r.city;




--12. List all restaurants with a rating above 4.5

SELECT DISTINCT name, rating
FROM restaurant
WHERE rating >4.5;



13. Find the average family size of customers by occupations.ABORT

SELECT occupation, ROUND(AVG(family_size),2) 
FROM customer
GROUP BY occupation



14. List all customers with a marital status of "Single" and employeed and age above 25

SELECT name, occupation, marital_status, age
FROM customer
WHERE marital_status ='Single'
	AND occupation ILIKE '%Employee%'
	AND age >25





--15. Find the total number of food items in each cuisine.

SELECT  m.cuisine,  COUNT(f.item) FROM menu m
LEFT JOIN food f ON f.f_id=m.f_id
GROUP BY 1




--16. Calculate the total Average cost of all restaurants by cities

SELECT city, ROUND(AVG(cost)::INT,2) as AVERAGE
FROM restaurant
GROUP BY 1
ORDER BY 2 DESC

  

17. List all married Female customers with an age greater than 30 and housewife

SELECT name, gender, marital_status, occupation FROM customer
WHERE AGE>30
AND gender ='Female'
AND marital_status ='Married'
AND occupation ILIKE '%House Wife%'

--18. Find the most popular cuisine based on menu items.

SELECT cuisine, COUNT(*) FROM menu m
JOIN restaurant r ON m.r_id=r.id
JOIN orders o ON o.r_id=r.id
GROUP BY 1
ORDER BY 1, 2 DESC;







--19. List all restaurants with a rating count greater than or Eqaul to 500.

WITH all_rating AS ( SELECT 
    name,
    CASE 
        WHEN REGEXP_REPLACE(rating_count, '[^0-9]', '', 'g') = '' THEN 0
        ELSE REGEXP_REPLACE(rating_count, '[^0-9]', '', 'g'):: INT
    END AS rating_count
FROM 
    restaurant )

SELECT name, rating_count 
	FROM all_rating
	WHERE rating_count>=500;

	
	


--20. Find the average monthly income of customers by city and gender






--Apporach-1
WITH salary AS ( SELECT city,gender,

CASE 
	WHEN monthly_income ILIKE '%more than%' OR monthly_income ILIKE '%below%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
	WHEN monthly_income LIKE '% to %' THEN ROUND((SPLIT_PART(monthly_income, ' to ', 1)::INT + SPLIT_PART(monthly_income, ' to ', 2)::INT ) / 2)
ELSE 0
END as income

FROM customer c 

JOIN orders o ON o.user_id = c.user_id
JOIN restaurant r ON o.r_id = r.id
)

SELECT city, gender, ROUND (AVG(income)::INT,1) as Average from salary
GROUP BY 1,2; 



--Apporach-2

WITH salary AS ( SELECT city, gender,

CASE 
	WHEN monthly_income ILIKE '%more than%' OR monthly_income ILIKE '%below%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
	WHEN monthly_income LIKE '% to %' THEN ROUND((SPLIT_PART(monthly_income, ' to ', 1)::INT + SPLIT_PART(monthly_income, ' to ', 2)::INT ) / 2)
ELSE 0
END as income

FROM customer c 

JOIN orders o ON o.user_id = c.user_id
JOIN restaurant r ON o.r_id = r.id
)

SELECT city, 
      ROUND(AVG(CASE WHEN gender = 'Male' THEN income END::INT),2) as Male_Avg,
      ROUND(AVG(CASE WHEN gender = 'Female' THEN income END::INT),2) as Female_Avg
      
FROM salary
GROUP BY city;
	




-21. Find the correlation between customer age and monthly income with comment.


SELECT CORR(age, income)::DECIMAL(5,4) as correlation,
CASE 
        WHEN CORR(age, income)::DECIMAL(5,4) = 1 THEN 'Perfect Positive Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN 0.7 AND 0.99 THEN 'Strong Positive Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN 0.3 AND 0.69 THEN 'Moderate Positive Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN 0.01 AND 0.29 THEN 'Weak Positive Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) = 0 THEN 'No Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN -0.29 AND -0.01 THEN 'Weak Negative Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN -0.69 AND -0.3 THEN 'Moderate Negative Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) BETWEEN -0.99 AND -0.7 THEN 'Strong Negative Correlation'
        WHEN CORR(age, income)::DECIMAL(5,4) = -1 THEN 'Perfect Negative Correlation'
        ELSE 'Invalid Correlation Value'
    END  as Comments
	
FROM (

SELECT age, 
	CASE 
		WHEN monthly_income ILIKE '%more than%' OR monthly_income ILIKE '%below%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
		WHEN monthly_income LIKE '% to %' THEN ROUND((SPLIT_PART(monthly_income, ' to ', 1)::INT + SPLIT_PART(monthly_income, ' to ', 2)::INT ) / 2)
	ELSE 0
	END as income
	FROM customer)


--22. Identify the top 50 restaurants with the highest average ratings.

 

SELECT name, ROUND(AVG(rating),2) 
FROM restaurant 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 50;

23. Find the most 10 expensive cuisine based on menu prices.

SELECT cuisine, price 
FROM menu
ORDER BY price DESC
LIMIT 10;

--24. List customers  who have ordered food from a "Pizzas,Fast Food" cuisine with occupation and gender.

SELECT name, occupation, gender occupation FROM menu m
JOIN orders o ON m.r_id=o.r_id
JOIN customer c ON c.user_id=o.user_id
WHERE cuisine = 'Pizzas,Fast Food'
ORDER BY 1;






25. Find the average price of food items for each cuisine.

SELECT cuisine, ROUND(AVG(price):: INT,2)
FROM menu
GROUP BY cuisine
ORDER BY 2 DESC;

26. Identify restaurants with the highest and lowest average ratings in each city.

(SELECT name, ROUND(AVG(rating),2), 'Highest' as Rating
FROM restaurant
WHERE name IS NOT NULL
GROUP BY name
ORDER BY 2 DESC
LIMIT 1)

UNION

(SELECT name, ROUND(AVG(rating),2), 'Lowest' as Rating
FROM restaurant
WHERE name IS NOT NULL
GROUP BY name
ORDER BY 2 ASC
LIMIT 1);



--27. Find the most common food type ordered by customers in diffrent cities.

WITH food_counts AS (SELECT city, types, COUNT(order_date) as counts FROM restaurant r 
JOIN orders o ON o.r_id = r.id
WHERE types IS NOT NULL
GROUP BY city, types )
SELECT city, types, counts
FROM food_counts
WHERE (city,counts) IN (SELECT city, max(counts) FROM food_counts GROUP BY city)
ORDER BY 1,2,3 DESC;







28. List customers who have a monthly income above the average.


WITH salary AS ( SELECT c.name, c.gender,

CASE 
	WHEN monthly_income ILIKE '%more than%' OR monthly_income ILIKE '%below%' THEN REGEXP_REPLACE(monthly_income, '[^0-9]', '', 'g')::INT
	WHEN monthly_income LIKE '% to %' THEN ROUND((SPLIT_PART(monthly_income, ' to ', 1)::INT + SPLIT_PART(monthly_income, ' to ', 2)::INT ) / 2)
ELSE 0
END as income

FROM customer c 

JOIN orders o ON o.user_id = c.user_id
JOIN restaurant r ON o.r_id = r.id
)

SELECT * FROM salary WHERE income > (SELECT AVG(income) FROM salary);



--29. Find the total revenue generated by each restaurant.

SELECT 
    restaurant.name, 
    SUM(orders.sales_amt)
FROM restaurant
JOIN orders ON restaurant.id = orders.r_id
GROUP BY restaurant.name;






--30. Identify the most popular food item across all restaurants.


WITH all_rank AS  (SELECT 
    restaurant.name, food.item,
    COUNT(orders.r_id) as counts,
    ROW_NUMBER() OVER (PARTITION BY restaurant.name ORDER BY COUNT(orders.r_id) DESC) AS food_rank
FROM restaurant
JOIN orders ON restaurant.id = orders.r_id
JOIN menu ON menu.r_id = restaurant.id
JOIN food ON menu.f_id = food.f_id
GROUP BY restaurant.name, food.item
ORDER BY restaurant.name, food.item, food_rank)


SELECT name, item FROM  all_rank
WHERE food_rank  =1 AND item IS NOT NULL
ORDER BY 2 DESC;








31. Find the average rating of restaurants in each city.
32. List customers who have ordered food from more than one cuisine.
33. Find the most common education level among customers.
34. Identify restaurants with the highest number of menu items.
35. Find the average cost of restaurants in each city.
36. List customers who have ordered food from a specific restaurant.
37. Find the most expensive restaurant based on cost.
38. Find the top 10 seeling date in 2024.
39. Find the average age of customers for each occupation.
40. List restaurants with the highest and lowest rating counts.
41. Find the rating of a restaurant based on its cost and city.
42. Identify customer segments based on age, income, and occupation.
43. Find the relationship between family size and monthly income.
44. FIND the popularity of a cuisine based on customer demographics.
45. Identify the most profitable restaurant based on cost and rating.
46. Find the impact of education level on monthly income.
47. Predict the likelihood of a customer ordering a specific cuisine.
48. Identify the most popular food type for each age group.
49. Find the correlation between restaurant rating and rating count.
50. Group the monthly income of a customer based on their occupation and education.



51. Identify the most common food type ordered by customers in each city.
52. Find the relationship between restaurant cost and customer income.
53. Predict the rating count of a restaurant based on its rating and city.
54. Identify the most popular cuisine for each gender.
55. Find the impact of marital status on monthly income.
56. Predict the price of a menu item based on its cuisine and type.
57. Identify the most common occupation for customers in each city.
58. Find the relationship between customer age and food preferences.
59. Predict the family size of a customer based on their income and occupation.
60. Identify the most profitable cuisine based on customer demographics.
61. Perform a time series analysis on restaurant ratings over time.
62. Analyze the distribution of customer ages.
63. Perform a cluster analysis to group customers based on demographics.
64. Analyze the relationship between restaurant cost and rating.
65. Perform a regression analysis to predict restaurant revenue.
66. Analyze the distribution of monthly income among customers.
67. Perform a factor analysis to identify key drivers of restaurant ratings.
68. Analyze the relationship between customer education and food preferences.
69. Perform a sentiment analysis on restaurant reviews.
70. Analyze the impact of city on restaurant ratings.
71. Identify the best city to open a new restaurant based on customer demographics.
72. Develop a marketing strategy to target high-income customers.
73. Identify the most profitable cuisine to add to a restaurant's menu.
74. Develop a loyalty program for customers with high monthly incomes.
75. Identify the best food type to promote based on customer preferences.
76. Develop a pricing strategy for menu items based on customer income.
77. Identify the best occupation to target for a new restaurant campaign.
78. Develop a strategy to improve restaurant ratings in low-performing cities.
79. Identify the best age group to target for a new food delivery service.
80. Develop a strategy to increase the rating count of a restaurant.
81. What if a new cuisine is introduced? Predict its popularity.
82. What if the price of all menu items is increased by 10%? Analyze the impact.
83. What if a new restaurant is opened in a city with no existing restaurants?
84. What if the monthly income of all customers increases by 20%? Analyze the impact.
85. What if a new food type is introduced? Predict its adoption rate.
86. What if the rating count of all restaurants is doubled? Analyze the impact.
87. What if a new occupation is added to the customer database? Predict its impact.
88. What if the family size of all customers increases by 1? Analyze the impact.
89. What if a new city is added to the restaurant database? Predict its impact.
90. What if the education level of all customers increases? Analyze the impact.
91. Explore the relationship between customer age and restaurant ratings.
92. Explore the impact of marital status on food preferences.
93. Explore the relationship between restaurant cost and customer income.
94. Explore the impact of education level on restaurant ratings.
95. Explore the relationship between family size and food preferences.
96. Explore the impact of occupation on monthly income.
97. Explore the relationship between cuisine and restaurant ratings.
98. Explore the impact of city on customer demographics.
99. Explore the relationship between food type and menu price.
100. Explore the impact of rating count on restaurant revenue.