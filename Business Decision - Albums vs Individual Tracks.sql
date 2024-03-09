/*
Albums vs Individual Tracks
The Chinook store is setup in a way that allows customer to make purchases in one of the two ways:
    purchase a whole album
    purchase a collection of one or more individual tracks.
The store does not let customers purchase a whole album, and then add individual tracks to that same purchase (unless they do that by choosing each track manually). 
When customers purchase albums they are charged the same price as if they had purchased each of those tracks separately.
Management are currently considering changing their purchasing strategy to save money. The strategy they are considering is to purchase only the most popular tracks from each album from record companies, instead of purchasing every track from an album.
We have been asked to find out what percentage of purchases are individual tracks vs whole albums, so that management can use this data to understand the effect this decision might have on overall revenue.
It is very common when you are performing an analysis to have 'edge cases' which prevent you from getting a 100% accurate answer to your question. In this instance, we have two edge cases to consider:
    Albums that have only one or two tracks are likely to be purchased by customers as part of a collection of individual tracks.
    Customers may decide to manually select every track from an album, and then add a few individual tracks from other albums to their purchase.
In the first case, since our analysis is concerned with maximizing revenue we can safely ignore albums consisting of only a few tracks. The company has previously done analysis to confirm that the second case does not happen often, so we can ignore this case also.
In order to answer the question, we're going to have to identify whether each invoice has all the tracks from an album. We can do this by getting the list of tracks from an invoice and comparing it to the list of tracks from an album. 
We can find the album to compare the purchase to by looking up the album that one of the purchased tracks belongs to. 
It doesn't matter which track we pick, since if it's an album purchase, that album will be the same for all tracks.

Community discussion

    Write a query that categorizes each invoice as either an album purchase or not, and calculates the following summary statistics:
        Number of invoices
        Percentage of invoices
    Write one to two sentences explaining your findings, and making a prospective recommendation on whether the Chinook store should continue to buy full albums from record companies.
*/

/* We generalize the problem by allowing invoices with both albums and individual tracks. */

/* 
Each invoice may or may not include any complete albums, and we would like to find out. 
1. For each invoice, figure out all the tracks in it and their associated albums
2. For each album, count the number of tracks in it
2. Compare the tracks in the invoice with the tracks in the associated albums by counting  */

/* count the number of tracks in each album */
CREATE TABLE Album_Track AS

SELECT *, count(track.track_id) AS AlbumTrackCount
FROM track
LEFT JOIN album
ON track.album_id = album.album_id
GROUP BY album.album_id; 

/* Count the number of tracks in each invoice for each album */

Create Table Invoice_Album AS 
SELECT i.invoice_id as InvoiceID,
	   a.album_id as AlbumID,
	   count(t.track_id) as InvoiceTrackCount,
	   AlbumTrackCount
FROM invoice i
LEFT JOIN invoice_line il
ON i.invoice_id = il.invoice_id
LEFT JOIN track t
ON il.track_id = t.track_id
LEFT JOIN Album_Track a
ON t.album_id = a.album_id
GROUP BY InvoiceID, AlbumID; 

/* Check if each invoice contains at least one complete album */
CREATE TABLE Album_Purchases AS 

SELECT InvoiceID, sum(Complete_Album_Or_Not) AS Albums_Purchased
FROM (
	  SELECT *,
      CASE
      WHEN AlbumTrackCount > InvoiceTrackCount THEN 0
      ELSE 1
      END AS Complete_Album_Or_Not
      FROM Invoice_Album
	 )
GROUP BY InvoiceID;

WITH Total_Number_Of_Invoices AS 
(
 SELECT count(*)*1.0 AS num_invoices
 FROM invoice
)

/* Calculate the Percentage of Invoices with Complete Albums */

SELECT 
       sum(IF_Albums_Purchased) / (SELECT num_invoices FROM Total_Number_Of_Invoices) * 100 
	   As Percentage_Of_Invoices_With_Album_Purchases
FROM 
/* an invoice contains a complete album (regardless of how many) is marked 1 otherwise 0 */
    (SELECT *,
	        CASE
			WHEN Albums_Purchased > 0 Then 1
			ELSE 0
			END AS IF_Albums_Purchased
	 FROM Album_Purchases); 






