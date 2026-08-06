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
	NOW() - pc.expires_at -- On vérifie l'expiration aussi
FROM
	promo_codes pc
WHERE
	pc.code = 'FLASH50'

-- Le code 'FLASH50' est supposé fonctionner. Il reste 7 utilisation, et il n'expire que dans 4j23h06m

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
-- PASS

-- # PARTIE 5

-- 5.1 --
-- PASS

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
-- PASS

-- PARTIE 6

-- 6.1 --
-- 6.1.1 	Selon le client (users.full_name), il y a eu paiement (EXISTS payment.id), mais (AND) la commande n'apparaît pas (orders.status != 'paid').
-- 			Ou l'inverse : (NOT EXISTS payment.id) AND (orders.status = 'paid')
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

-- 6.2 --
-- 6.2.1	Un événement (events.id) est annulé (events.status = 'cancelled') 
--			mais il reste des billets non remboursés (orders.status != 'refund')
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
	e.status = 'cancelled' AND o.status != 'refund'

-- 6.3 --
-- 6.3.1	Certains clients (users.full_name) ont utilisé un code promo (promo_codes.code) 
--			censé être invalide (expiré ou max utilisations) pour valider une commande (orders.id).
-- 6.3.2 TABLES : users, orders, promo_codes
-- 6.3.3 JOINTS : orders.user_id = users.id, orders.promo_code_id = promo_code.id
-- 6.3.4 ANOMALIE : orders.created_at > promo_codes.expires_at OR orders.promo_code_id IN (used_count > max_uses)
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
		SELECT
			pc2.code
		FROM
			promo_codes pc2
		WHERE
			pc2.used_count >= pc2.max_uses
			OR pc2.expires_at < o.created_at
	)

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
	order_items oi
JOIN
	ticket_categories tc ON tc.id = oi.category_id
JOIN
	events e ON tc.event_id = e.id
GROUP BY
	e.id
HAVING
	SUM(oi.quantity) > e.capacity

-- 6.5 --
-- 6.5.1	
















	


























