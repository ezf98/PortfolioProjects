-- Olympic Games Dataset

-- First we need to create the tables, and then import the CSV file. 
-- I already saw that some attributes (Age, Weight and Height) have empty values, so if INT type is assigned the import will fail.

DROP TABLE IF EXISTS olympics;
CREATE TABLE IF NOT EXISTS olympics
(
   id     INT,
   name   VARCHAR,
   sex    VARCHAR,
   age    VARCHAR,
   height VARCHAR,
   weight VARCHAR,
   team   VARCHAR,
   noc    VARCHAR,
   games  VARCHAR,
   year   INT,
   season VARCHAR,
   city   VARCHAR,
   sport  VARCHAR,
   event  VARCHAR,
   medal  VARCHAR
)

-- Let's check if it was imported correctly:

SELECT * FROM olympics;


-- How many olympics game have been held?

SELECT COUNT(DISTINCT games) as total_games
FROM olympics;

-- Now let's list all of them.

SELECT DISTINCT year, season, city
FROM olympics
ORDER BY 1 ASC;

-- How many nations participated in each Olympic Game?

SELECT games, COUNT(DISTINCT noc)
FROM olympics
GROUP BY games
ORDER BY 2 desc
-- Which sports were played in all summer Olympics?

SELECT COUNT (DISTINCT games)
FROM olympics
WHERE season = 'Summer'

WITH table1 as
 (SELECT distinct sport, games
 FROM olympics
 WHERE season = 'Summer'),
table2 as 
(select sport, count(games)
from table1
group by sport)

select * from table2
order by 2 desc

-- Which nation has participated in all the Olympic games?

SELECT count (Distinct games)
FROM olympics

WITH table1 as
(SELECT DISTINCT games, team
FROM olympics
),
table2 as 
(SELECT team, count(team)
FROM table1
GROUP BY team)

SELECT * FROM table2 
ORDER BY 2 desc

-- Are there sports that were played only once? Which one(s)?

WITH t1 as 
(SELECT DISTINCT games, sport
FROM olympics),

t2 as 
(SELECT sport, COUNT(1) as played_once
FROM t1
GROUP BY sport)

SELECT t2.*, t1.games
FROM T2
JOIN t1 ON t1.sport = t2.sport
WHERE t2.played_once = 1
ORDER BY t1.sport

-- How many sports were played in each Olympic game?

WITH t1 as
(SELECT DISTINCT games, sport
FROM olympics),
t2 as
(SELECT games, COUNT(1) as total_sports
FROM t1
GROUP BY games)
SELECT * from t2
ORDER BY total_sports desc

-- Who are/were the top 5 athletes by the number of gold medals won?
WITH t1 as 
(SELECT name, team, medal
FROM olympics
WHERE medal = 'Gold'),

t2 as 
(SELECT name, COUNT(medal) as total_gold_medals
FROM t1
GROUP BY name)

SELECT * FROM t2
ORDER BY total_gold_medals DESC
LIMIT 5

-- Which are the top 5 most successful countries? Let's define "success" by the number of medals won
WITH t1 as
(SELECT noc, medal
FROM olympics
WHERE medal != 'NA'),
t2 as
(SELECT noc, COUNT(medal) as total_medals
FROM t1
GROUP BY noc)

SELECT * FROM t2
ORDER BY total_medals DESC
LIMIT 5

-- Up to 2020 there were 51 Olympic Games held, with only a few countries at the beggining (12 countries, 1896 Summer Olympics)
-- and a huge amount in modern times (207 countries, 2016 Summer Olympics)
-- We also learned that the more laurelled countries are/were USA, URSS, Germany, UK and France; 
-- USA also has the sportman with most Gold medals, Michael Phelps (An astonishing 23 medals!)  
-- An interesting discovery was about the sports that were only played once, such as Aeronautics, Cricket and Roque.

-- In conclusion, really interesting facts were found within this dataset, which will surely pick the interest of any Olympics entusiast.