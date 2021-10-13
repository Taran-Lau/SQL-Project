-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 1 song length per genre
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- We have genre id for each track, we could find which genre on average has the longest songs
-- Uses track, genre tables

SELECT 
    track.GenreId
    , genre.Name
    , SUM(Milliseconds) AS genre_time
FROM track
    INNER JOIN genre ON genre.GenreId = track.GenreId
GROUP BY track.GenreId, genre.Name
ORDER BY genre_time DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 2 average amount a customer spends
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- find the average amount a customer spends at the "checkout" 
-- Uses invoice tables

-- First look for outliers
SELECT Total 
FROM invoice
ORDER BY Total DESC
;

SELECT Total 
FROM invoice
ORDER BY Total ASC
;

-- Now find average
SELECT AVG(Total) 
FROM invoice
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 3 which multimedia format is most popular
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 3 What type of media is most common on the playlist we will be using track, playlisttrack, playlist, mediatype tables

-- 3.1 what media save file is most popular
-- uses track, mediatype tables
SELECT
    mediatype.MediaTypeId
    , mediatype.Name
    , COUNT(*) AS mediatype_count
FROM track
	INNER JOIN mediatype 
		ON track.MediaTypeId = mediatype.MediaTypeId
GROUP BY mediatype.MediaTypeId, mediatype.Name
ORDER BY mediatype_count DESC
;


-- 3.2 What kind of multimedia format is most popular (movies, songs, etc.)
-- uses track, playlisttrack, playlist tables
SELECT 
    playlist.PlaylistId
    , playlist.Name
    , COUNT(*) AS mediaformat_count
FROM track
	INNER JOIN playlisttrack
		ON track.TrackId = playlisttrack.TrackId
	INNER JOIN playlist
		ON playlisttrack.PlaylistId = playlist.PlaylistId
GROUP BY playlist.PlaylistId, playlist.Name
ORDER BY mediaformat_count DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 4  most number tracks bought
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 4 Which band has made the most number tracks bought (most transactions not total money earned)
-- uses invoiceline, track, albumn, artist tables


CREATE TABLE temptable AS
SELECT 
    invoiceline.TrackId
    , COUNT(*) AS track_buycount
    , track.AlbumId
    , album.ArtistId
FROM invoiceline
	INNER JOIN track 
		ON track.TrackId = invoiceline.TrackId
	INNER JOIN album
		ON album.AlbumId = track.AlbumId
GROUP BY invoiceline.TrackId, track.AlbumId, album.ArtistId
ORDER BY AlbumId DESC
;
        
CREATE TABLE temptable2 AS  
SELECT 
    AlbumID
    , SUM(track_buycount) as purchases_from_album
    , ArtistId
FROM temptable
GROUP BY AlbumId, ArtistId
ORDER BY ArtistId DESC
;

SELECT 
    temptable2.ArtistId
    , artist.Name
    , SUM(purchases_from_album) as purchases_from_artist
FROM temptable2
	INNER JOIN artist
		ON artist.ArtistId = temptable2.ArtistId
GROUP BY temptable2.ArtistId, artist.Name
ORDER BY purchases_from_artist DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 5 most profitable genres
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 5 Which genre makes the most money
-- uses invoiceline, track, genre tables

-- number of sales
SELECT 
    TrackId
    , COUNT(*) AS purchases_of_song
FROM invoiceline
GROUP BY TrackId
ORDER BY purchases_of_song DESC
;

-- some of the tracks are worth different prices, count won't help with total money
SELECT 
    TrackId
    , SUM(UnitPrice) AS revenue_per_song
FROM invoiceline
GROUP BY TrackId
ORDER BY revenue_per_song DESC
;
    
SELECT 
    track.GenreId
    , genre.Name
    ,	SUM(invoiceline.UnitPrice) revenue_per_genre
FROM invoiceline
	INNER JOIN track
		ON invoiceline.TrackId = track.TrackId
	INNER JOIN genre
		ON track.GenreId = genre.GenreId
GROUP BY track.GenreId, genre.Name
ORDER BY revenue_per_genre DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 6 most profitable customers
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 6 Which customer has spent the most money
-- uses invoice, customer tables

