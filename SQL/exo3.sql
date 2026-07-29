-- # SQL Exercises — Gaming Platform

-- ## JOINs and Advanced SELECT

-- ## Level 1 — Fundamentals

-- ### 1. Games and publishers

-- Display every game with its publisher.

-- Expected columns:

-- * `game_title`
-- * `publisher_name`

SELECT 
	g.title AS "game_title",
	p.name AS "publisher_name"
FROM
	games g
JOIN
	publishers p ON p.id = g.publisher_id

-- ### 2. Owned games

-- Display every game owned by a user.

-- Expected columns:

-- * `username`
-- * `game_title`
-- * `hours_played`

SELECT 
	u.username AS "username",
	g.title AS "game_title",
	ug.hours_played AS "hours_played"
FROM
	user_games ug
JOIN
	users u ON ug.user_id = u.id
JOIN
	games g ON g.id = ug.game_id

-- ### 3. Users and profiles

-- Display all users with their profile information.

-- Users without a profile must still appear.

-- Expected columns:

-- * `username`
-- * `bio`
-- * `avatar_url`

SELECT 
	u.username AS "username",
	p.bio AS "bio",
	p.avatar_url AS "avatar_url"
FROM
	profiles p
RIGHT JOIN
	users u ON p.user_id = u.id

-- ### 4. Reviews

-- Display every review with the user and game information.

-- Expected columns:

-- * `username`
-- * `game_title`
-- * `rating`
-- * `comment`

SELECT
	u.username AS "username",
	g.title AS "game_title",
	r.rating AS "rating",
	r.comment AS "comment"
FROM
	reviews r
JOIN
	users u ON r.user_id = u.id
JOIN
	games g ON r.game_id = g.id

-- ### 5. Publishers and games

-- Display all publishers with their games.

-- Publishers without games must still appear.

-- Expected columns:

-- * `publisher_name`
-- * `game_title`

SELECT
	p.name AS "publisher_name",
	g.title AS "game_title"
FROM
	publishers p
LEFT JOIN
	games g ON p.id = g.publisher_id

-- ### 6. Users without games

-- Display all users who have never bought a game.

-- Expected columns:

-- * `username`

SELECT
	username
FROM
	users
EXCEPT
SELECT
	u.username AS "username"
FROM
	user_games ug
JOIN
	users u ON u.id = ug.user_id

-- ### 7. Game purchases

-- Display all users with the games they own and the corresponding purchase date.

-- Expected columns:

-- * `username`
-- * `game_title`
-- * `purchase_date`

SELECT
	u.username AS "username",
	g.title AS "game_title",
	ug.purchase_date AS "purchase_date"
FROM
	user_games ug
JOIN
	users u ON u.id = ug.user_id
JOIN
	games g ON g.id = ug.game_id

-- ### 8. Games without purchases

-- Display all games that have never been purchased.

-- Expected columns:

-- * `game_title`

SELECT 
	g.title
FROM
	games g
EXCEPT
SELECT
	g.title
FROM
	user_games ug
JOIN
	games g ON g.id = ug.game_id

-- ### 9. Number of players per game

-- Display every game with its total number of players.

-- Games without players must still appear.

-- Expected columns:

-- * `game_title`
-- * `total_players`

SELECT
	g.title AS "game_title",
	COUNT(ug.user_id)
FROM
	user_games ug
RIGHT JOIN
	games g ON g.id = ug.game_id
GROUP BY
	g.title

-- ### 10. Average rating per game

-- Display every reviewed game with its average rating.

-- Expected columns:

-- * `game_title`
-- * `average_rating`

SELECT
	g.title AS "game_title",
	AVG(r.rating)::DECIMAL(3, 2) AS "average_rating"
FROM
	reviews r
JOIN
	games g ON g.id = r.game_id
GROUP BY
	g.title

-- ## Level 2 — Intermediate

-- ### 11. User activity summary

-- Display all users with the number of games they own and their total number of hours played.

-- Users without games must still appear.

-- Expected columns:

-- * `username`
-- * `games_owned`
-- * `total_hours_played`

SELECT
	u.username AS "username",
	COUNT(ug.purchase_date) AS "games_owned",
	COALESCE(SUM(ug.hours_played), 0) AS "total_hours_played"
FROM
	user_games ug
RIGHT JOIN
	users u ON u.id = ug.user_id
GROUP BY
	u.username

