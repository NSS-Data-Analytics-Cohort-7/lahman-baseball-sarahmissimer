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
---ANSWER: 1871-2017 (2016 season)

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

SELECT p.namefirst AS first, p.namelast AS last, c.schoolid, CAST(CAST(SUM(DISTINCT s.salary) AS numeric)  as money) AS salary
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
AND p.namefirst = 'David'
GROUP BY p.namefirst, p.namelast, c.schoolid
ORDER BY salary;
---ANSWER: DAVID PRICE, $81,851,296

--- Tried this but decided that it was repeating 3 times, which was giving us that HUGE number.
SELECT p.namefirst AS first, p.namelast AS last, c.schoolid, CAST(CAST(SUM(s.salary) AS NUMERIC) AS MONEY)
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
GROUP BY p.namefirst, p.namelast, c.schoolid
ORDER BY SUM(s.salary) DESC;


--OPT2 for Question3
SELECT p.namefirst AS first, p.namelast AS last, c.schoolid, CAST(CAST(SUM(s.salary) AS NUMERIC) AS MONEY) AS salary
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
AND p.namefirst ='David'
GROUP BY p.namefirst, p.namelast, c.schoolid
ORDER BY salary;


---trying to see the salaries
SELECT p.namefirst AS first, p.namelast AS last, p.playerid, c.schoolid, CAST(CAST(s.salary AS numeric)  as money) AS salary
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
AND p.namefirst = 'David'
GROUP BY p.namefirst, p.namelast, c.schoolid, s.salary, p.playerid
ORDER BY salary;

----salaries 
SELECT p.namefirst AS first, p.namelast AS last, c.schoolid, CAST(CAST(SUM(DISTINCT s.salary) AS numeric)  as money) AS salary
FROM collegeplaying AS c
JOIN people AS p
USING (playerid)
JOIN salaries AS s
USING (playerid)
WHERE schoolid = 'vandy'
AND p.namefirst = 'David'
GROUP BY p.namefirst, p.namelast, c.schoolid
ORDER BY salary;


-- used to find the schoolid for vanderbilt 
SELECT *
FROM schools
WHERE schoolcity = 'Nashville';


---THIS IS TYLER'S QUERY
WITH vandy AS(
  SELECT 
            p.namefirst,
            p.namelast,
            cp.schoolid,
            cp.playerid
          FROM collegeplaying AS cp
          JOIN people AS p ---giving me all the names in colleges amd their schoolid
          USING (playerid)
          JOIN schools AS s
          USING (schoolid)
          WHERE s.schoolname LIKE '%Vanderbilt%' ---this is giving me all the players at vandy
)
SELECT vandy.namefirst, vandy.namelast, CAST(CAST(SUM(s.salary) AS numeric) AS money) AS player_pay --have to select on the vandy CTE
    FROM vandy --this is my CTE to give us the players from vandy
    JOIN salaries AS s
    ON vandy.playerid = s.playerid --have to join on the vandy CTE 
    WHERE s.salary IS NOT null
    GROUP BY vandy.namefirst,
      vandy.namelast
    ORDER BY player_pay DESC;
    
    
    
--- TYLER'S #3 - GO BACK TO REVIEW... WORKS BECAUSE OF LEFT JOIN
SELECT CONCAT(vandy.namefirst, ' ', vandy.namelast) AS name,
      CAST(CAST(SUM(s.salary) AS numeric) AS money) AS player_pay
    FROM (SELECT p.playerid,
            p.namefirst,
            p.namelast
          FROM people AS p
          LEFT JOIN collegeplaying AS cp
          USING (playerid)
          JOIN schools AS s
          USING (schoolid)
          WHERE s.schoolname LIKE '%Vanderbilt%'
          GROUP BY p.playerid) AS vandy
    JOIN salaries AS s
    ON vandy.playerid = s.playerid
    WHERE s.salary IS NOT null
    GROUP BY vandy.namefirst,
      vandy.namelast
    ORDER BY player_pay DESC;


-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
--fielding table, people table
--position 
--looking to make a table w/ 3 groups

SELECT SUM(po) AS putouts,
CASE WHEN pos = 'OF' THEN 'Outfield' ---you can use an 'IN'to get it prettier
    WHEN pos = 'SS' OR pos = '1B' OR pos= '2B' OR pos='3B' THEN 'Infield'
    WHEN pos = 'P' OR pos='C' THEN 'Battery'
    END AS position
FROM fielding
WHERE yearid = 2016
GROUP by position;
---ANSWER: Battery, 41424; Infield, 58934; Outfield, 29560


-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?


 
