-- --- PART 1
-- 1. Display all games that cost more than the average game price

SELECT
	g.title AS "Games",
	g.price AS "Price"
FROM
	games g
WHERE
	g.price > (
		SELECT
			AVG(g1.price)
		FROM
			games g1
	)
GROUP BY
	g.title,
	g.price
ORDER BY
	1

-- -- CORRECTION
SELECT
	title,
	price
FROM
	games
WHERE
	price > (
		SELECT
			AVG(price)
		FROM
			games
	)

-- 2. Display all games whose price is equal to the maximum game price

SELECT
	g.title,
	g.price
FROM
	games g
WHERE
	g.price = (
		SELECT
			MAX(g1.price)
		FROM
			games g1
	)

-- 3. Display all games that have the highest average rating

SELECT
	g.title,
	AVG(r.rating)::DECIMAL(3, 2) AS "Moyenne d'évaluation"
FROM
	games g
JOIN
	reviews r ON r.game_id = g.id
GROUP BY
	g.title
HAVING
	AVG(r.rating) > (
		SELECT
			AVG(r1.rating)
		FROM
			reviews r1
	)
ORDER BY
	1

-- -- CORRECTION
SELECT
	g.title,
	AVG(r.rating)::DECIMAL(10, 2) AS "avg_rating"
FROM
	games g
JOIN
	reviews r ON r.game_id = g.id
GROUP BY
	g.title
HAVING
	AVG(r.rating) = (
		SELECT
			MAX(avg_rating)
		FROM
			(
				SELECT
					AVG(rating) as avg_rating
				FROM
					reviews
				GROUP BY
					game_id
			)
	)

-- 4. Display all games whose total played hours are greater than the total played hours of Elden Ring

SELECT
	g.title,
	SUM(ug.hours_played) AS "total hours played"
FROM
	user_games ug
JOIN
	games g ON g.id = ug.game_id
GROUP BY
	g.title
HAVING
	SUM(ug.hours_played) > (
		SELECT
			SUM(ug1.hours_played)
		FROM
			user_games ug1
		JOIN
			games g1 ON ug1.game_id = g1.id AND g1.title ILIKE '%elden%'
	)
ORDER BY
	2 DESC

-- 5. Display all publishers whose average game price is above the global average game price

SELECT
	p.name,
	AVG(g.price)::DECIMAL(10, 2) AS "prix moyen par éditeur"
FROM
	games g
JOIN
	publishers p ON g.publisher_id = p.id
GROUP BY
	p.name
HAVING
	AVG(g.price) > (
		SELECT
			AVG(price)::DECIMAL(10, 2) -- 30.89
		FROM
			games
	)
ORDER BY
	1

-- 6. Display all publishers that published at least one free game
-- Pas réussi avec subqueries

SELECT
	DISTINCT p.name
FROM
	publishers p
JOIN
	games g ON g.publisher_id = p.id AND g.price = 0

-- 7. Display all games whose price is greater than ANY game published by Rockstar Games.

SELECT
	g.title,
	g.price
FROM
	games g
WHERE
	g.price > ANY (
		SELECT
			g1.price -- 14.99, 29.99, 59.99
		FROM
			games g1
		JOIN
			publishers p ON g1.publisher_id = p.id AND p.name ILIKE '%rockstar%'
	)

-- 8. Display all games that are more expensive than the average price of their publisher.

SELECT
	g.title,
	g.price
FROM
	games g
WHERE
	g.price > (
		SELECT
			AVG(g1.price)::DECIMAL(10, 2)
		FROM
			games g1
		WHERE
			g.publisher_id = g1.publisher_id
	)
ORDER BY
	g.title ASC

-- 9* . Display all games whose total played hours are above the average total played hours of their publisher.

SELECT -- ERRONE
	g.title,
	SUM(ug.hours_played) AS total_hours
FROM
	games g
JOIN
	user_games ug ON ug.game_id = g.id
GROUP BY
	g.title
HAVING
	SUM(ug.hours_played) > (
		SELECT
			AVG(pub_totals.total_hours_sub)
		FROM
			(
				SELECT
					g2.title,
					SUM(ug2.hours_played) AS total_hours_sub
				FROM
					games g2
				JOIN
					user_games ug2 ON ug2.game_id = g2.id
				GROUP BY
					g2.title
			) AS pub_totals
		WHERE
			pub_totals.g2.publisher_id = g.publisher_id
	) -- ERRONE
