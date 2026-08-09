# Résultat livrable du TP EventFlow

## Partie 1

**1.1** Combien d'utilisateurs la table `users` contient-elle, par rôle ?

```sql
SELECT
	u.role,
	SUM(u.id) AS "nombre d'users par rôle"
FROM
	users u
GROUP BY
	u.role
```

**1.2** Listez tous les événements dont le statut n'est pas `published`. Combien y en a-t-il, et qu'est-ce que ça implique pour chacun ?

```sql
SELECT
	e.title,
	e.status
FROM 
	events e
WHERE
	e.status != 'published'
```
Le ***Marathon*** est créé mais pas encore publique. Le ***Gala de charité*** a été annulé.

**1.3** Listez toutes les commandes au statut `pending` dont la date d'expiration (`expires_at`) est déjà dépassée. Que devrait-il logiquement se passer pour ces commandes (voir RM2) ?

```sql
SELECT
	o.id,
	o.status,
	o.created_at,
	o.expires_at
FROM
	orders o
WHERE
	o.status = 'pending' AND o.expires_at < NOW()
```
Le statut de ces commandes auraient dû être mis à jour.
Leur date d'expiration est également érronée, la `RM2` stipule qu'une commande est censée expirer après 10 minutes.

**1.4** Listez les codes promo dont la date d'expiration est dans le passé.

```sql
SELECT
	pc.id,
	pc.code,
	pc.expires_at
FROM
	promo_codes pc
WHERE
	pc.expires_at < NOW()
```

**1.5** Un client se plaint de ne pas pouvoir utiliser le code `FLASH50`. Vérifiez son état (`expires_at`, `used_count` vs `max_uses`) et concluez s'il est légitimement utilisable aujourd'hui.

```sql
SELECT
	pc.code,
	pc.used_count,
	pc.max_uses,
	NOW() > pc.expires_at AS "Code expiré ?"
FROM
	promo_codes pc
WHERE
	pc.code = 'FLASH50'
```
Le code promo `FLASH50` est censé fonctionner.

## Partie 2

**2.1** Pour chaque commande au statut `paid`, affichez l'email du client, le statut, et le total — en une seule requête (`orders` + `users`).

```sql
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
```

**2.2** Affichez, pour chaque ligne de commande (`order_items`), le nom de la catégorie et le titre de l'événement associé.

```sql
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
```

