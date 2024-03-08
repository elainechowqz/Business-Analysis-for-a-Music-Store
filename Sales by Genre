/* 
The Chinook record store has just signed a deal with a new record label, and you've been tasked with selecting the first three albums that will be added to the store, from a list of four. All four albums are by artists that don't have any tracks in the store right now - we have the artist names, and the genre of music they produce:
Artist Name 	Genre
Regal 	Hip-Hop
Red Tone 	Punk
Meteor and the Girls 	Pop
Slim Jim Bites 	Blues

The record label specializes in artists from the USA, and they have given Chinook some money to advertise the new albums in the USA, so we're interested in finding out which genres sell the best in the USA.

You'll need to write a query to find out which genres sell the most tracks in the USA, write up a summary of your findings, and make a recommendation for the three artists whose albums we should purchase for the store.

Community discussion

    Write a query that returns each genre, with the number of tracks sold in the USA:
        in absolute numbers
        in percentages.
    Write a paragraph that interprets the data and makes a recommendation for the three artists whose albums we should purchase for the store, based on sales of tracks from their genres.
 */

CREATE TABLE GenreSales AS

/* define CTE */
WITH TotalQuantity AS (
	SELECT SUM(quantity)*1.0 AS total_quantity FROM invoice_line
)

/* Replace Null values with Zero */
SELECT genre_name, 
       IFNULL(sales_number, 0) AS sales_number, 
       IFNULL(sales_percentage, 0) AS sales_percentage
FROM (
	  /* calculate the number of tracks sold and percentages for each genre: */
	  SELECT genre.name AS genre_name, sum(invoice_line.quantity) AS sales_number, 
             sum(invoice_line.quantity)/ (SELECT total_quantity FROM TotalQuantity) * 100 AS sales_percentage
	  FROM genre
	  LEFT JOIN track USING(genre_id)
	  LEFT JOIN invoice_line USING(track_id)
	  GROUP BY genre.name
	  ORDER BY sales_number DESC
)