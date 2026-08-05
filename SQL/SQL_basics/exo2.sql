-- # SQL Exercises — Gaming Platform
-- ## Functions, Aggregations, GROUP BY / HAVING

-- 1. Display all usernames in uppercase.

SELECT UPPER(username)
FROM users

-- 2. Display each username with its length.

SELECT username, CHAR_LENGTH(username) AS "Longueur du username"
FROM users

-- 3. Display each game with its release year.

SELECT title, EXTRACT('YEAR' FROM release_date)
FROM games

-- 4. Display profiles and replace NULL bio with 'No bio yet'.

SELECT COALESCE(bio, 'No bio yet')
FROM profiles

-- 5. Display each game with a price label: Free or Paid.

SELECT title,
	CASE price
		WHEN 0 THEN 'Free'
		ELSE 'Paid'
	END AS "Price label"
FROM games

-- 6. Display the total number of users.

SELECT COUNT(*) AS "Nombre total d'utilisateurs"
FROM users

-- 7. Display the total number of games.

SELECT COUNT(*) AS "Nombre total de jeux"
FROM games

-- 8. Display the average game price.

SELECT AVG(price)::DECIMAL(10, 2) AS "Moyenne des prix de jeu"
FROM games

-- 9. Display the total number of hours played.

SELECT SUM(hours_played) AS "Nombre total d'heures jouées"
FROM user_games

-- 10. Display the highest and lowest rating.

SELECT MIN(rating) AS "Note la plus basse", MAX(rating) AS "Note la plus haute"
FROM reviews

-- 11. Display the number of users per country.

SELECT COUNT(username) AS "Nombre d'utilisateurs par pays", country
FROM users
GROUP BY country

-- 12. Display the number of games per publisher_id.

SELECT COUNT(title) AS "Jeux par éditeur", publisher_id
FROM games
GROUP BY publisher_id

-- 13. Display the average game price per publisher_id.

SELECT AVG(price)::DECIMAL(10, 2) AS "prix moyen par éditeur", publisher_id
FROM games
GROUP BY publisher_id

-- 14. Display the total hours played per user_id.

SELECT SUM(hours_played)::DECIMAL(10, 2) AS "Total d'heures jouées par user_id", user_id
FROM user_games
GROUP BY user_id

-- 15. Display the average hours played per user_id.

SELECT AVG(hours_played)::DECIMAL(10, 2) AS "Moyenne d'heures jouées par user", user_id
FROM user_games
GROUP BY user_id

-- 16. Display the total hours played per game_id.

SELECT SUM(hours_played) AS "Total d'heures jouées par jeu", game_id
FROM user_games
GROUP BY game_id

-- 17. Display the average rating per game_id.

SELECT AVG(rating)::DECIMAL(10, 2) AS "Note Moyenne par game_id", game_id
FROM reviews
GROUP BY game_id

-- 18. Display the number of purchases per year.

SELECT COUNT(purchase_date) AS "Jeux achetés par année", EXTRACT(YEAR FROM purchase_date)
FROM user_games
GROUP BY EXTRACT('YEAR' FROM purchase_date)

-- 19. Display the number of games released per year.

SELECT COUNT(release_date) AS "Jeux sorti par année", EXTRACT('YEAR' FROM release_date)
FROM games
GROUP BY 2 -- 2 Vaut pour le 2e argument de SELECT (EXTRACT([...]))

-- 20. Display the number of games per price category:
-- - Free if price = 0
-- - Cheap if price < 30
-- - Standard if price between 30 and 60
-- - Expensive if price > 60

SELECT COUNT(title) AS "Nombre de jeux par catégorie de prix" , 
	CASE
		WHEN price = 0 THEN 'Free'
		WHEN price < 30 THEN 'Cheap'
		WHEN price < 60 THEN 'Strandard'
		WHEN price > 60 THEN 'Expensive'
	END AS "Catégorie de prix"
FROM games
GROUP BY 2 -- 2 Vaut pour le 2e argument de SELECT

-- 21. Display the number of paid games per publisher_id.

SELECT COUNT(title) AS "Nombre de jeux publiés par éditeur", publisher_id
FROM games
WHERE price > 0
GROUP BY publisher_id

-- 22. Display the average price per publisher_id for games released after '2015-01-01'.

SELECT AVG(price)::DECIMAL(10, 2) AS "prix moyen par éditeur à partir du 01/01/15", publisher_id
FROM games
WHERE release_date >= '2015-01-01'
GROUP BY publisher_id

-- 23. Display only countries that have more than 1 user.

SELECT COUNT(username) AS "User par pays", country
FROM users
GROUP BY country
HAVING COUNT(username) > 1

-- 24. Display only user_id values with more than 300 total hours played.

SELECT user_id, SUM(hours_played) AS "Total d'heures jouées"
FROM user_games
GROUP BY user_id
HAVING SUM(hours_played) > 300

-- 25. Display only game_id values with an average rating >= 4.5.

SELECT game_id, AVG(rating)::DECIMAL(10, 2) AS "Note moyenne"
FROM reviews
GROUP BY game_id
HAVING AVG(rating) >= 4.5