**2.3** Pour un événement donné (par son `id`), retrouvez toutes les commandes payées qui lui sont associées — en utilisant `orders.event_id` directement. Comparez avec le résultat obtenu en passant par `order_items` → `ticket_categories` (comme à l'exercice 2.2) : obtenez-vous exactement les mêmes commandes ?

```sql
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
```

Les résultats diffèrent.

```sql
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
```

**2.4** Trouvez toutes les commandes au statut `paid` qui **n'ont aucun paiement associé** dans la table `payments`. (Indice : quel type de `JOIN` permet de faire apparaître les lignes sans correspondance ?)

```sql
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
```

**2.5** À l'inverse, trouvez tous les paiements associés à une commande dont le statut **n'est pas** `paid`.

```sql
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
```

## Partie 3

**3.1** Pour chaque événement, calculez le nombre total de billets vendus (commandes `paid` uniquement) et le chiffre d'affaires généré.

```sql
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
```

**3.2** Pour chaque événement, comparez le nombre de billets vendus à sa capacité (`events.capacity`). Faites ressortir uniquement les événements où la capacité est **dépassée**.

```sql
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
```

**3.3** Faites la même chose, mais au niveau de chaque **catégorie de billets** plutôt qu'au niveau de l'événement entier : une catégorie peut-elle être en sur-vente même si l'événement global ne l'est pas ?

```sql
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
```
**3.4** Identifiez les commandes qui contiennent, à elles seules, plus de six billets au total (RM3).

```sql
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
```

**3.5** Quel est le client ayant généré le plus de chiffre d'affaires (commandes payées) depuis le début ?

```sql
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
```

## Partie 4

**4.1** Avec une sous-requête (`IN` ou `EXISTS`), listez tous les utilisateurs qui n'ont **jamais** passé la moindre commande.

```sql
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
```

**4.2** Avec `NOT EXISTS`, retrouvez les commandes `paid` sans paiement associé — comparez le résultat à celui de l'exercice 2.4. Les deux approches donnent-elles le même résultat ?

```sql
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
```

**4.3** Listez les catégories de billets dont le prix (`ticket_categories.price_cents`) ne correspond pas au prix réellement facturé dans au moins une ligne de commande (`order_items.unit_price_cents`).

```sql
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
```

**4.4** Un code promo a-t-il été appliqué sur une commande **alors qu'il était déjà expiré au moment de la commande** ? (Comparez `orders.created_at` à `promo_codes.expires_at`.)

```sql
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
```

## Partie 5

**5.1** Réécrivez l'exercice 3.2 (capacité dépassée) en utilisant un `WITH` qui calcule d'abord les billets vendus par événement, avant de comparer à la capacité dans une deuxième étape.

```sql
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
```

**5.2** À l'aide d'un CTE, calculez pour chaque commande la somme réelle de ses lignes (`SUM(quantity * unit_price_cents)`), puis comparez cette somme au `orders.total_cents` stocké. Faites ressortir les commandes où les deux valeurs diffèrent.

> **Indice** : si vous obtenez plusieurs résultats et que ça vous surprend, regardez si ces commandes ont un `promo_code_id` renseigné — un total réduit par une remise légitime n'est pas une anomalie.
> Une bonne détection doit intégrer la remise (`percent_off`) dans le calcul du total attendu, pas seulement comparer à la somme brute.

```sql
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
```

**5.3** À l'aide d'un CTE, identifiez les commandes dont les lignes (`order_items`) référencent des catégories appartenant à **plus d'un événement différent**. Est-ce normal qu'une seule commande couvre deux événements ?

```sql
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
```

## Partie 6

**6.1**
> Des clients disent avoir payé, mais leur commande n'apparaît nulle part
   comme payée — ou l'inverse.

**6.1.1**

Selon le client (`users.full_name`), il y a eu paiement (`EXISTS payments.id`), mais (`AND`) la commande n'apparaît pas (`orders.status != 'paid'`). Ou l'inverse : `NOT EXISTS payments.id AND orders.status = 'paid'`

**6.1.2**
- TABLES : *users **u***, *orders **o***, *payments **p***
- JOINTS : `u.id = o.user_id`, `o.id = p.order_id` (**FULL JOIN** pour avoir les deux cas)
- ANOMALIE : `o.status != 'paid' AND pa.id IS NOT NULL OR o.status = 'paid' AND p.id IS NULL`

**6.1.3**
```sql
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
```

**6.1.4**

CONCLUSION :
- Le statut de la commande (**id: 21**) a été mis à jour alors qu'il n'y a pas eu de paiement.
- Le statut de la commande (**id: 22**) n'a pas été mis à jour après le paiement.

---

**6.2**
> Un événement a été annulé, mais on continue à voir des billets vendus dessus.

**6.2.1**

Un événement (`events.id`) est annulé (`events.status = 'cancelled'`) mais il reste des billets non remboursés (`orders.status != 'paid'`)

**6.2.2**
- TABLES : *events **e***, *orders **o***
- JOINTS : `e.id = o.event_id`
- ANOMALIE : `e.status = 'cancelled' AND o.status != 'refund'`

**6.2.3**
```sql
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
	e.status = 'cancelled' AND o.status = 'paid' 
```

**6.2.4**

CONCLUSION : La commande (**id: 23**) n'est pas encore remboursée.

---

**6.3**
> Certains clients semblent avoir bénéficié d'un code promo qui n'aurait plus dû être valide.

**6.3.1**

Certains clients (`users.full_name`) ont utilisé un code promo (`promo_codes.code`) censé être invalide (*expiré* ou *max utilisations*) pour valider une commande (`orders.id`).

**6.3.2**
- TABLES : *users **u***, *orders **o***, *promo_codes **pc***
- JOINTS : `o.user_id = u.id`, `o.promo_code_id = pc.id`
- ANOMALIE : `e.status = 'cancelled' AND o.status != 'refund'`

**6.3.3**
```sql
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
```

**6.3.4**

CONCLUSION : La commande (**id: 24**) a bénéficié d'un code promo (`EXPIRED15`) expiré.

---

**6.4**
>  On soupçonne qu'un ou plusieurs événements ont vendu plus de billets que leur capacité ne le permettait.

**6.4.1**

Pour un événement (`events.title`), il y a eu plus de tickets vendus (`SUM(order_items.quantity)`) que de places disponibles (`events.capacity`).

**6.4.2**
- TABLES : *oder_items **oi***, *ticket_categories **tc***, *events **e***
- JOINTS : `oi.category_id = tc.id`, `tc.event_id = e.id`
- ANOMALIE : `SUM(order_items.quantity) > e.capacity`

**6.4.3**
```sql
SELECT
	e.title AS event_title,
	SUM(oi.quantity) AS tickets_sold,
	e.capacity AS event_capacity
FROM
	events e
JOIN
	orders o ON e.id = o.event_id AND o.status ='paid'
JOIN
	order_items oi ON o.id = oi.order_id
GROUP BY
	e.id
HAVING
	SUM(oi.quantity) > e.capacity
```

**6.4.4**

CONCLUSION : L'événement "*Concert Intimiste (petite salle)*" a vendu **11** tickets pour une capacité de **10**.

---

**6.5**
>  Une commande semble mélanger des billets de deux événements différents —ça ne devrait jamais arriver.

**6.5.1**

Une commande (`orders.id`) référence plusieurs billets (`order_items.id`) mais pas pour le même événement (`ticket_categories.event_id`)

**6.5.2**
- TABLES : *orders **o***, *order_items **oi***, *ticket_categories **tc***
- JOINTS : `o.id = tc.order_id, oi.category_id = tc.id`
- ANOMALIE : `o.event_id != tc.event_id`

**6.5.3**
```sql
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
```

**6.5.4**

CONCLUSION : La commande (**id: 27**) référence des billets pour deux evénements différents.

---

**6.6**
>  Le prix facturé sur certaines lignes de commande ne correspond pas au
   tarif affiché dans le catalogue.

**6.6.1**

Le prix sur certaines lignes de commande (`order_items.unit_price_cents`) ne correspond pas au tarif affiché dans le catalogue (`ticket_categories.price_cents`)

**6.6.2**
- TABLES : *order_items **oi***, *ticket_categories **tc***
- JOINTS : `oi.category_id = tc.id`
- ANOMALIE : `tc.price_cents != oi.unit_price_cents`

**6.6.3**
```sql
SELECT
	oi.id AS order_item_id,
	oi.order_id,
	(tc.price_cents / 100)::MONEY AS displayed_price,
	(oi.unit_price_cents / 100)::MONEY AS sold_price
FROM
	order_items oi
JOIN
	ticket_categories tc ON oi.category_id = tc.id
WHERE
	tc.price_cents != oi.unit_price_cents
```

**6.6.4**

CONCLUSION : La commande (**id: 28**) comporte une erreur de prix pour la ligne de commande (**id: 30**).

---

**6.7**
>  Le total affiché sur certaines commandes ne correspond pas à la somme de leurs lignes.

**6.7.1**

Le total (`orders.total_cents`) de certaines commandes ne correspond pas à la somme de leurs lignes (`SUM(order_items.quantity * order_items.unit_price_cents)`)

**6.7.2**
- TABLES : *orders **o***, *order_items **oi***, *promo_codes **pc***
- JOINTS : `o.id = oi.order_id`, `o.promo_code_id = pc.id`
- ANOMALIE : `orders.total_cents != SUM(order_items.quantity * order_items.unit_price_cents)`
> **Note:** Prendre en compte la possibilité d'une réduction dans le calcul de l'anomalie

**6.7.3**
```sql
SELECT
	o.id AS order_id,
	-- oi.id AS order_item_id, -- Retiré pour obtenir la somme par order_id
	SUM(oi.quantity * oi.unit_price_cents) -- prix supposé de la commande
		- ((SUM(oi.quantity * oi.unit_price_cents) / 100) * COALESCE(pc.percent_off, 0)) -- calcul en cas de promo
		AS supposed_total,
	o.total_cents AS real_total
FROM
	orders o
JOIN
	order_items oi ON oi.order_id = o.id
LEFT JOIN -- LEFT JOIN pour voir les 'o.id' sans promo
	promo_codes pc ON pc.id = o.promo_code_id
GROUP BY
	o.id,
	-- oi.id, -- Retiré pour obtenir la somme par order_id
	pc.percent_off
HAVING
	SUM(oi.quantity * oi.unit_price_cents) 
		- ((SUM(oi.quantity * oi.unit_price_cents) / 100) * COALESCE(pc.percent_off, 0))
	!= o.total_cents
```

**6.7.4**

CONCLUSION : Le total de la commande (**id: 29**) n'a pas été calculé correctement.

---

**6.8**
>  Une commande dépasserait la limite de six billets.

**6.8.1**

Une commande (`orders.id`) dépasserait la limite de 6 billets (`SUM(order_items.quantity)`)

**6.8.2**
- TABLES : *orders **o***, *order_items **oi***
- JOINTS : `o.id = oi.order_id`
- ANOMALIE : `SUM(oi.quantity) > 6`

**6.8.3**
```sql
SELECT
	o.id AS order_id,
	o.status,
	SUM(oi.quantity) AS tickets_qty
FROM
	orders o
JOIN
	order_items oi ON o.id = oi.order_id
GROUP BY
	o.id
HAVING
	SUM(oi.quantity) > 6
```

**6.8.4**

CONCLUSION : La commande (**id: 30**) a permis l'achat de 9 tickets.

---

**6.9**
>  Une catégorie de billets pourrait être en sur-vente même sans que l'événement entier ne le soit.

**6.9.1**

Une catégorie de billets (`ticket_categories.id`) pourrait être en sur-vente (`SUM(order_items.quantity) > ticket_categories.quota`) même sans que l'événement entier ne le soit (`SUM(order_items.quantity) < events.capacity`)

**6.9.2**
- TABLES : *ticket_categories **tc***, *order_items **oi***
- JOINTS : `tc.id = oi.category_id`
- ANOMALIE : `SUM(order_items.quantity) > ticket_categories.quota`

**6.9.3**
```sql
SELECT
	tc.id AS category_id,
	SUM(oi.quantity) AS total_sold,
	tc.quota AS max_available
FROM
	ticket_categories tc
JOIN
	order_items oi ON tc.id = oi.category_id
JOIN
	orders o ON oi.order_id = o.id AND o.status = 'paid' -- 'pending' et 'refund' ne sont pas des anomalies
GROUP BY
	tc.id
HAVING
	SUM(oi.quantity) > tc.quota
```

**6.9.4**

CONCLUSION : Les catégories de billets (**id: 1** et **id: 11**) sont en sur-vente.

---

**6.10**
>  Le montant payé ne correspond pas toujours exactement au total de la commande.

**6.10.1**

Le montant payé (`payments.amount_cents`) ne correspond pas toujours exactement au total de la commande (`orders.total_cents`)

**6.10.2**
- TABLES : *orders **o***, *payments **p***
- JOINTS : `o.id = p.order_id`
- ANOMALIE : `o.total_cents != p.amount_cents`

**6.10.3**
```sql
SELECT
	o.id AS order_id,
	(o.total_cents / 100)::MONEY AS order_total,
	(p.amount_cents / 100)::MONEY AS amount_paid,
	p.id AS payment_id
FROM
	orders o
JOIN
	payments p ON p.order_id = o.id
WHERE
	(o.total_cents / 100)::MONEY != (p.amount_cents / 100)::MONEY
```

**6.10.4**

CONCLUSION : Le montant de la commande (**id: 33**) ne correspond pas au montant du paiement (**id: 27**)

---

**6.11**
>  Un remboursement serait supérieur au paiement d'origine. 

**6.11.1**

Un remboursement (`refunds.amount_cents`) serait supérieur au paiement d'origine (`payments.amount_cents`)

**6.11.2**
- TABLES : *orders **o***, *payments **p***, *refunds **r***
- JOINTS : `o.id = r.order_id`, `o.id = p.order_id`
- ANOMALIE : `r.amount_cents != p.amount_cents`

**6.11.3**
```sql
SELECT
	o.id AS order_id,
	-- o.status, -- *
	p.id AS payment_id,
	(p.amount_cents / 100)::MONEY AS amount_paid,
	(r.amount_cents / 100)::MONEY AS amount_refund,
	r.status, -- Simple check
	r.id AS refund_id
FROM
	orders o
JOIN
	payments p ON o.id = p.order_id
JOIN
	refunds r ON r.order_id = o.id
WHERE
	-- o.status = 'refund' -- *
	(r.amount_cents / 100)::MONEY != (p.amount_cents / 100)::MONEY
	
-- * Le statut des commandes remboursées n'est pas mis à jour (peu importe le montant)

-- DOUBLE CHECK :
SELECT
	o.id,
	o.status
FROM
	orders o
```

**6.11.4**

CONCLUSION : Pour la commande (**id: 34**), le paiement (**id: 28**) et le remboursement (**id: 2**) ne coïncident pas.
> **Note:** Le statut des commandes remboursées n'est pas mis à jour.

---

## Partie 7

**7.1** Créez un nouveau client de test (`INSERT INTO users`). Vérifiez son insertion avec un `SELECT` ciblé sur son email.
```sql
-- Début de transaction
BEGIN;
-- 
INSERT INTO
	users (email, full_name, role, password_hash)
VALUES
	('kenny@mail.mail', 'Kenny Test', 'client', 'abc123')

-- Check
SELECT
	*
FROM
	users
WHERE
	email ILIKE 'kenny%'

-- Fin de transaction
COMMIT;
-- ou
ROLLBACK;
```
> **Résultat :**
> | "id" | "email"           | "password_hash" | "full_name"  | "role"   | "created_at"                 |
> |------|-------------------|-----------------|--------------|----------|------------------------------|
> | 17   | "kenny@mail.mail" | "abc123"        | "Kenny Test" | "client" | "2026-08-09 22:17:45.361071" |

---

**7.2** Créez, pour ce client, une commande `pending` sur un événement de votre choix, avec sa ligne de commande (`orders` + `order_items`). Vérifiez la cohérence avec un `SELECT` joignant les deux tables.
```sql
-- Début de transaction
BEGIN;

-- order en premier (parce que order_items a besoin d'un order.id)
INSERT INTO
	orders (user_id, event_id, status)
VALUES
	(17, 2, 'pending')

-- ensuite order_item
INSERT INTO
	order_items (order_id, category_id, quantity, unit_price_cents)
VALUES
	((
		-- Insertion manuelle compliquée à cause des rollbacks et de l'incrémentation
		SELECT
			id
		FROM
			orders
		WHERE
			user_id = 17 -- mon id. Il n'évolue pas avec les rollbacks.
	), 4, 2, (
		-- Certitude d'obtenir le montant correct
		SELECT
			price_cents
		FROM
			ticket_categories
		WHERE
			id = 4
	))

-- ensuite update du prix de la commande
UPDATE
	orders
SET
	total_cents = (
		SELECT
			oi.quantity * oi.unit_price_cents
		FROM
			order_items oi
		JOIN
			orders o ON o.id = oi.order_id
		WHERE
			o.user_id = 17 -- mon id. Il n'évolue pas avec les rollbacks.
	)

-- CHECK
SELECT
	o.id AS order_id,
	u.full_name AS client,
	e.title AS event_title,
	o.status,
	tc.name AS ticket_category,
	oi.quantity,
	(oi.unit_price_cents / 100)::MONEY AS unit_price,
	(o.total_cents / 100)::MONEY AS total_price
FROM
	orders o
JOIN
	users u ON o.user_id = u.id
JOIN
	events e ON o.event_id = e.id
JOIN
	order_items oi ON oi.order_id = o.id
JOIN
	ticket_categories tc ON tc.id = oi.category_id
WHERE
	u.id = 17 -- mon id. Il n'évolue pas avec les rollbacks.


-- Fin de transaction
COMMIT;
-- ou
ROLLBACK;
```

> **Résultat :**
> | "order_id" | "client"     | "event_title"      | "status"  | "ticket_category" | "quantity" | "unit_price" | "total_price" |
> |------------|--------------|--------------------|-----------|-------------------|------------|--------------|---------------|
> | 40         | "Kenny Test" | "Conférence DevQA" | "pending" | "Standard"        | 2          | "40,00 €"    | "80,00 €"     |

---

**7.3** Faites passer cette commande au statut `paid`, **sans créer de paiement associé** — vous venez de reproduire volontairement une anomalie de type « commande payée sans paiement ». Écrivez ensuite le `SELECT` qui la détecterait dans un audit (il doit fonctionner aussi bien sur votre commande que sur celles de la Partie 6).
```sql
-- Début de transaction
BEGIN;

--
UPDATE
	orders
SET
	status = 'paid'
WHERE
	user_id = 17 -- mon id. bla bla bla

-- Check
SELECT
	o.id AS order_id,
	u.full_name,
	o.status
FROM
	orders o
JOIN
	users u ON u.id = o.user_id
WHERE
	user_id = 17 -- mon id. bla bla bla


-- Fin de transaction
COMMIT;
-- ou
ROLLBACK;
```

> **Résultat de l'update :**
> | "order_id" | "full_name"  | "status" | "status"  | "ticket_category" | "quantity" | "unit_price" | "total_price" |
> |------------|--------------|----------|-----------|-------------------|------------|--------------|---------------|
> | 40         | "Kenny Test" | "paid"   | "pending" | "Standard"        | 2          | "40,00 €"    | "80,00 €"     |


**Détection de l'anomalie :**
```sql
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
```

> **Résultat de la détection:**
> | "order_id" | "client"      | "order_status" | "payment_id" |
> |------------|---------------|----------------|--------------|
> | 22         | "Chloé Petit" | "pending"      | 16           |
> | 40         | "Kenny Test"  | "paid"         | [null]       |
> | 21         | "Yusuf Demir" | "paid"         | [null]       |

---

**7.4** Nettoyez vos données de test (`DELETE`) et vérifiez, avec un `SELECT`, qu'il n'en reste aucune trace.
```sql
-- Début de transaction
BEGIN;

-- On efface d'abord dans order_items car aucune dépendance
DELETE FROM
	order_items
WHERE
	id = (
		-- On cible précisément la bonne ligne (pas en manuel)
		SELECT
			oi.id AS order_item_id
		FROM
			order_items oi
		JOIN
			orders o ON oi.order_id = o.id
		WHERE
			o.user_id = 17
	)

-- On efface ensuite la commande car plus de dépendance
DELETE FROM
	orders
WHERE
	id = (
		-- On cible uniquement la commande liée à mon ID
		SELECT
			id
		FROM
			orders
		WHERE
			user_id = 17
	)

-- Enfin on efface l'user car plus de dépendance
DELETE FROM
	users
WHERE
	id = (
		-- On cible juste mon ID
		SELECT
			id
		FROM
			users
		WHERE
			email = 'kenny@mail.mail'
	)

-- Fin de transaction
COMMIT;
-- ou
ROLLBACK;
```

**Check *users* :**
```sql
SELECT
	id
FROM
	users
WHERE
	email = 'kenny@mail.mail'
```

**Check *orders* :**
```sql
SELECT
	id
FROM
	orders
WHERE
	user_id = 17
```

**Check *order_items* :**
```sql
SELECT
	oi.id AS oi_id
FROM
	order_items oi
JOIN
	orders o ON o.id = oi.order_id AND o.user_id = 17
```

---

## Partie 8

**8.1** Proposez et testez **au moins cinq vérifications supplémentaires** que le Product Owner n'a pas mentionnées dans sa liste (Partie 6) — des risques plausibles compte tenu du schéma, pas forcément des soucis déjà identifiés. Pour chacune, écrivez la requête, exécutez-la, et concluez.

**8.1.1** "Une commande a été remboursée mais le statut de la commande n'a pas été mis à jour."
```sql
SELECT
	o.id AS order_id,
	-- o.status, -- *
	p.id AS payment_id,
	(p.amount_cents / 100)::MONEY AS amount_paid,
	(r.amount_cents / 100)::MONEY AS amount_refund,
	r.status, -- Simple check
	r.id AS refund_id
FROM
	orders o
JOIN
	payments p ON o.id = p.order_id
JOIN
	refunds r ON r.order_id = o.id
WHERE
	-- o.status = 'refund' -- *
	(r.amount_cents / 100)::MONEY != (p.amount_cents / 100)::MONEY
	
-- * Le statut des commandes remboursées n'est pas mis à jour (peu importe le montant)

-- DOUBLE CHECK :
SELECT
	o.id,
	o.status
FROM
	orders o
```

**8.1.2** "Les commandes (`status = 'pending'`) n'expirent pas après 10 minutes."
```sql
SELECT
	id,
	status,
	created_at,
	expires_at,
	expires_at - created_at -- devrait être <= 10 minutes
FROM
	orders
WHERE
	status = 'pending'
	AND created_at + interval '10 minutes' < expires_at
```

**8.2**

| Code | Règle |
|---|---|
| RM8 | Un organisateur doit pouvoir éditer son événement |
| RM9 | Le montant d'un remboursement ne peut jamais excéder le montant de la commande concernée |
