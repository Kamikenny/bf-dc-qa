# TP — Audit SQL de la base EventFlow

**Formation Testeur Logiciel — Bstorm / Bruxelles Formation**

---

## Votre mission

> Vous rejoignez l'équipe QA d'EventFlow.
>
> L'application est déjà en production. Depuis quelques jours, plusieurs
> utilisateurs remontent des problèmes : des billets qui semblent avoir été
> vendus en trop, des paiements qui n'apparaissent nulle part, des clients qui
> réclament un remboursement qu'ils affirment ne jamais avoir demandé.
>
> Votre responsable QA vous donne accès à une copie de la base de données de
> production. Vous n'avez ni le code de l'application, ni accès à l'équipe qui
> l'a développée.
>
> **Votre mission : auditer cette base pour retrouver, documenter et
> comprendre les anomalies.**

Ce n'est pas une situation inventée pour l'exercice : rejoindre un projet déjà
en production, sans en avoir écrit une ligne, est une situation extrêmement
courante pour un testeur QA. La base de données est alors votre seule source
de vérité tangible.

### Ce que vous recevez

- Le schéma de la base (ci-dessous).
- Les règles métier connues d'EventFlow (ci-dessous).
- Un accès à la base déjà peuplée.

---

## 1. Rappel du schéma

```
users ──< orders ──< order_items >── ticket_categories >── events
          orders >── events                (lien direct : orders.event_id)
          orders ──< payments
          orders ──< refunds
          orders >── promo_codes
```

**Point d'attention** : `orders` référence **directement** `events`
(`orders.event_id`), en plus du chemin `order_items → ticket_categories →
events`. Les deux chemins doivent normalement pointer vers le même
événement — un bon réflexe d'audit consiste à vérifier que c'est bien
toujours le cas.

| Table | Rôle |
|---|---|
| `users` | Comptes et rôles (`client`, `organizer`, `admin`) |
| `events` | Événements : titre, ville, date, capacité, statut (`draft`, `published`, `cancelled`) |
| `ticket_categories` | Catégories tarifaires d'un événement (prix, quota) |
| `orders` | Commandes : événement, statut (`pending`, `paid`, `cancelled`, `expired`), total, expiration |
| `order_items` | Lignes de commande : catégorie, quantité, prix unitaire (au plus 6 billets par ligne) |
| `payments` | Un paiement au plus par commande |
| `promo_codes` | Codes promo : réduction, usages, expiration |
| `refunds` | Remboursements, associés directement à une commande |

## 2. Règles métier connues

| Code | Règle |
|---|---|
| RM1 | Le nombre de places vendues sur un événement ne dépasse jamais sa capacité. |
| RM2 | Une réservation non payée expire après 10 minutes et libère le stock. |
| RM3 | Une commande contient au maximum six billets. |
| RM4 | Un code promo a un nombre d'usages maximum et une date d'expiration ; au-delà, il ne doit plus pouvoir être appliqué. |
| RM7 | Un client ne peut consulter que ses propres commandes et billets. |

**Piège à connaître** : la base a un `CHECK` qui limite chaque **ligne** de
commande (`order_items.quantity`) à six billets maximum. Ce n'est pas la même
chose que RM3, qui limite le total d'une **commande entière** — une commande
peut très bien contenir deux lignes de six billets chacune, soit douze au
total, sans qu'aucune contrainte de la base ne s'y oppose. Gardez cette
nuance en tête pour la Partie 6.

D'autres règles, non formalisées nulle part, sont implicites au bon
fonctionnement du système — par exemple : *une commande payée doit avoir un
paiement associé*, ou *un événement annulé ne devrait plus générer de
commandes payées*. Une partie de votre travail consiste justement à les
retrouver.

## 3. Méthode

Pour chaque anomalie potentielle, réutilisez la méthode vue ce matin :

1. Lire (ou formuler) la règle métier.
2. Identifier les tables concernées.
3. Identifier les `JOIN` nécessaires.
4. Déterminer la condition SQL qui décrit une ligne **en faute**.
5. Écrire une requête qui ne retourne **que** les anomalies.

