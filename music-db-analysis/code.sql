-- Section1

WITH artist_tracks AS (
    SELECT
        track.TrackId,
        artist.Name AS ArtistName
    FROM
        artist
    JOIN album  ON artist.ArtistId = album.ArtistId
    JOIN track  ON album.AlbumId = track.AlbumId
),
customer_tracks AS (
    SELECT DISTINCT
        invoiceline.InvoiceId,
        invoice.CustomerId,
        artist_tracks.ArtistName
    FROM
        invoiceline
    JOIN invoice  ON invoiceline.InvoiceId = invoice.InvoiceId
    JOIN artist_tracks  ON invoiceline.TrackId = artist_tracks.TrackId
),
artist_pairs AS (
    SELECT DISTINCT
        ct1.CustomerId,
        ct1.ArtistName AS artist_A,
        ct2.ArtistName AS artist_B
    FROM
        customer_tracks ct1
    JOIN customer_tracks ct2 ON ct1.CustomerId = ct2.CustomerId
    WHERE ct1.ArtistName < ct2.ArtistName
),
pair_counts AS (
    SELECT
        artist_A,
        artist_B,
        COUNT(DISTINCT CustomerId) AS num_occurrences
    FROM
        artist_pairs
    GROUP BY
        artist_A,
        artist_B
)
SELECT
    artist_A,
    artist_B,
    num_occurrences
FROM pair_counts
ORDER BY
num_occurrences desc,
    artist_A ASC, 
    artist_B ASC
LIMIT 200;


-- Section2

WITH total_sells AS (
    SELECT 
        invoice.CustomerId,
        SUM(invoiceline.UnitPrice * invoiceline.Quantity) AS total_spent
    FROM 
        Invoice
    JOIN 
        InvoiceLine 
        ON invoice.InvoiceId = invoiceline.InvoiceId
    WHERE 
        YEAR(invoice.InvoiceDate) >= 2010
    GROUP BY
        invoice.CustomerId
),

customers_information AS (
    SELECT
        customer.FirstName,
        customer.LastName,
        total_sells.total_spent
    FROM
        customer
    JOIN
        total_sells
    ON
        customer.CustomerId = total_sells.CustomerId
),

ranked_customers AS (
    SELECT
        FirstName,
        LastName,
        total_spent,
        PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS percentile_rank
    FROM
        customers_information
)

SELECT
    FirstName,
    LastName,
    total_spent,
    CASE
        WHEN percentile_rank <= 0.3 THEN 'top'  -- 30% اول
        WHEN percentile_rank >= 0.7 THEN 'low'  -- 30% آخر
        ELSE 'middle'  -- مابقی
    END AS customer_level
FROM
    ranked_customers
ORDER BY 
    total_spent DESC, 
    LastName ASC;