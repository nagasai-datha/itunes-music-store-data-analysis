-- ==========================================================
-- Apple iTunes Music Store Analysis
-- Labmentrix SQL Project Submission
-- Author: Your Name
-- Database: itunes_analysis
-- ==========================================================

USE itunes_analysis;

-- ==========================================================
-- DATA VALIDATION CHECKS
-- ==========================================================

-- Check NULL primary keys
SELECT COUNT(*) FROM customer WHERE CustomerId IS NULL;
SELECT COUNT(*) FROM invoice WHERE InvoiceId IS NULL;
SELECT COUNT(*) FROM invoice_line WHERE InvoiceLineId IS NULL;

-- Check duplicate customers
SELECT CustomerId, COUNT(*)
FROM customer
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- ==========================================================
-- Q1. Senior most employee based on job title
-- ==========================================================
SELECT EmployeeId, FirstName, LastName, Title, levels
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- ==========================================================
-- Q2. Countries with most invoices
-- ==========================================================
SELECT BillingCountry,
       COUNT(InvoiceId) AS Total_Invoices
FROM invoice
GROUP BY BillingCountry
ORDER BY Total_Invoices DESC;

-- ==========================================================
-- Q3. Top 3 invoice totals
-- ==========================================================
SELECT Total
FROM invoice
ORDER BY Total DESC
LIMIT 3;

-- ==========================================================
-- Q4. City with highest total revenue
-- ==========================================================
SELECT BillingCity,
       SUM(Total) AS Total_Revenue
FROM invoice
GROUP BY BillingCity
ORDER BY Total_Revenue DESC
LIMIT 1;

-- ==========================================================
-- Q5. Best customer (highest spending)
-- ==========================================================
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       SUM(i.Total) AS Total_Spent
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spent DESC
LIMIT 1;

-- =====================================================================
-- Q6. Email, First Name, Last Name & Genre of all Rock Music listeners
-- =====================================================================
SELECT DISTINCT c.Email, c.FirstName, c.LastName, g.Name AS Genre
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
JOIN invoice_line il ON i.InvoiceId = il.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
ORDER BY c.Email ASC;

-- =========================================================
-- Q7. Top 10 artists who have written the most Rock music
-- =========================================================
SELECT a.Name AS Artist_Name,
       COUNT(t.TrackId) AS Total_Rock_Tracks
FROM artist a
JOIN album al ON a.ArtistId = al.ArtistId
JOIN track t ON al.AlbumId = t.AlbumId
JOIN genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY a.ArtistId, a.Name
ORDER BY Total_Rock_Tracks DESC
LIMIT 10;

-- ============================================
-- Q8. Tracks longer than average song length
-- =============================================
SELECT Name,
       Milliseconds
FROM track
WHERE Milliseconds > (
    SELECT AVG(Milliseconds)
    FROM track
)
ORDER BY Milliseconds DESC;

-- =======================================================
-- Q9. Total amount spent by each customer on each artist
-- =======================================================
SELECT c.FirstName,
       c.LastName,
       a.Name AS Artist_Name,
       SUM(il.UnitPrice * il.Quantity) AS Total_Spent
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
JOIN invoice_line il ON i.InvoiceId = il.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist a ON al.ArtistId = a.ArtistId
GROUP BY c.CustomerId, c.FirstName, c.LastName, a.ArtistId, a.Name
ORDER BY Total_Spent DESC;

-- ==========================================================
-- Q10. Most popular genre for each country (including ties)
-- ==========================================================
SELECT Country, Genre, Total_Purchases
FROM (
    SELECT c.Country,
           g.Name AS Genre,
           COUNT(il.InvoiceLineId) AS Total_Purchases,
           RANK() OVER (
               PARTITION BY c.Country
               ORDER BY COUNT(il.InvoiceLineId) DESC
           ) AS rnk
    FROM customer c
    JOIN invoice i ON c.CustomerId = i.CustomerId
    JOIN invoice_line il ON i.InvoiceId = il.InvoiceId
    JOIN track t ON il.TrackId = t.TrackId
    JOIN genre g ON t.GenreId = g.GenreId
    GROUP BY c.Country, g.GenreId, g.Name
) ranked
WHERE rnk = 1
ORDER BY Country;

-- =====================================================
-- Q11. Top customer for each country (including ties)
-- =====================================================
SELECT Country, FirstName, LastName, Total_Spent
FROM (
    SELECT c.Country,
           c.FirstName,
           c.LastName,
           SUM(i.Total) AS Total_Spent,
           RANK() OVER (
               PARTITION BY c.Country
               ORDER BY SUM(i.Total) DESC
           ) AS rnk
    FROM customer c
    JOIN invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.Country, c.CustomerId, c.FirstName, c.LastName
) ranked
WHERE rnk = 1
ORDER BY Country;

-- =================================================
-- Q12. Most popular artists (Top 10 by purchases)
-- =================================================
SELECT a.Name AS Artist_Name,
       COUNT(il.InvoiceLineId) AS Total_Purchases
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist a ON al.ArtistId = a.ArtistId
GROUP BY a.ArtistId, a.Name
ORDER BY Total_Purchases DESC
LIMIT 10;

-- ========================
-- Q13. Most popular song
-- ========================
SELECT t.Name AS Song_Name,
       COUNT(il.InvoiceLineId) AS Total_Purchases
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY Total_Purchases DESC
LIMIT 1;

-- ==============================================
-- Q14. Average prices of different media types
-- ==============================================
SELECT mt.Name AS Media_Type,
       ROUND(AVG(t.UnitPrice), 2) AS Avg_Price
FROM track t
JOIN media_type mt ON t.MediaTypeId = mt.MediaTypeId
GROUP BY mt.MediaTypeId, mt.Name
ORDER BY Avg_Price DESC;

-- =================================================
-- Q15. Most popular countries for music purchases
-- =================================================
SELECT c.Country,
       COUNT(il.InvoiceLineId) AS Total_Purchases
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
JOIN invoice_line il ON i.InvoiceId = il.InvoiceId
GROUP BY c.Country
ORDER BY Total_Purchases DESC;