-- ### 12. Publishers with several games

-- Display publishers that have published more than one game.

-- Expected columns:

-- * `publisher_name`
-- * `total_games`

SELECT
	p.name AS "publisher_name",
	COUNT(g.title) AS "total_games"
FROM
	publishers p
JOIN
	games g ON g.publisher_id = p.id
GROUP BY
	p.name
HAVING
	COUNT(g.title) > 1

-- ### 13. Highly played games

-- Display games for which the total number of hours played exceeds 500.

-- Expected columns:

-- * `game_title`
-- * `total_hours_played`

SELECT
	g.title AS "game_title",
	SUM(ug.hours_played) AS "total_hours_played"
FROM
	user_games ug
JOIN
	games g ON g.id = ug.game_id
GROUP BY
	g.title
HAVING
	SUM(ug.hours_played) > 500

-- ### 14. Active reviewers

-- Display users who have written more than one review.

-- Expected columns:

-- * `username`
-- * `reviews_written`

SELECT
	u.username AS "username",
	COUNT(r.comment) AS "reviews_written"
FROM
	reviews r
JOIN
	users u ON u.id = r.user_id
GROUP BY
	u.username
HAVING
	COUNT(r.comment) > 1

-- ### 15. Most-played games

-- Display the five games with the highest total number of hours played.

-- Expected columns:

-- * `game_title`
-- * `total_hours_played`

-- The most-played game must appear first.

SELECT
	g.title AS "game_title",
	SUM(ug.hours_played) AS "total_hours_played"
FROM
	user_games ug
JOIN
	games g ON g.id = ug.game_id
GROUP BY
	g.title
ORDER BY
	SUM(ug.hours_played) DESC
LIMIT 5

-- ## Level 3 — Advanced

-- ### 16. Detailed game review statistics

-- Display all games with their publisher and review statistics.

-- Games without reviews must still appear.

-- Expected columns:

-- * `game_title`
-- * `publisher_name`
-- * `total_reviews`
-- * `average_rating`

-- Order the result by average rating from highest to lowest.

SELECT
	g.title AS "game_title",
	p.name AS "publisher_name",
	COALESCE(COUNT(r.rating), 0) AS "total_reviews",
	AVG(r.rating)::DECIMAL(3,2) AS "average_rating"
FROM
	reviews r
RIGHT JOIN
	games g ON g.id = r.game_id
JOIN
	publishers p ON g.publisher_id = p.id
GROUP BY 
	g.title,
	p.name
ORDER BY
	AVG(r.rating)::DECIMAL(3,2)


-- ### 17. Complete user activity

-- Display all users with the number of games they own and the number of reviews they have written.

-- Users without games or reviews must still appear.

-- Expected columns:

-- * `username`
-- * `games_owned`
-- * `reviews_written`

-- Be careful not to count the same game or review several times.

SELECT
	u.username AS "username",
	COUNT(DISTINCT ug.game_id) AS "games_owned",
	COUNT(DISTINCT r.comment) AS "reviews_written"
FROM
	users u
LEFT JOIN
	user_games ug ON u.id = ug.user_id
LEFT JOIN
	reviews r ON r.user_id = u.id
GROUP BY
	u.username

-- ### 18. Users loyal to a publisher

-- Display every user who owns at least two games from the same publisher.

-- Expected columns:

-- * `username`
-- * `publisher_name`
-- * `games_owned_from_publisher`

SELECT
	u.username AS "username",
	p.name AS "publisher_name",
	COUNT(ug.game_id) AS "games_owned_from_publisher"
FROM
	user_games ug
JOIN
	users u ON ug.user_id = u.id
JOIN
	games g ON ug.game_id = g.id
JOIN
	publishers p ON g.publisher_id = p.id
GROUP BY
	u.username,
	p.name
HAVING
	COUNT(ug.game_id) >= 2

-- ### 19. Local publisher audiences

-- For each publisher, display the number of distinct players who come from the same country as the publisher.

-- Publishers without matching players must still appear.

-- Expected columns:

-- * `publisher_name`
-- * `publisher_country`
-- * `local_players`

-- ---

-- ### 20. Publishers ranked by playtime

-- Display all publishers with the total number of hours played across all their games.

-- Publishers whose games have never been played must still appear.

-- Expected columns:

-- * `publisher_name`
-- * `total_hours_played`

-- Order the result from the highest total playtime to the lowest.