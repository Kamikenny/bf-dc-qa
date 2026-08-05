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
	o.expires_at,
	o.expires_at - o.created_at AS "Différence de temps"
FROM
	orders o
WHERE
	o.status = 'pending'

-- Il y a 4 commandes 'pending' qui n'ont pas expiré après 10 minutes comme prévu

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
