-- # PARTIE 1

-- 1.1 --
SELECT
	u.role,
	SUM(u.id) AS "nombre d'users par rôle"
FROM
	users u
GROUP BY
	u.role

-- 1.2 --
SELECT
	e.title,
	e.status
FROM 
	events e
WHERE
	e.status != 'published'
	
-- Gala de charité annulé
-- Marathon Charleroi Expo en brouillon, pas encore publié

-- 1.3 --
SELECT
	o.id,
	o.status,
	o.created_at,
	o.expires_at
FROM
	orders o
WHERE
	o.status = 'pending' AND o.expires_at < NOW()

-- Il y a 4 commandes 'pending' qui n'ont pas expiré après 10 minutes comme prévu.

-- 1.4 --
SELECT
	pc.id,
	pc.code,
	pc.expires_at
FROM
	promo_codes pc
WHERE
	pc.expires_at < NOW()

-- Les codes 'EXPIRED15' et 'OLDCODE20' sont expirés et ne devraient plus être utilisables

-- 1.5 --
SELECT
	pc.code,
	pc.used_count,
	pc.max_uses,
	NOW() > pc.expires_at AS "Code expiré ?"
FROM
	promo_codes pc
WHERE
	pc.code = 'FLASH50'

-- # PARTIE 2

-- 2.1 --
SELECT
	u.email,
	o.status AS order_status,
	(o.total_cents / 100)::MONEY AS total
FROM
	orders o
LEFT JOIN
	users u ON o.user_id = u.id
WHERE
	o.status = 'paid'

-- 2.2 --
SELECT
	oi.id,
	tc.name,
	e.title
FROM
	order_items oi
JOIN
	ticket_categories tc ON oi.category_id = tc.id
JOIN
	events e ON tc.event_id = e.id

-- 2.3 --
SELECT
	e.id AS event_id,
	SUM(o.id) AS total_orders
FROM
	orders o
FULL JOIN
	events e ON o.event_id = e.id AND o.status = 'paid'
GROUP BY
	e.id
ORDER BY
	e.id
-- Les résultats diffèrent
SELECT
	e.id AS event_id,
	SUM(o.id) AS total_orders
FROM
	orders o
FULL JOIN
	order_items oi ON o.id = oi.order_id AND o.status = 'paid'
FULL JOIN
	ticket_categories tc ON oi.category_id = tc.id
FULL JOIN
	events e ON tc.event_id = e.id
GROUP BY
	e.id
ORDER BY
	e.id

-- 2.4 --
SELECT
	o.id AS order_id,
	o.status,
	p.id AS payment_id
FROM
	orders o
LEFT JOIN -- LEFT JOIN permet d'afficher les 'o.id' qui n'ont pas de correspondance dans la table 'payments'
	payments p ON o.id = p.order_id
WHERE
	o.status = 'paid' AND p.id IS NULL

-- 2.5 --
SELECT
	o.id,
	o.status,
	p.id
FROM
	orders o
JOIN
	payments p ON o.id = p.order_id
WHERE
	o.status != 'paid'

-- # PARTIE 3

-- 3.1 --
SELECT
	e.title AS event_title,
	SUM(oi.quantity) AS total_tickets_sold,
	SUM(o.total_cents / 100)::MONEY
FROM
	events e
JOIN
	orders o ON o.event_id = e.id AND o.status = 'paid'
JOIN
	order_items oi ON o.id = oi.order_id
GROUP BY
	e.title

-- 3.2 --
SELECT
	e.title AS event_title,
	e.capacity AS event_capacity,
	SUM(oi.quantity) AS total_tickets_sold
FROM
	events e
JOIN
	orders o ON o.event_id = e.id
JOIN
	order_items oi ON oi.order_id = o.id
GROUP BY
	e.id
HAVING
	SUM(oi.quantity) > e.capacity

-- 3.3 --
SELECT
	e.title AS event_title,
	tc.name AS ticket_cat_name,
	SUM(oi.quantity) AS total_tickets_sold_by_cat,
	tc.quota AS ticket_cat_quota
FROM
	events e
JOIN
	ticket_categories tc ON tc.event_id = e.id
JOIN
	order_items oi ON oi.category_id = tc.id
GROUP BY
	e.title,
	tc.name,
	tc.quota
HAVING
	SUM(oi.quantity) > tc.quota

-- 3.4 --
SELECT
	o.id AS order_id,
	SUM(oi.quantity) AS total_tickets_by_order_id
FROM
	orders o
JOIN
	order_items oi ON oi.order_id = o.id
GROUP BY
	o.id
HAVING
	SUM(oi.quantity) > 6

-- 3.5 --
SELECT
	u.full_name AS client,
	SUM(o.total_cents / 100)::MONEY AS total_spent_per_client
FROM
	orders o
JOIN
	users u ON o.user_id = u.id
GROUP BY
	client
ORDER BY
	client DESC
LIMIT
	1

-- # PARTIE 4

-- 4.1 --
SELECT
	u.full_name
FROM
	users u
WHERE u.id NOT IN (
	SELECT
		user_id
	FROM
		orders
)

