-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 1 song length per genre
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--Find which genre on average has the longest songs
--Uses track, genre tables
SELECT 
    public."Track"."GenreId"
    , public."Genre"."Name"
    , SUM(public."Track"."Milliseconds") AS genre_time
FROM public."Track"
    INNER JOIN public."Genre" ON public."Genre"."GenreId" = public."Track"."GenreId"
GROUP BY public."Track"."GenreId", public."Genre"."Name"
ORDER BY genre_time DESC
;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 2 average amount a customer spends
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--Find the average amount a customer spends at the "checkout" 
--Uses invoice tables

--First look for outliers
SELECT "Invoice"."Total" 
FROM "Invoice"
ORDER BY "Invoice"."Total" DESC;

SELECT "Invoice"."Total" 
FROM "Invoice"
ORDER BY "Invoice"."Total" ASC;

--Now find average
SELECT AVG("Invoice"."Total") 
FROM "Invoice"
;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 3 which multimedia format is most popular
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 3 What type of media is most common on the playlist we will be using track, playlisttrack, playlist, mediatype tables

--3.1 what media save file is most popular
-- uses track, mediatype tables
SELECT
    "MediaType"."MediaTypeId"
    , "MediaType"."Name"
    , COUNT(*) AS mediatype_count
FROM "Track"
	INNER JOIN "MediaType" 
		ON "Track"."MediaTypeId" = "MediaType"."MediaTypeId"
GROUP BY "MediaType"."MediaTypeId"
ORDER BY mediatype_count DESC
;


--3.2 What kind of multimedia format is most popular (movies, songs, etc.)
-- uses track, playlisttrack, playlist tables
SELECT 
    "Playlist"."PlaylistId"
    , "Playlist"."Name"
    , COUNT(*) AS mediaformat_count
FROM "Track"
	INNER JOIN "PlaylistTrack"
		ON "Track"."TrackId" = "PlaylistTrack"."TrackId"
	INNER JOIN "Playlist"
		ON "PlaylistTrack"."PlaylistId" = "Playlist"."PlaylistId"
GROUP BY "Playlist"."PlaylistId"
ORDER BY mediaformat_count DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 4  most number tracks bought
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 4 Which band has made the most number tracks bought (most transactions not total money earned)
-- uses invoiceline, track, albumn, artist tables


CREATE TABLE temptable AS
SELECT 
    "InvoiceLine"."TrackId"
    , COUNT(*) AS track_buycount
    , "Track"."AlbumId"
    , "Album"."ArtistId"
FROM "InvoiceLine"
	INNER JOIN "Track" 
		ON "Track"."TrackId" = "InvoiceLine"."TrackId"
	INNER JOIN "Album"
		ON "Album"."AlbumId" = "Track"."AlbumId"
GROUP BY "InvoiceLine"."TrackId", "Track"."AlbumId", "Album"."ArtistId"
ORDER BY "AlbumId" DESC
;
        
CREATE TABLE temptable2	AS       
SELECT 
    "temptable"."AlbumId"
    , SUM("temptable"."track_buycount") as purchases_from_album
    , "temptable"."ArtistId"
FROM "temptable"
GROUP BY "temptable"."AlbumId", "temptable"."ArtistId"
ORDER BY "temptable"."ArtistId" DESC
;

SELECT 
    "temptable2"."ArtistId"
    , "Artist"."Name"
    , SUM("temptable2"."purchases_from_album") as purchases_from_artist
FROM "temptable2"
	INNER JOIN "Artist"
		ON "Artist"."ArtistId" = "temptable2"."ArtistId"
GROUP BY "temptable2"."ArtistId", "Artist"."Name"
ORDER BY purchases_from_artist DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 5 most profitable genres
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 5 Which genre makes the most money
-- uses invoiceline, track, genre tables

-- number of sales
SELECT 
    "InvoiceLine"."TrackId"
    , COUNT(*) AS purchases_of_song
FROM "InvoiceLine"
GROUP BY "InvoiceLine"."TrackId"
ORDER BY purchases_of_song DESC;

-- some of the tracks are worth different prices, count won't help with total money
SELECT 
    "InvoiceLine"."TrackId"
    , SUM("InvoiceLine"."UnitPrice") AS revenue_per_song
FROM "InvoiceLine"
GROUP BY "InvoiceLine"."TrackId"
ORDER BY revenue_per_song DESC
;
    
SELECT 
    "Track"."GenreId"
    , "Genre"."Name"
    ,	SUM("InvoiceLine"."UnitPrice") revenue_per_genre