SELECT 
    invoice.CustomerId
    , customer.FirstName
    , customer.LastName
    , SUM(invoice.Total) as total_per_customer
FROM invoice
    INNER JOIN customer
	    ON invoice.CustomerId = customer.CustomerId
GROUP BY invoice.CustomerId, customer.LastName, customer.FirstName
ORDER BY total_per_customer DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 7 most profitable country
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 7 Which country spends the most on music
-- uses invoice table

SELECT 
    BillingCountry
    , SUM(Total) as spent_per_country
FROM invoice
GROUP BY BillingCountry
ORDER BY spent_per_country DESC
;
       
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 8 most profitable state (US)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 8 Which state in the US spends the most on music
-- Uses invoice table
-- notice we have a lot of null (non usa) 

SELECT 	
    BillingState
    , SUM(Total) as spent_per_state
FROM invoice
WHERE BillingCountry = 'USA'
GROUP BY BillingState
ORDER BY spent_per_state DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 9    most popular genre for this user
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 9 Which genre is most common in the playlist
-- uses playlisttrack, track
SELECT 
    GenreId
    , COUNT(*) as genre_count
FROM playlisttrack
    INNER JOIN track 
        ON playlisttrack.TrackId = track.TrackId
GROUP BY GenreId
ORDER BY genre_count DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- SECTION 10    artist's songs to albumn ratio
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 10 Which artist has highest albumn-- to songs-- ratio

-- Let's write some code to list the number of songs per artist
-- Uses track, album, artist tables
SELECT 
    artist.Name
    , COUNT(*) AS songs_per_artist
FROM track
INNER JOIN album
	ON track.AlbumId = album.AlbumId
INNER JOIN artist
	ON album.ArtistId = artist.ArtistId
GROUP BY artist.Name
ORDER BY songs_per_artist DESC
;
    
-- Now let's write some code to find the number of albums per artist
-- Uses track, album, artist
SELECT 
    artist.Name
    , COUNT(DISTINCT track.AlbumId) AS albums_per_artist
FROM track
    INNER JOIN album
	    ON track.AlbumId = album.AlbumId
	INNER JOIN artist
		ON album.ArtistId = artist.ArtistId       
GROUP BY artist.Name
ORDER BY albums_per_artist DESC
;
    
    
-- Finally lets combine the two to create a ratio
SELECT  
    artist.Name
    , COUNT(*) AS songs_per_artist
    , COUNT(DISTINCT track.AlbumId) AS albums_per_artist
    , cast(COUNT(*) as float) / COUNT(DISTINCT track.AlbumId) AS songs_albums_ratio
FROM track
    INNER JOIN album
		ON track.AlbumId = album.AlbumId
	INNER JOIN artist
		ON album.ArtistId = artist.ArtistId
GROUP BY artist.Name
ORDER BY albums_per_artist DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                              MORE QUESTIONS 1
-- How frequent are bulk buys( > $10)?
-- How frequent are single song purchases ( < 1$)?
-- How frequent are normal purchases(Between $1 and $10)?
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Bulk buyer count
SELECT
	COUNT(invoice.InvoiceId)
FROM invoice
WHERE invoice.Total > 10
;

-- Bulk buyer as a percentage
SELECT
	cast(COUNT( invoice.InvoiceId) as float) / (SELECT COUNT(*) FROM invoice)
FROM invoice
WHERE invoice.Total > 10
;


-- Single purchase count
SELECT 
	COUNT(invoice.InvoiceId)
FROM invoice
WHERE invoice.Total < 1
;

-- Single purchase as a percentage
SELECT 
	cast(COUNT( invoice.InvoiceId) as float) / (SELECT COUNT(*) FROM invoice)
FROM invoice
WHERE invoice.Total < 1
;

-- In between count
SELECT 
	COUNT(invoice.InvoiceId)
FROM invoice
WHERE invoice.Total BETWEEN 1 AND 10
;

-- In between as a percentage
SELECT 
	cast(COUNT( invoice.InvoiceId) as float) / (SELECT COUNT(*) FROM invoice)
FROM invoice
WHERE invoice.Total BETWEEN 1 AND 10
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                              MORE QUESTIONS 2
-- What is the total revenue from each of the three bins of customers
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revenue from bulk buys 
SELECT
	SUM( invoice.Total)