-- 4.2 --
SELECT
	o.id AS order_id,
	o.status, -- check 'paid' only
	p.id AS payment_id -- devrait être NULL pour chaque ligne
FROM
	orders o
LEFT JOIN -- pour avoir les 'order_id' avec un 'payment_id' NULL
	payments p ON o.id = p.order_id
WHERE 
	o.status = 'paid'
	AND NOT EXISTS (
		SELECT
			1
		FROM
			payments p2
		WHERE
			o.id = p2.order_id -- On cherche l'id d'une order qui N'EXISTE dans aucun payment
	)

-- 4.3 --
SELECT
	tc.name AS ticket_cat,
	(tc.price_cents / 100)::MONEY AS selling_price,
	(oi.unit_price_cents / 100)::MONEY AS sold_price
FROM
	ticket_categories tc
JOIN
	order_items oi ON oi.category_id = tc.id
WHERE
	(tc.price_cents / 100)::MONEY != (oi.unit_price_cents / 100)::MONEY

-- 4.4 --
SELECT
	o.id AS order_id,
	pc.code AS code_used,
	-- o.created_at AS order_creation_date, -- double check manuel
	-- pc.expires_at AS code_expiration, -- double check manuel
	pc.expires_at < o.created_at AS "code expiré à la création de la commande ?",
	-- pc.used_count, -- double check manuel
	-- pc.max_uses, -- double check manuel
	pc.used_count >= pc.max_uses AS "code épuisé à la création de la commande ?" -- Check au cas où
FROM
	orders o
JOIN
	promo_codes pc ON o.promo_code_id = pc.id
WHERE
	pc.expires_at < o.created_at
	OR pc.used_count >= pc.max_uses
	

-- # PARTIE 5

-- 5.1 --
WITH tickets_sum_by_event AS (
	SELECT
		e.id AS event_id,
		e.title AS event_title,
		SUM(oi.quantity) AS total_sold
	FROM
		order_items oi
	JOIN
		orders o ON oi.order_id = o.id
	JOIN
		events e ON o.event_id = e.id
	GROUP BY
		e.id
)
SELECT
	e1.title AS event_title,
	-- ts.total_sold, -- Double check manuel
	-- e1.capacity, -- Double check manuel
	ts.total_sold > e1.capacity AS "Overbooked ?"
FROM
	events e1
JOIN
	tickets_sum_by_event ts ON e1.id = ts.event_id
WHERE
	ts.total_sold > e1.capacity

-- 5.2 --
WITH order_items_totals AS (
	SELECT
		order_id,
		SUM(quantity * (unit_price_cents / 100)::MONEY) AS total_per_order
	FROM
		order_items
	GROUP BY
		order_id
)
SELECT
	o.id AS order_id,
	oit.total_per_order,
	oit.total_per_order - (oit.total_per_order / 100 * pc.percent_off) AS total_after_promo,
	(o.total_cents / 100)::MONEY AS order_price
FROM
	order_items_totals oit
JOIN
	orders o ON o.id = oit.order_id
JOIN
	promo_codes pc ON o.promo_code_id = pc.id
WHERE
	oit.total_per_order - (oit.total_per_order / 100 * pc.percent_off) != (o.total_cents / 100)::MONEY

-- 5.3 --
WITH order_items_details AS (
	SELECT
		oi.id AS order_item_id,
		oi.order_id AS order_id,
		tc.event_id AS event_id
	FROM
		order_items oi
	JOIN 
		ticket_categories tc ON tc.id = oi.category_id
)
SELECT
	o.id AS order_id,
	COUNT(DISTINCT oid.event_id) AS "number of distinct events by order"
FROM
	orders o
JOIN
	order_items_details oid ON o.id = oid.order_id
GROUP BY
	o.id
HAVING
	COUNT(DISTINCT oid.event_id) > 1

-- # PARTIE 6

-- ######
-- 6.1 --
-- 6.1.1 	Selon le client (users.full_name), il y a eu paiement (EXISTS payments.id), mais (AND) la commande n'apparaît pas (orders.status != 'paid').
-- 			Ou l'inverse : (NOT EXISTS payments.id) AND (orders.status = 'paid')
-- 6.1.2 TABLES : users, orders, payments
-- 6.1.3 JOINTS : users.id = orders.user_id, orders.id = payments.order_id (FULL JOIN pour avoir les deux cas)
-- 6.1.4 ANOMALIE : orders.status != 'paid' AND payments.id IS NOT NULL OR orders.status = 'paid' AND payment.id IS NULL
-- 6.1.5 CODE :
SELECT
	o.id AS order_id,
	u.full_name AS client,
	o.status AS order_status,
	p.id AS payment_id
FROM
	orders o
FULL JOIN
	payments p ON p.order_id = o.id
JOIN
	users u ON u.id = o.user_id
WHERE
	o.status = 'paid' AND p.id IS NULL
	OR o.status != 'paid' AND p.id IS NOT NULL
-- 6.1.6 CONCLUSION :	Le statut de la commande dont l'id est 22 n'a pas été mis à jour après le paiement.
--						Le statut de la commande dont l'id est 21 a été mis à jour alors qu'il n'y a pas eu de paiement.

