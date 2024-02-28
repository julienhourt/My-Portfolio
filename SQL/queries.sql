/* Here is used the chinook database, a very common database used to practice SQL. */


/*Skills used in this case : SELECT, WHERE, JOIN, GROUP BY, ORDER BY, LIMIT, COUNT, HAVING, AVG... */


/*-------------------------------------------------------------------------*/


/* QUESTIONS */


/* Number of clients: */

SELECT count(CustomerId) 
FROM customers;


/* How many clients do we have per country? */

SELECT i.BillingCountry AS Country, count(i.InvoiceId) AS Tracks_Sold
FROM invoices i
GROUP BY i.BillingCountry
ORDER BY Tracks_Sold DESC;


/* Who are the Brazilian clients? */

SELECT FirstName ||' '|| LastName FROM customers WHERE Country = 'Brazil';


/* Number of clients each employee is responsible for: */

SELECT e.FirstName ||' '|| e.LastName AS Customer_Support_Employee , count(c.SupportRepId) AS Number_Of_Customers
FROM customers c JOIN employees e ON c.SupportRepId = e.EmployeeId
GROUP BY Customer_Support_Employee;


/* How many songs have been sold? */

SELECT count(TrackId) FROM invoice_items;


/* Top 10 music sales */
SELECT t.TrackId, t.Name, count(ii.TrackId) AS Number_Sales
FROM tracks t JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY t.TrackId 
ORDER BY Number_Sales DESC
LIMIT 10;


/* What is the average price of a song? */
SELECT avg(ii.UnitPrice) 
FROM invoice_items ii;


/* What are the top 3 best-selling music genres? */
SELECT g.Name, count(ii.InvoiceLineId) AS Tracks_Sold 
FROM genres g JOIN tracks t ON g.GenreId = t.GenreId JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY g.Name
ORDER BY Tracks_Sold DESC
LIMIT 3;


/* Display genres that have sold fewer than 100 songs.*/
SELECT g.Name, count(ii.InvoiceLineId) AS Tracks_Sold 
FROM genres g JOIN tracks t ON g.GenreId = t.GenreId JOIN invoice_items ii ON t.TrackId = ii.TrackId
GROUP BY g.Name
HAVING (count(ii.InvoiceLineId) < 100)
ORDER BY Tracks_Sold DESC;