FROM invoice
WHERE invoice.Total > 10
;

-- Revenue percentage from bulk buys
SELECT
	cast(SUM( invoice.Total) as float) / (SELECT SUM(invoice.Total) FROM invoice)
FROM invoice
WHERE invoice.Total > 10
;

-- Revenue from single purchases
SELECT
	SUM( invoice.Total)
FROM invoice
WHERE invoice.Total < 1
;

-- Revenue percentage from single purchases
SELECT
	cast(SUM( invoice.Total) as float) / (SELECT SUM(invoice.Total) FROM invoice)
FROM invoice
WHERE invoice.Total < 1
;

-- Revenue from normal purchases
SELECT 
	SUM(invoice.Total)
FROM invoice
WHERE invoice.Total BETWEEN 1 AND 10
;

-- Revenue percentage from normal purchases
SELECT 
	cast(SUM(invoice.Total) as float) / (SELECT SUM(invoice.Total) FROM invoice)
FROM invoice
WHERE invoice.Total BETWEEN 1 AND 10
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                              MORE QUESTIONS 3
-- What genre do bulk buyers purchasers prefer?
-- What genre do single purchasers prefer?
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Frequency of genre for bulk buys
WITH 
	cte1 AS 
	(
    SELECT 
		COUNT(*) as count_over10
	FROM invoice
	INNER JOIN invoiceline
		ON invoice.InvoiceId = invoiceline.InvoiceId
	INNER JOIN track
		ON invoiceline.TrackId = track.TrackId
	INNER JOIN genre
		ON track.GenreId = genre.GenreId
	WHERE invoice.Total > 10
    ) 
SELECT 
	genre.Name
    , COUNT(genre.Name)
    , cast(COUNT(genre.Name) as float) / count_over10 
FROM cte1, invoice
INNER JOIN invoiceline
	ON invoice.InvoiceId = invoiceline.InvoiceId
INNER JOIN track
	ON invoiceline.TrackId = track.TrackId
INNER JOIN genre
	ON track.GenreId = genre.GenreId
WHERE invoice.Total > 10
GROUP BY genre.Name, count_over10
ORDER BY COUNT(genre.Name) DESC
;


-- Frequency of genre for single buys
WITH 
	cte2 AS
    (
    SELECT 
		COUNT(*) as count_under1
	FROM invoice
	inner join invoiceline
		ON invoice.InvoiceId = invoiceline.InvoiceId
	INNER JOIN track
		ON invoiceline.TrackId = track.TrackId
	INNER JOIN genre
		ON track.GenreId = genre.GenreId
	WHERE invoice.Total < 1
    )
SELECT 
	genre.Name
    , COUNT(genre.Name)
    , cast(COUNT(genre.Name) as float) / count_under1
FROM cte2, invoice
INNER JOIN invoiceline
	ON invoice.InvoiceId = invoiceline.InvoiceId
INNER JOIN track
	ON invoiceline.TrackId = track.TrackId
INNER JOIN genre
	ON track.GenreId = genre.GenreId
WHERE invoice.Total < 1
GROUP BY genre.Name, count_under1
ORDER BY COUNT(genre.Name) DESC
;

-- Frequency of genre for normal buys
WITH 
	cte3 AS
    (
    SELECT 
		COUNT(*) as count_between
	FROM invoice
	INNER JOIN invoiceline
		ON invoice.InvoiceId = invoiceline.InvoiceId
	INNER JOIN track
		ON invoiceline.TrackId = track.TrackId
	INNER JOIN genre
		ON track.GenreId = genre.GenreId
	WHERE invoice.Total BETWEEN 1 AND 10
    )
SELECT 
	genre.Name
    , COUNT(genre.Name)
    , cast(COUNT(genre.Name) as float) / count_between
FROM cte3, invoice
INNER JOIN invoiceline
	ON invoice.InvoiceId = invoiceline.InvoiceId
INNER JOIN track
	ON invoiceline.TrackId = track.TrackId
INNER JOIN genre
	ON track.GenreId = genre.GenreId
WHERE invoice.Total BETWEEN 1 AND 10
GROUP BY genre.Name, count_between
ORDER BY COUNT(genre.Name) DESC
;
