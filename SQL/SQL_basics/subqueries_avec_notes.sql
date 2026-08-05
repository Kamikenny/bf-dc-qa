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
-- CORRECTION
SELECT
	g.title,
	-- g.publisher_id,  Obligatoire si on n'utilise pas "g.id" dans le GROUP BY
	SUM(ug.hours_played) AS total_hours
FROM
	games g
JOIN
	user_games ug ON ug.game_id = g.id
GROUP BY
	g.id -- PRIMARY KEY pour transférer les autres colonnes aux sous requêtes ("g.title, g.publisher_id" fonctionnerait aussi si "g.publisher_id" était dans le SELECT)
HAVING
	SUM(ug.hours_played) > (
		SELECT
			AVG(pub_totals.total_hours_sub)
		FROM
			(
				SELECT
					g2.title,
					g2.publisher_id, -- Doit être ajoutée, car on utilise le tableau en externe. Si pas de colonne dans le tableau, on n'a pas les données
					SUM(ug2.hours_played) AS total_hours_sub
				FROM
					games g2
				JOIN
					user_games ug2 ON ug2.game_id = g2.id
				GROUP BY
					g2.id -- PRIMARY KEY pour transférer les autres colonnes aux requêtes externes ("g2.title, g2.publisher_id" fonctionnerait aussi)
			) AS pub_totals
		WHERE
			pub_totals.publisher_id = g.publisher_id
	)

-- 10. Display all users whose total hours played are greater than ALL users from Belgium
-- CORRECTION
SELECT
	u.username,
	SUM(ug.hours_played) AS total_hours
FROM
	users u
JOIN
	user_games ug ON ug.user_id = u.id
GROUP BY
	u.id
HAVING
	SUM(ug.hours_played) > ALL (
		SELECT
			SUM(ug2.hours_played)
		FROM
			users u2
		JOIN
			user_games ug2 ON ug2.user_id = u2.id
		WHERE
			u2.country = 'Belgium'
		GROUP BY
			u2.id
	)

-- 11. Display all games that have at least one review
-- CORRECTION
SELECT
	g.title
FROM
	games g 
WHERE EXISTS (
	SELECT
		1 -- pas besoin de récupérer les données, on doit juste vérifier que la donnée existe
	FROM
		reviews r 
	WHERE
		r.game_id = g.id
)

-- 12. Display all games that were never reviewed
-- CORRECTION
SELECT
	g.title
FROM
	games g 
WHERE NOT EXISTS (
	SELECT
		1 -- pas besoin de récupérer les données, on doit juste vérifier que la donnée existe
	FROM
		reviews r 
	WHERE
		r.game_id = g.id
)

-- --

-- 14. Display all users who own at least one game in common with user 'Davit'.
-- CORRECTION
SELECT
	u.username
FROM
	users u 
WHERE EXISTS (
	SELECT	
		1 -- On vérifie l'existence, pas les données
	FROM
		user_games ug
	WHERE 
		ug.user_id = u.id AND ug.game_id IN (
			SELECT
				game_id 
			FROM 
				user_games
			WHERE
				user_id = (
				SELECT
					id
				FROM
					users 
				WHERE
					username ILIKE 'davit'
				)
		)
)

-- 15. Display all users who reviewed a game they do NOT own -- EXEMPLE de cas pratique de testeur. On vérifie qu'une entrée impossible n'existe pas. ICI la requête renvoie une ligne, c'est une anomalie.
-- CORRECTION
SELECT
	u.username
FROM
	users u
WHERE
	EXISTS (
		SELECT
			1 -- On check l'existence, pas l'info
		FROM
			reviews r 
		WHERE
			r.user_id = u.id -- On vérifie s'il existe une review faite par le 'user'
				AND NOT EXISTS ( -- MAIS qu'il n'y ait pas d'entrée d'entrée dans user_games pour l'user et le jeu ciblé par la review
					SELECT
						1 -- On check l'existence, pas l'info
					FROM
						user_games ug
					WHERE
						ug.user_id = u.id AND ug.game_id = r.game_id -- il y a une entrée avec l'id de l'user  ET l'id du jeu qui correspond à la review
				)
	)

-- 17. Using a CTE, display the top 3 users with the most total hours played.
-- CORRECTION
WITH user_hours AS ( -- On crée un nouveau tableau avec les données qu'on veut
	SELECT
		user_id,
		SUM(hours_played) AS total_hours
	FROM
		user_games
	GROUP BY
		user_id
)
SELECT -- On crée une requête basée sur le tableau créé précédemment
	u.username,
	uh.total_hours
FROM 
	user_hours uh
JOIN 
	users u ON uh.user_id = u.id
ORDER BY
	uh.total_hours DESC
LIMIT
	3