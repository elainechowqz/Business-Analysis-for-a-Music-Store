/*

*/

CREATE TABLE Employee_Customer_Invoice AS

SELECT 
    e.employee_id AS EmployeeId,
    e.country AS EmployeeCountry,
    e.birthdate AS EmployeeBirthday,
    e.hire_date AS EmployeeHiredate,
    c.customer_id AS CustomerId,
    c.country AS CustomerCountry,
    i.invoice_id,
    i.invoice_date,
    i.total AS InvoiceTotal
FROM 
    employee e
INNER JOIN 
    customer c ON employee_id = c.support_rep_id
INNER JOIN 
    invoice i ON c.customer_id = i.customer_id;
	
/* Part One:
Analyzing Sales by Country
Your next task is to analyze the sales data for customers from each different country. 
You have been given guidance to use the country value from the customers table, and ignore the country from the billing address in the invoice table.
In particular, you have been directed to calculate data, for each country, on the:
    total number of customers
    total value of sales
    average value of sales per customer
    average order value
*/

/* We need to join the tables 'customer' and 'invoice''
and calculate various sales metrics for each country. 

Sales analytics through customer segmentation (via the countries of customers)
*/

CREATE TABLE SALES_BY_COUNTRY AS 

SELECT *, CAST(total_sales as float)/num_customer AS average_customer_value
FROM(
     SELECT CustomerCountry,
            count(CustomerID) AS num_customer,
            sum(InvoiceTotal) AS total_sales,
            count(invoice_id) AS num_order
     FROM Employee_Customer_Invoice
     GROUP BY CustomerCountry
	 ORDER BY num_customer DESC
     );

/* Part Two:
Analyzing Employee Sales Performance
Each customer for the Chinook store gets assigned to a sales support agent within the company when they first make a purchase. 
You have been asked to analyze the purchases of customers belonging to each employee to see if any sales support agent is performing either better or worse than the others.
You might like to consider whether any extra columns from the employee table explain any variance you see, or whether the variance might instead be indicative of employee performance.
Community discussion
    Write a query that finds the total dollar amount of sales assigned to each sales support agent within the company. Add any extra attributes for that employee that you find are relevant to the analysis.
    Write a short statement describing your results, and providing a possible interpretation. */

/* For this problem, there are only 8 employees (all based in Canada) 
and 3 sales support agents (all hired in 2017). 
Therefore, extra columns from the employee table may not explain any variance, 
and the vairance might be indicative of employee performance. 

One can join the tables 'employee', 'customer' and 'invoice', and calculating the total amount of sales for each sales support agent. 
If ones wants to zoom in a bit further, one can also calculate the number of customers and sales value per customer 
for each sales support agent. 

Also, note that the performance of employees also depend on the customers (with attributes like country) they get. 
One can use double group by (sales support agent + country) and see the sales metrics 
like total values of sales, numbers of customers, and values of sales per customer
for each sales agent and each country. 

Therefore, we can evaluate employee performance by customer segmentation. 
*/
CREATE TABLE Employee_Performance AS 

SELECT EmployeeId, EmployeeBirthday, EmployeeHiredate,
       sum(InvoiceTotal) AS sales_performance,
	   count(CustomerId) AS sales_customer_count,
	   avg(InvoiceTotal) As average_sales,
	   max(InvoiceTotal) As highest_sale_by_order
FROM Employee_Customer_Invoice
GROUP BY EmployeeId
ORDER BY sales_performance DESC; 

CREATE TABLE Employee_Performance_by_Country AS

SELECT EmployeeId, CustomerCountry,
	   sum(InvoiceTotal) AS sales_performance_by_country,
	   count(CustomerId) AS sales_customer_count_by_country
FROM Employee_Customer_Invoice
GROUP BY EmployeeId, CustomerCountry; 

/* Query the performance of the sales agents in the countries with the greatest volumns of sales. 
   As seen in the result, the rankings of performances vary in different major countries. */

SELECT * 
FROM Employee_Performance_by_Country
WHERE CustomerCountry IN 
      (
	   SELECT CustomerCountry
	   FROM SALES_BY_COUNTRY
	   LIMIT 10
      )
ORDER BY CustomerCountry, sales_performance_by_country DESC;	  