FROM "InvoiceLine"
	INNER JOIN "Track"
		ON "InvoiceLine"."TrackId" = "Track"."TrackId"
	INNER JOIN "Genre"
		ON "Track"."GenreId" = "Genre"."GenreId"
GROUP BY "Track"."GenreId", "Genre"."Name"
ORDER BY revenue_per_genre DESC
;

			
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 6 most profitable customers
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 6 Which customer has spent the most money
-- uses invoice, customer tables

SELECT 
    "Invoice"."CustomerId"
    , "Customer"."FirstName"
    , "Customer"."LastName"
    , SUM("Invoice"."Total") as total_per_customer
FROM "Invoice"
    INNER JOIN "Customer"
	    ON "Invoice"."CustomerId" = "Customer"."CustomerId"
GROUP BY "Invoice"."CustomerId", "Customer"."FirstName", "Customer"."LastName"
ORDER BY total_per_customer DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 7 most profitable country
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 7 Which country spends the most on music
-- uses invoice table

SELECT 
    "BillingCountry"
    , SUM("Total") as spent_per_country
FROM "Invoice"
GROUP BY "BillingCountry"
ORDER BY spent_per_country DESC
;
        
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 8 most profitable state (US)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--8 Which state in the US spends the most on music
--Uses invoice table
--notice we have a lot of null (non usa) 

SELECT 	
    "BillingState"
    , SUM("Total") as spent_per_state
FROM "Invoice"
WHERE "Invoice"."BillingCountry" = 'USA'
GROUP BY "BillingState"
ORDER BY spent_per_state DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 9    most popular genre for this user
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 9 Which genre is most common in the playlist
-- uses playlisttrack, track
SELECT 
    "GenreId"
    , COUNT(*) as genre_count
FROM "PlaylistTrack"
    INNER JOIN "Track" 
        ON "PlaylistTrack"."TrackId" = "Track"."TrackId"
GROUP BY "GenreId"
ORDER BY genre_count DESC
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SECTION 10    artist's songs to albumn ratio
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 10 Which artist has highest albumn-- to songs-- ratio

-- Let's write some code to list the number of songs per artist
-- Uses track, album, artist tables
SELECT 
    "Artist"."Name"
    , COUNT(*) AS songs_per_artist
FROM "Track"
INNER JOIN "Album"
	ON "Track"."AlbumId" = "Album"."AlbumId"
INNER JOIN "Artist"
	ON "Album"."ArtistId" = "Artist"."ArtistId"
GROUP BY "Artist"."Name"
ORDER BY songs_per_artist DESC
;
    
-- Now let's write some code to find the number of albums per artist
-- Uses track, album, artist
SELECT 
    "Artist"."Name"
    , COUNT(DISTINCT "Track"."AlbumId") AS albums_per_artist
FROM "Track"
    INNER JOIN "Album"
	    ON "Track"."AlbumId" = "Album"."AlbumId"
	INNER JOIN "Artist"
		ON "Album"."ArtistId" = "Artist"."ArtistId"       
GROUP BY "Artist"."Name"
ORDER BY albums_per_artist DESC
;
    
    
-- Finally lets combine the two to create a ratio
SELECT  
    "Artist"."Name"
    , CAST( COUNT(*) AS NUMERIC(10,3)) AS songs_per_artist
    , CAST( COUNT(DISTINCT "Track"."AlbumId") AS NUMERIC(10,3)) AS albums_per_artist
    , CAST( COUNT(*) / COUNT(DISTINCT "Track"."AlbumId") AS NUMERIC(10,3)) AS songs_albums_ratio
FROM "Track"
    INNER JOIN "Album"
		ON "Track"."AlbumId" = "Album"."AlbumId"
	INNER JOIN "Artist"
		ON "Album"."ArtistId" = "Artist"."ArtistId"
GROUP BY "Artist"."Name"
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
--Bulk buyer count
SELECT
	COUNT("Invoice"."InvoiceId")
FROM "Invoice"
WHERE "Invoice"."Total" > 10
;

