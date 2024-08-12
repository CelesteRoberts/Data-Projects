# Maven Analytics Restaurant Orders Analysis 

# OBJECTIVE 1: EXPLORE THE ITEMS TABLE

# 1. View the menu_items table and write a query to find the number of items on the menu 

-- View menu_items table
SELECT * FROM restaurant_db.menu_items;

-- Find the number of items on the menu
SELECT 
	COUNT(*) AS total_menu_items 
FROM menu_items ;
-- Answer: 32

# 2. What are the least and most expensive items on the menu?

-- Least expensive menu item
SELECT item_name, price
FROM menu_items 
WHERE price = (SELECT MIN(price) FROM menu_items) ;
-- Answer: Edamame 5.00

-- Most expensive menu item 
SELECT item_name, price
FROM menu_items 
WHERE price = 
	(SELECT MAX(price) 
	FROM menu_items);
-- Answer: Shrimp scampi 19.95

/* 3. How many italian dishes are on the menu? What are the least and most expensive
italian dishes on the menu? */

-- Number of Italian dishes on the menu 
SELECT 
	COUNT(*) as Total_Italian
FROM menu_items 
WHERE category = 'Italian' ;
-- Answer: 9

-- Least expensive Italian item on the menu
SELECT 
	item_name, price
FROM menu_items
WHERE category = 'Italian' 
AND price =
	(SELECT min(price) 
    from menu_items 
    WHERE category = 'Italian');
-- Answer: Spaghetti and Fettuccine Alfredo for 14.50

-- Most expensive Italian item on the menu 
SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
AND price =
	(SELECT max(price) 
    FROM menu_items
    WHERE category = 'Italian');
-- Answer: Shrimp Scampi 19.95

# 4. How many dishes are in each category? What is the average dish price within each category?

-- Number of dishes in each category
SELECT 
	COUNT(menu_item_id) as num_dishes,
    category 
FROM menu_items
GROUP BY category ;

-- Average dish price within each category 
SELECT
	AVG(price) as Avg_Price,
    category
FROM menu_items 
GROUP BY category ;

# OBJECTIVE 2: EXPLORE THE ORDERS TABLE

# 1. View the order_details table. What is the date range of the table?

-- View table
SELECT *
FROM order_details;
-- date range
SELECT MIN(order_date) , MAX(order_date)
FROM order_details;

/* 2. How many orders were made within this date range? 
How many items were ordered within this date range? */

-- number of orders
SELECT COUNT(DISTINCT order_id) as num_orders
FROM order_details;

-- number of items
SELECT COUNT(*) 
FROM order_details;

# 3. Which orders had the most number of items?
SELECT order_id, COUNT(item_id) as num_items
FROM order_details 
GROUP BY order_id 
ORDER BY num_items DESC;

# 4. How many orders had more than 12 items?
SELECT COUNT(*) FROM

(SELECT order_id, COUNT(item_id) as num_items
FROM order_details 
GROUP BY order_id 
HAVING num_items > 12) as num_orders;

# OBJECTIVE 3: ANALYZE CUSTOMER BEHAVIOR 

# 1. Combine the menu_items table and order_details tables into a single table
SELECT *
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id ;

# 2. What were the least and most ordered items? What categories were they in?

SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id 
GROUP BY item_name
ORDER BY num_purchases ASC;
-- ORDER BY num_purchases DESC;
-- Answer: least: chicken tacos, most: hamburger

-- Most  and least ordered items by category 
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id 
GROUP BY item_name, category 
ORDER BY num_purchases ASC;
-- Answer: least, Mexican. Most, American/Asian

# 3. What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) as total_spend
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5 ;

# 4. View the details of the highest spend order. 
SELECT category, COUNT(item_id) as num_items
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id
WHERE order_id = 440 -- 440 was the order ID discovered in question 3
GROUP BY category ;

/* INSIGHTS: Although Italian cuisine was not the most popular category overall, it is favored by our highest spending customers. 
Therefore, it is worth considering keeping Italian dishes on the menu. */

# 5. View the details of the highest spend order.
SELECT order_id, category, COUNT(item_id) as num_items
FROM order_details od
LEFT JOIN menu_items mi on od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675) -- these order id's were obtained in the query for question # 4
GROUP BY order_id, category ;

/*INSIGHTS: The analysis of the top 5 highest spending orders reveals that Italian cuisine was the most frequently chosen. 
Given that our highest-spending customers are ordering Italian dishes, it is advisable to retain these items on the menu.*/