-- ######
-- 6.2 --
-- 6.2.1	Un événement (events.id) est annulé (events.status = 'cancelled') 
--			mais il reste des billets non remboursés (orders.status != 'refund') -- CORRECTION : (orders.status = 'paid') -- si o.status est 'pending' il n'y a pas d'anomalie
-- 6.2.2 TABLES : events, orders
-- 6.2.3 JOINTS : events.id = orders.event_id
-- 6.2.4 ANOMALIE : events.status = 'cancelled' AND orders.status != 'refund'
-- 6.2.5 CODE :
SELECT
	o.id AS order_id,
	e.title AS event_name,
	e.status AS event_status,
	o.status AS order_status
FROM
	orders o
JOIN
	events e ON e.id = o.event_id
WHERE
	-- # CORRECTION :
	-- e.status = 'cancelled' AND o.status != 'paid' ==> si o.status est 'pending' il n'y a pas d'anomalie
	e.status = 'cancelled' AND o.status != 'refund'
-- 6.2.6 CONCLUSION :	

-- ######
-- 6.3 --
-- 6.3.1	Certains clients (users.full_name) ont utilisé un code promo (promo_codes.code) 
--			censé être invalide (expiré ou max utilisations) pour valider une commande (orders.id).
-- 6.3.2 TABLES : users, orders, promo_codes
-- 6.3.3 JOINTS : orders.user_id = users.id, orders.promo_code_id = promo_code.id
-- 6.3.4 ANOMALIE : orders.created_at > promo_codes.expires_at OR orders.promo_code_id IN (used_count > max_uses) 
--		# CORRECTION : Clarification sur pourquoi on utilise 'o.created_at' et pas 'o.expires_at'
-- 6.3.5 CODE :
SELECT
	o.id AS order_id,
	u.full_name AS client,
	pc.code AS promo_code
FROM
	orders o
JOIN
	promo_codes pc ON o.promo_code_id = pc.id
JOIN
	users u ON o.user_id = u.id
WHERE
	pc.code IN (
		-- Codes promos expirés au moment de l'achat ou max_used
		SELECT
			pc2.code
		FROM
			promo_codes pc2
		WHERE
			pc2.used_count >= pc2.max_uses
			OR pc2.expires_at < o.created_at
	)
-- 6.3.6 CONCLUSION : La commande dont l'id est 24 par "Inès Moreau" a bénéficié d'un code promo expiré.

-- ######
-- 6.4 --
-- 6.4.1	Pour un événement (events.title), il y a eu plus de tickets vendus (SUM(order_items.quantity))
--			que de places disponibles (events.capacity).
-- 6.4.2 TABLES : oder_items oi, ticket_categories tc, events e
-- 6.4.3 JOINTS : oi.category_id = tc.id, tc.event_id = e.id
-- 6.4.4 ANOMALIE : SUM(order_items.quantity) > e.capacity
-- 6.4.5 CODE :
SELECT
	e.title AS event_title,
	SUM(oi.quantity) AS tickets_sold,
	e.capacity AS event_capacity
FROM
	events e
-- # CORRECTION : Passer par 'orders' est un choix plus logique et permet de ne prendre que les tickets payés (o.status = 'paid')
-- JOIN
-- 	ticket_categories tc ON tc.id = oi.category_id
-- JOIN
-- 	events e ON tc.event_id = e.id
JOIN
	orders o ON e.id = o.event_id AND o.status ='paid'
JOIN
	order_items oi ON o.id = oi.order_id
GROUP BY
	e.id
HAVING
	SUM(oi.quantity) > e.capacity
-- 6.4.6 CONCLUSION : L'événement "Concert Intimiste (petite salle)" a vendu 11 tickets pour une capacité de 10.

-- ###
-- CORRECTION : Exos pas faits pré-correction. Pas de notes pour favoriser la réflexion en solo.
-- ###

-- ######
-- 6.5 --
-- 6.5.1	Une commande (orders.id) référence plusieurs billets (order_items.id) mais pas pour le même événement (ticket_categories.event_id)
-- 6.5.2 TABLES : orders o, order_items oi, ticket_categories tc
-- 6.5.3 JOINTS : o.id = tc.order_id, oi.category_id = tc.id
-- 6.5.4 ANOMALIE : o.event_id != tc.event_id
-- 6.5.5 CODE :
SELECT
	o.id AS order_id,
	o.event_id AS event_from_order,
	tc.event_id AS event_from_ticket
FROM
	orders o
JOIN
	order_items oi ON oi.order_id = o.id
JOIN
	ticket_categories tc ON tc.id = oi.category_id
WHERE
	o.event_id != tc.event_id
-- 6.5.6 CONCLUSION : La commande dont l'id est 27 références des billets pour deux evénements différents.
-- DOUBLE CHECK avec nom de l'événement : 
SELECT
	oi.order_id AS order_id,
	oi.id AS oi_id,
	e.title AS event_title
FROM
	order_items oi
JOIN
	ticket_categories tc ON tc.id = oi.category_id
JOIN
	events e ON tc.event_id = e.id
WHERE
	oi.order_id = 27

















	


