## 4. Livrable attendu

Un fichier (`.sql` ou `.md`, à votre convenance) contenant, pour chaque
exercice :

- la requête SQL utilisée,
- le résultat obtenu (nombre de lignes, ou capture),
- une phrase expliquant ce que le résultat signifie pour un utilisateur ou
  pour EventFlow.

Une anomalie sans explication n'a pas de valeur pour votre responsable — il
doit pouvoir agir dessus sans relire votre requête.

---

# PARTIE 1 — Vérifications simples

*Objectif : se réapproprier la base avec des requêtes simples avant de
complexifier.*

**1.1** Combien d'utilisateurs la table `users` contient-elle, par rôle ?

**1.2** Listez tous les événements dont le statut n'est pas `published`.
Combien y en a-t-il, et qu'est-ce que ça implique pour chacun ?

**1.3** Listez toutes les commandes au statut `pending` dont la date
d'expiration (`expires_at`) est déjà dépassée. Que devrait-il logiquement se
passer pour ces commandes (voir RM2) ?

**1.4** Listez les codes promo dont la date d'expiration est dans le passé.

**1.5** Un client se plaint de ne pas pouvoir utiliser le code `FLASH50`.
Vérifiez son état (`expires_at`, `used_count` vs `max_uses`) et concluez
s'il est légitimement utilisable aujourd'hui.

---

# PARTIE 2 — Jointures

*Objectif : relier les tables pour répondre à des questions qu'une seule
table ne peut pas résoudre.*

**2.1** Pour chaque commande au statut `paid`, affichez l'email du client, le
statut, et le total — en une seule requête (`orders` + `users`).

**2.2** Affichez, pour chaque ligne de commande (`order_items`), le nom de la
catégorie et le titre de l'événement associé.

