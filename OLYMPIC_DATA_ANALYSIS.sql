SELECT * FROM OLYMPIC_HISTORY
SELECT * FROM OLYMPIC_NOC

1.How many olympics games have been held?

SELECT COUNT(DISTINCT(GAMES)) FROM OLYMPIC_HISTORY

2.List down all Olympics games held so far.

SELECT YEAR, SEASON, CITY FROM OLYMPIC_HISTORY ORDER BY 1 ASC;

3.Mention the total no of nations who participated in each olympics game?

with all_countries as
        (select games, nr.region
        from OLYMPIC_HISTORY oh
        join OLYMPIC_NOC nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(1) as total_countries
    from all_countries
    group by games
    order by games; 
	
4. Which nation has participated in all of the olympic games

with tot_games as (select count(distinct games) as total_games from olympic_history), 
countries as (select games, nr.region as country from olympic_history oh join olympic_noc nr ON nr.noc=oh.noc
group by games, nr.region), countries_participated as (select country, count(1) as total_participated_games from countries
group by country) select cp.* from countries_participated cp join tot_games tg on tg.total_games = cp.total_participated_games
order by 1;

5. Identify the sport which was played in all summer olympics.

WITH T1 AS (SELECT COUNT(DISTINCT GAMES) AS TOTAL_SUMMER_GAMES FROM OLYMPIC_HISTORY WHERE SEASON='Summer'),

T2 AS (SELECT DISTINCT SPORT, GAMES FROM OLYMPIC_HISTORY WHERE SEASON='Summer' ORDER BY GAMES),

T3 AS (SELECT SPORT, COUNT(GAMES) AS NO_OF_GAMES FROM T2 GROUP BY SPORT)

SELECT * FROM T3;

6. Fetch the top 5 athletes who have won the most gold medals.

WITH T1 AS(SELECT NAME, COUNT(*)AS TOTAL_GOLD FROM OLYMPIC_HISTORY 
		   WHERE MEDAL='Gold' GROUP BY 1 ORDER BY TOTAL_GOLD),
	T2 AS(SELECT *, DENSE_RANK() OVER(ORDER BY TOTAL_GOLD DESC)AS RNK FROM T1)
	SELECT * FROM T2 WHERE RNK<=5

7.List down total gold, silver and bronze medals won by each country.

SELECT NR.REGION AS COUNTRY, MEDAL, COUNT(*) AS TOTAL_MEDALS FROM OLYMPIC_HISTORY OH
JOIN OLYMPIC_NOC NR ON NR.NOC = OH.NOC WHERE MEDAL <> 'NA'
GROUP BY NR.REGION, MEDAL
ORDER BY NR.REGION, MEDAL;

SELECT COUNTRY, COALESCE (Gold, 0) AS GOLD,
COALESCE (Silver, 0) AS SILVER,
COALESCE (Bronze, 0) AS BRONZE
FROM CROSSTAB ('SELECT NR.REGION AS COUNTRY, MEDAL, COUNT(*) AS TOTAL_MEDALS FROM OLYMPIC_HISTORY OH
JOIN OLYMPIC_NOC NR ON NR.NOC = OH.NOC WHERE MEDAL <> ''NA''
GROUP BY NR.REGION, MEDAL
ORDER BY NR.REGION, MEDAL', 'VALUES(''Gold''),(''Silver''),(''Bronze'')' ) 
AS RESULT(COUNTRY VARCHAR, Gold BIGINT,Silver BIGINT,Bronze BIGINT)
order by GOLD desc, SILVER DESC, BRONZE DESC

8.Fetch the total no of sports played in each olympic games.
WITH T1 AS
      	(SELECT DISTINCT GAMES, SPORT
      	FROM OLYMPIC_HISTORY),
        T2 AS
      	(SELECT GAMES, count(1) as no_of_sports
      	FROM T1
      	GROUP BY GAMES)
      SELECT * FROM T2
      ORDER BY no_of_sports desc;





 
