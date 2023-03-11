-- First let's create the database and the table, they will contain the file with the data
CREATE database spotify 
USE spotify;
CREATE TABLE sp (
	artist VARCHAR (20),
    song VARCHAR (50),
    duration INT,
    explicit VARCHAR(15),
    year INT,
    popularity INT,
    danceability FLOAT,
    energy FLOAT,
    track_key INT,
    loudness FLOAT,
    modality bool,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumental FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT, 
    genre VARCHAR (50)
    );
  
  -- Now, we should check if everything looks correct
 -- SELECT * FROM sp LIMIT 10;   
 -- Find if there are any rows with NULL values
 
 SELECT * FROM sp
 WHERE artist IS NULL OR 
 song IS NULL OR 
 explicit IS NULL OR
 year IS NULL OR
 genre IS NULL;
 
 -- Seems none of the main columns have null values, that's great!
 -- I would like to know how many artists and genres there are:
 
 SELECT COUNT( DISTINCT artist)
 FROM sp; -- 506 Artists
 
 SELECT COUNT( DISTINCT genre)
 FROM sp; -- 50 Genres 
 
 -- And how long does the average song lasts?
 
 SELECT AVG (duration)
 FROM sp;
 
 -- This in miliseconds, to make it a bit more clear, let's turn it to seconds
 
 SELECT CAST(AVG(duration) DIV 1000 AS UNSIGNED) as duration
 from sp; -- 236 seconds, near 4 minutes
 
 -- Does each genre has different avg lenghts?
 
 SELECT genre, CAST(AVG(duration) DIV 1000 AS UNSIGNED) as duration
 from sp
 GROUP BY genre
 ORDER BY 2; -- The shortest seems to be traditional acoustic pop with 187 (3 minutes) in average, the longest Folk/Acoustic rock with 278 (5 minutes)
 
 -- How many songs do we have per each genre?
 
 SELECT genre, COUNT(DISTINCT song)
 FROM sp
 GROUP BY genre
 ORDER BY 2; -- The most popular genre is, not surprisingly, pop with 207 hits troughout the years
 
 -- I want to know the most popular songs, let's say above 75 in rating
 
 SELECT artist, song, popularity
 FROM sp
 WHERE popularity >= 75
 ORDER BY 3 DESC; -- Thanks to this, I discovered there are some duplicates! Linkin Park appears twice with the same song
 
 -- Let's see how many duplicates there are
 
 SELECT song, COUNT(*)
 FROM sp
 GROUP BY song
 HAVING COUNT(*) > 1; -- 21 duplicated songs, let's get rid of the duplicates
 
 DELETE FROM sp
 WHERE song IN (
 SELECT song, COUNT(*)
 FROM sp
 GROUP BY song
 HAVING COUNT(*) > 1
 LIMIT1
 ); -- Seems that this version of MySQL doesn't support this kind of subquery.
 
 
 SELECT song 
 FROM ( 
 SELECT song,
 row_number() OVER (PARTITION BY song
 ORDER BY song) as row_num
 from sp) t
 WHERE row_num > 1;
 
 DELETE FROM sp
WHERE song IN(
SELECT song 
FROM (SELECT song,
row_number() OVER (PARTITION BY song
ORDER BY song) as row_num
FROM sp
) t
WHERE row_num > 1
);

 SELECT song, COUNT(*)
 FROM sp
 GROUP BY song
 HAVING COUNT(*) > 1; -- Duplicates deleted!
 
 -- Finally, let's get rid of the "key" column, as I won't be using it
 
ALTER TABLE sp
DROP COLUMN track_key;

SELECT * FROM sp;