**2.3** Pour un événement donné (par son `id`), retrouvez toutes les
commandes payées qui lui sont associées — en utilisant `orders.event_id`
directement. Comparez avec le résultat obtenu en passant par `order_items` →
`ticket_categories` (comme à l'exercice 2.2) : obtenez-vous exactement les
mêmes commandes ?

> **Remarque** : rien dans le schéma ne relie un organisateur
> (`users.role = 'organizer'`) à ses propres événements — il n'y a pas de
> colonne de type `organizer_id` sur `events`. Un organisateur ne peut donc
> pas, avec ce schéma seul, retrouver « ses » événements par une requête SQL.
> Gardez cette observation pour la Partie 8.

**2.4** Trouvez toutes les commandes au statut `paid` qui **n'ont aucun
paiement associé** dans la table `payments`. (Indice : quel type de `JOIN`
permet de faire apparaître les lignes sans correspondance ?)

**2.5** À l'inverse, trouvez tous les paiements associés à une commande dont
le statut **n'est pas** `paid`.

---

# PARTIE 3 — GROUP BY / HAVING

*Objectif : raisonner sur des ensembles de lignes, pas ligne par ligne.*

**3.1** Pour chaque événement, calculez le nombre total de billets vendus
(commandes `paid` uniquement) et le chiffre d'affaires généré.

**3.2** Pour chaque événement, comparez le nombre de billets vendus à sa
capacité (`events.capacity`). Faites ressortir uniquement les événements où
la capacité est **dépassée**.

**3.3** Faites la même chose, mais au niveau de chaque **catégorie de
billets** plutôt qu'au niveau de l'événement entier : une catégorie
peut-elle être en sur-vente même si l'événement global ne l'est pas ?

**3.4** Identifiez les commandes qui contiennent, à elles seules, plus de six
billets au total (RM3).

**3.5** Quel est le client ayant généré le plus de chiffre d'affaires
(commandes payées) depuis le début ?

---

# PARTIE 4 — Sous-requêtes

*Objectif : filtrer une table à partir du résultat d'une autre requête.*

**4.1** Avec une sous-requête (`IN` ou `EXISTS`), listez tous les
utilisateurs qui n'ont **jamais** passé la moindre commande.

**4.2** Avec `NOT EXISTS`, retrouvez les commandes `paid` sans paiement
associé — comparez le résultat à celui de l'exercice 2.4. Les deux approches
donnent-elles le même résultat ?

**4.3** Listez les catégories de billets dont le prix (`ticket_categories.price_cents`)
ne correspond pas au prix réellement facturé dans au moins une ligne de
commande (`order_items.unit_price_cents`).

**4.4** Un code promo a-t-il été appliqué sur une commande **alors qu'il
était déjà expiré au moment de la commande** ? (Comparez `orders.created_at`
à `promo_codes.expires_at`.)

---

# PARTIE 5 — CTE (Common Table Expressions)

*Objectif : découper un raisonnement complexe en étapes nommées et
lisibles.*

**5.1** Réécrivez l'exercice 3.2 (capacité dépassée) en utilisant un `WITH`
qui calcule d'abord les billets vendus par événement, avant de comparer à la
capacité dans une deuxième étape.

**5.2** À l'aide d'un CTE, calculez pour chaque commande la somme réelle de
ses lignes (`SUM(quantity * unit_price_cents)`), puis comparez cette somme au
`orders.total_cents` stocké. Faites ressortir les commandes où les deux
valeurs diffèrent.

> **Indice** : si vous obtenez plusieurs résultats et que ça vous surprend,
> regardez si ces commandes ont un `promo_code_id` renseigné — un total
> réduit par une remise légitime n'est pas une anomalie. Une bonne détection
> doit intégrer la remise (`percent_off`) dans le calcul du total attendu,
> pas seulement comparer à la somme brute.

**5.3** À l'aide d'un CTE, identifiez les commandes dont les lignes
(`order_items`) référencent des catégories appartenant à **plus d'un
événement différent**. Est-ce normal qu'une seule commande couvre deux
événements ?

---

# PARTIE 6 — Audit complet

*C'est ici que tout se rejoint. Le Product Owner d'EventFlow vous a
transmis une liste de familles de problèmes remontés par les utilisateurs
ces derniers jours. À vous de les retrouver précisément, avec la méthode en
5 étapes, et de documenter chaque cas trouvé (commande(s) concernée(s),
requête utilisée, explication).*

Consignes du Product Owner (reformulées) :

1. « Des clients disent avoir payé, mais leur commande n'apparaît nulle part
   comme payée — ou l'inverse. »
2. « Un événement a été annulé, mais on continue à voir des billets vendus
   dessus. »
3. « Certains clients semblent avoir bénéficié d'un code promo qui n'aurait
   plus dû être valide. »
4. « On soupçonne qu'un ou plusieurs événements ont vendu plus de billets
   que leur capacité ne le permettait. »
5. « Une commande semble mélanger des billets de deux événements différents
   — ça ne devrait jamais arriver. »
6. « Le prix facturé sur certaines lignes de commande ne correspond pas au
   tarif affiché dans le catalogue. »
7. « Le total affiché sur certaines commandes ne correspond pas à la somme
   de leurs lignes. »
8. « Une commande dépasserait la limite de six billets. »
9. « Une catégorie de billets pourrait être en sur-vente même sans que
   l'événement entier ne le soit. »
10. « Le montant payé ne correspond pas toujours exactement au total de la
    commande. »
11. « Un remboursement serait supérieur au paiement d'origine. »

**Pour chacun des 11 points**, écrivez la requête qui permet de le confirmer
ou de l'infirmer sur la base actuelle, et indiquez précisément les
commandes (ou catégories, ou paiements) concernées.

**Attention à la sur-détection** : toutes les commandes en attente
(`pending`), annulées (`cancelled`) ou expirées (`expired`) sans paiement ne
sont **pas** des anomalies — c'est un état normal. Une commande payée puis
intégralement remboursée n'est pas non plus, en soi, une anomalie. Pour le
point 7, une comparaison naïve entre le total et la somme brute des lignes
va aussi faire ressortir toutes les commandes avec un code promo légitime
(le total réduit n'a rien d'anormal) — regardez si `promo_code_id` est
renseigné avant de conclure. Pour le point 9, il est normal que votre
requête sur le point 4 (capacité d'un événement) et votre requête sur le
point 9 (quota d'une catégorie) se recoupent sur un événement qui n'a
qu'une seule catégorie de billets — les deux limites y coïncident. Un bon
audit distingue les vrais signaux du bruit.

---

# PARTIE 7 — DML : préparer, provoquer, détecter

*Objectif : boucler la boucle avec la Partie 1 du support de cours —
utiliser INSERT, UPDATE, DELETE intelligemment, jamais à l'aveugle.*

**7.1** Créez un nouveau client de test (`INSERT INTO users`). Vérifiez son
insertion avec un `SELECT` ciblé sur son email.

**7.2** Créez, pour ce client, une commande `pending` sur un événement de
votre choix, avec sa ligne de commande (`orders` + `order_items`). Vérifiez
la cohérence avec un `SELECT` joignant les deux tables.

**7.3** Faites passer cette commande au statut `paid`, **sans créer de
paiement associé** — vous venez de reproduire volontairement une anomalie de
type « commande payée sans paiement ». Écrivez ensuite le `SELECT` qui la
détecterait dans un audit (il doit fonctionner aussi bien sur votre commande
que sur celles de la Partie 6).

**7.4** Nettoyez vos données de test (`DELETE`) et vérifiez, avec un
`SELECT`, qu'il n'en reste aucune trace.

---

# PARTIE 8 — Aller plus loin : penser comme un QA

*Ces questions n'ont pas de requête SQL unique à produire — elles demandent
votre jugement. Répondez par écrit, en argumentant.*

**8.1** Proposez et testez **au moins cinq vérifications supplémentaires**
que le Product Owner n'a pas mentionnées dans sa liste (Partie 6) — des
risques plausibles compte tenu du schéma, pas forcément des soucis déjà
identifiés. Pour chacune, écrivez la requête, exécutez-la, et concluez.

> **Important** : un audit qui ne trouve rien n'est pas un audit raté. Si
> une de vos requêtes ne remonte aucune ligne, c'est un résultat légitime à
> documenter (« vérifié, aucune anomalie de ce type actuellement ») — ce
> n'est pas un échec, et ce n'est pas signe que vous avez mal écrit votre
> requête. Quelques pistes pour démarrer : les remboursements portent-ils
> toujours sur une commande effectivement payée ? Un compte `organizer` ou
> `admin` a-t-il jamais passé une commande ? Le nombre d'usages d'un code
> promo (`used_count`) dépasse-t-il jamais son maximum (`max_uses`) ?

**8.2** Proposez au moins **trois nouvelles règles métier** qu'EventFlow
gagnerait à formaliser, en vous basant sur ce que vous avez observé pendant
l'audit.

**8.3** Pour chacune des anomalies trouvées dans ce TP, demandez-vous :
*cette anomalie aurait-elle pu être empêchée par une contrainte SQL
(`CHECK`, `UNIQUE`, `FOREIGN KEY`) ?* Si oui, proposez la contrainte
exacte. Si non, expliquez pourquoi elle doit rester du ressort de
l'application plutôt que de la base.

**8.4** À l'inverse : certaines règles sont aujourd'hui uniquement portées
par l'application. Lesquelles, parmi celles observées, devraient à votre
avis **rester** du ressort de l'application plutôt que d'être poussées dans
la base — et pourquoi ?

**8.5** Si vous deviez écrire **une seule requête** que l'équipe
d'EventFlow pourrait exécuter chaque nuit pour surveiller la santé de la
base en continu, à quoi ressemblerait-elle ?

---

*Fin du TP. Gardez une trace claire de chaque requête et de chaque
conclusion : c'est ce document qui constitue votre rapport d'audit — le
même type de livrable qu'un vrai testeur QA remettrait à son équipe.*
