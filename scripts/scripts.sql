--random table for how many games each player has played;
SELECT p.namegiven, a.g_all
FROM people AS p
JOIN appearances AS a
USING (playerid);



--- What range of years for baseball games played does the provided database cover?
SELECT namegiven, debut
FROM people
WHERE debut IS NOT NULL
ORDER BY debut ASC;
---ANSWER: 1871

---Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT p.namegiven, MIN(p.height) AS height, a.g_all, p.namelast, t.name
FROM people AS p
JOIN appearances AS a
USING (playerid)
JOIN teams AS t
USING (teamid)
WHERE p.height IS NOT null
GROUP BY p.namegiven, a.g_all, p.namelast, t.name
ORDER BY height ASC
LIMIT 1;
--- Edward Gaedel, 43", 1, St. Louis Browns

---Find all players in the database who played at Vanderbilt University. (A)Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned.(B) Which Vanderbilt player earned the most money in the majors?

SELECT p.namefirst AS first, p.namelast AS last, c.schoolid, CAST(CAST(SUM(s.salary) AS NUMERIC) AS MONEY)
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
GROUP BY p.namefirst, p.namelast, c.schoolid
ORDER BY SUM(s.salary) DESC;
---ANSWER: DAVID PRICE, $245,553,888

-- used to find the schoolid for vanderbilt 
SELECT *
FROM schools
WHERE schoolcity = 'Nashville';

---THIS IS TYLER'S QUERY
WITH vandy AS(
     SELECT p.playerid,
            p.namefirst,
            p.namelast
          FROM people AS p
          JOIN collegeplaying AS cp
          USING (playerid)
          JOIN schools AS s
          USING (schoolid)
          WHERE s.schoolname LIKE '%Vanderbilt%'
          GROUP BY p.playerid
)
SELECT vandy.namefirst, vandy.namelast, CAST(CAST(SUM(s.salary) AS numeric) AS money) AS player_pay
    FROM vandy
    JOIN salaries AS s
    ON vandy.playerid = s.playerid
    WHERE s.salary IS NOT null
    GROUP BY vandy.namefirst,
      vandy.namelast
    ORDER BY player_pay DESC;

