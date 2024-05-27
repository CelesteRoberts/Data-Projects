use bikeshop;

-- Find the highest revenue generating bicycle model type 
SELECT 
modeltype,
ROUND(SUM(saleprice), 2) AS Sales  # Sums sale price, rounds to 2 decimals
FROM bicycle 
GROUP BY modeltype 
ORDER BY Sales DESC; # Filtered results by total sales from highest to lowest 

/* This query displays all model types with total sales in order from highest to lowest total sales. 
The highest revenue generating bicycle model type is "Mountain Full" */

Select
modeltype,
COUNT(modeltype) as Qty
FROM bicycle 
GROUP BY modeltype
;

-- Find the top 5 states with the highest sales revenue 

SELECT 
salestate as State,
ROUND(SUM(saleprice), 2) as Sales # sums sale price and rounds to 2 decimal placeds
FROM bicycle 
GROUP BY salestate
ORDER BY sales DESC #order by sum of total sales highest to lowest
LIMIT 5 # displaying top 5 only
;

-- What is the most popular bike model per state?

#Subquery to find the maximum quantity for each state
#create a CTE called ModelCounts, which calculates the counts of each bike model per state.
WITH ModelCounts AS ( 
    SELECT 
        salestate AS State,
        modeltype AS bikemodel,
        COUNT(*) AS Qty
    FROM bicycle
    GROUP BY State, bikemodel WITH ROLLUP
)
# Query to retrieve the most popular bike model per state from the CTE
SELECT
    mc.State, #Select state from CTE
    mc.bikemodel, #Select bikemodel from CTE
    mc.Qty #Select qty(count) from CTE
FROM  ModelCounts mc -- CTE
JOIN (
#subquery to find the max count for each state
    SELECT
        State,
        MAX(Qty) AS MaxQty #find max qty for each state
    FROM ModelCounts #from cte
    WHERE bikemodel IS NOT NULL -- Exclude the subtotal rows
    GROUP BY State
) MaxCounts ON mc.State = MaxCounts.State AND mc.Qty = MaxCounts.MaxQty #joining to CTE
WHERE mc.bikemodel IS NOT NULL -- Exclude the subtotal rows
ORDER BY mc.State ASC,  mc.Qty DESC;

-- Find month over month comparison for 2003 and 2004 sales.

#CTE to find sum of total sales by date (year and month)
WITH SalesbyDate AS ( #create CTE titled SalesbyDate
	SELECT 	year(orderdate) as order_year,
			month(orderdate) as order_month,
			sum(saleprice) as sales 
	FROM bicycle 
	GROUP BY year(orderdate), month(orderdate)
) 
#query to find sum of sales aggregated by year and month from the CTE. 
SELECT order_month,
	SUM(CASE WHEN order_year=2003 THEN sales ELSE 0 END) as sales_2003,
    SUM(CASE WHEN order_year=2004 THEN sales ELSE 0 END) as sales_2004
FROM SalesbyDate #CTE
GROUP BY order_month
ORDER BY order_month
;

-- For the year 2004, which employee had the highest sales for the year and what is their salary?

SELECT 
	CONCAT(e.lastname,", ", e.firstname) as Employee_Name,
    ROUND(SUM(ct.amount), 2) as Sales,
    e.Salary
FROM Employee e
INNER JOIN customertransaction ct on ct.employeeid = e.employeeid
WHERE YEAR(ct.transactiondate) = 2004
GROUP BY e.employeeid, employee_name, e.salary
ORDER BY Sales DESC
LIMIT 1
;
		
-- Employee performance report
	-- Compare employee's sales
	-- Rank employee based on sales volume and provide their salary 

Select
	CONCAT(e.lastname,", ", e.firstname) as Employee_Name,
    ROUND(SUM(b.saleprice),2) as Sales,
    DENSE_RANK() OVER (ORDER BY SUM(b.saleprice) DESC) as salesrank,
    e.Salary 
FROM employee e
INNER JOIN bicycle b ON b.employeeid = e.employeeid 
GROUP BY employee_name, e.salary
ORDER BY salary DESC
;

