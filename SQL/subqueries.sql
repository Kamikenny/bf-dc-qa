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
	SUM(ug.hours_played) >= (	-- '>' modifié en '>=' pour pouvoir vérifier le résultat
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
	2 DESC

-- 6. Display all publishers that published at least one free game