--Bulk buyer as a percentage
SELECT
	COUNT( "Invoice"."InvoiceId")::decimal / (SELECT COUNT(*) FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" > 10
;


--Single purchase count
SELECT 
	COUNT("Invoice"."InvoiceId")
FROM "Invoice"
WHERE "Invoice"."Total" < 1
;

--Single purchase as a percentage
SELECT 
	COUNT( "Invoice"."InvoiceId")::decimal / (SELECT COUNT(*) FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" < 1
;

--In between count
SELECT 
	COUNT("Invoice"."InvoiceId")
FROM "Invoice"
WHERE "Invoice"."Total" BETWEEN 1 AND 10
;

--In between as a percentage
SELECT 
	COUNT( "Invoice"."InvoiceId")::decimal / (SELECT COUNT(*) FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" BETWEEN 1 AND 10
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                              MORE QUESTIONS 2
-- What is the total revenue from each of the three bins of customers
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--Revenue from bulk buys 
SELECT
	SUM( "Invoice"."Total")
FROM "Invoice"
WHERE "Invoice"."Total" > 10
;

--Revenue percentage from bulk buys
SELECT
	SUM( "Invoice"."Total") / (SELECT SUM("Invoice"."Total") FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" > 10
;

--Revenue from single purchases
SELECT
	SUM( "Invoice"."Total")
FROM "Invoice"
WHERE "Invoice"."Total" < 1
;

--Revenue percentage from single purchases
SELECT
	SUM( "Invoice"."Total") / (SELECT SUM("Invoice"."Total") FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" < 1
;

--Revenue from normal purchases
SELECT 
	SUM("Invoice"."Total")
FROM "Invoice"
WHERE "Invoice"."Total" BETWEEN 1 AND 10
;

--Revenue percentage from normal purchases
SELECT 
	SUM("Invoice"."Total") / (SELECT SUM("Invoice"."Total") FROM "Invoice")
FROM "Invoice"
WHERE "Invoice"."Total" BETWEEN 1 AND 10
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
-- Frequency of "Genre" for bulk buys
WITH 
	cte1 AS 
	(
    SELECT 
		COUNT(*) as count_over10
	FROM "Invoice"
	INNER JOIN "InvoiceLine"
		ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
	INNER JOIN "Track"
		ON "InvoiceLine"."TrackId" = "Track"."TrackId"
	INNER JOIN "Genre"
		ON "Track"."GenreId" = "Genre"."GenreId"
	WHERE "Invoice"."Total" > 10
    ) 
SELECT 
	"Genre"."Name"
    , COUNT("Genre"."Name")
    , ROUND(COUNT("Genre"."Name") / ("cte1"."count_over10")::decimal ,5)
FROM cte1, "Invoice"
INNER JOIN "InvoiceLine"
	ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
INNER JOIN "Track"
	ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Genre"
	ON "Track"."GenreId" = "Genre"."GenreId"
WHERE "Invoice"."Total" > 10
GROUP BY "Genre"."Name", "cte1"."count_over10"
ORDER BY COUNT("Genre"."Name") DESC
;



-- Frequency of "Genre" for single buys
WITH 
	cte2 AS
    (
    SELECT 
		COUNT(*) as count_under1
	FROM "Invoice"
	INNER JOIN "InvoiceLine"
		ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
	INNER JOIN "Track"
		ON "InvoiceLine"."TrackId" = "Track"."TrackId"
	INNER JOIN "Genre"
		ON "Track"."GenreId" = "Genre"."GenreId"
	WHERE "Invoice"."Total" < 1
    )
SELECT 
	"Genre"."Name"
    , COUNT("Genre"."Name")
    , round(COUNT("Genre"."Name")::decimal / count_under1, 5)
FROM cte2, "Invoice"
INNER JOIN "InvoiceLine"
	ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
INNER JOIN "Track"
	ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Genre"
	ON "Track"."GenreId" = "Genre"."GenreId"
WHERE "Invoice"."Total" < 1
GROUP BY "Genre"."Name", "cte2"."count_under1"
ORDER BY COUNT("Genre"."Name") DESC
;
--  Frequency of genre for normal buys
--  Frequency of "Genre" for normal buys
WITH 
	cte3 AS
    (
    SELECT 
		COUNT(*) as count_between
	FROM "Invoice"
	INNER JOIN "InvoiceLine"
		ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
	INNER JOIN "Track"
		ON "InvoiceLine"."TrackId" = "Track"."TrackId"
	INNER JOIN "Genre"
		ON "Track"."GenreId" = "Genre"."GenreId"
	WHERE "Invoice"."Total" BETWEEN 1 AND 10
    )
SELECT 
	"Genre"."Name"
    , COUNT("Genre"."Name")
    , COUNT("Genre"."Name") / count_between
FROM cte3
INNER JOIN "Invoice"
INNER JOIN "InvoiceLine"
	ON "Invoice"."InvoiceId" = "InvoiceLine"."InvoiceId"
INNER JOIN "Track"
	ON "InvoiceLine"."TrackId" = "Track"."TrackId"
INNER JOIN "Genre"
	ON "Track"."GenreId" = "Genre"."GenreId"
 WHERE "Invoice"."Total" BETWEEN 1 AND 10
GROUP BY "Genre"."Name"
ORDER BY COUNT("Genre"."Name") DESC
;
