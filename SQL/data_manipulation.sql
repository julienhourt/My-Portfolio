/* Here is used the chinook database, a very common database used to practice SQL. */


/*Skills used in this case : SELECT, WHERE, JOIN, GROUP BY, ORDER BY, LIMIT, SUM, COUNT, HAVING, AVG... */


/*-------------------------------------------------------------------------*/

/* List the top 10 customers who have spent the most on purchases: */

SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent
FROM Customers c
JOIN Invoices i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;

/* Total number of tracks and the average price per track for each album: */

SELECT a.AlbumId, a.Title, COUNT(t.TrackId) AS NumTracks, AVG(t.UnitPrice) AS AvgPricePerTrack
FROM Albums a
JOIN Tracks t ON a.AlbumId = t.AlbumId
GROUP BY a.AlbumId;

/* List the top 5 best-selling genres by revenue: */

SELECT g.Name AS Genre, SUM(ii.Quantity * ii.UnitPrice) AS Revenue
FROM Invoice_Items ii
JOIN Tracks t ON ii.TrackId = t.TrackId
JOIN Genres g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Revenue DESC
LIMIT 5;

/* Find the total sales for each employee, including their name and hire date: */

SELECT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, SUM(i.Total) AS TotalSales
FROM Employees e
LEFT JOIN Customers c ON e.EmployeeId = c.SupportRepId
LEFT JOIN Invoices i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId;

/* List the top 3 most popular playlists (by the number of tracks included) :*/

SELECT p.PlaylistId, p.Name AS PlaylistName, COUNT(pt.TrackId) AS NumTracks
FROM Playlists p
JOIN Playlist_Track pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId
ORDER BY NumTracks DESC
LIMIT 3;

/* List the top 3 most frequently purchased artists (by the number of tracks sold): */

SELECT ar.ArtistId, ar.Name AS ArtistName, COUNT(ii.TrackId) AS NumTracksSold
FROM Artists ar
JOIN Albums al ON ar.ArtistId = al.ArtistId
JOIN Tracks t ON al.AlbumId = t.AlbumId
JOIN Invoice_Items ii ON t.TrackId = ii.TrackId
GROUP BY ar.ArtistId
ORDER BY NumTracksSold DESC
LIMIT 3;

/* List all artists who have tracks with more than one genre: */
SELECT ar.ArtistId, ar.Name AS ArtistName
FROM Artists ar
JOIN Albums al ON ar.ArtistId = al.ArtistId
JOIN Tracks t ON al.AlbumId = t.AlbumId
GROUP BY ar.ArtistId
HAVING COUNT(DISTINCT t.GenreId) > 1;
