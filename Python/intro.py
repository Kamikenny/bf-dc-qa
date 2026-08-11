# Trouvez un moyen d'inverser les valeurs de a et b sans utiliser l'affectation multiple (a, b = b, a)
""" a:int = 5
b:int = 7
print(f"a = {a} -- b = {b}")
c:int = a
a = b
b = c
print(f"a = {a} -- b = {b}")
 """

### ### ###

# Interactions console()
# 1. Demandez à l'utilisateur son prénom et son nom, puis affichez-les avec un séparateur personnalisé.
""" prenom:str = input("Quel est ton prénom ? : ")
nom:str = input("Quel est ton nom ? : ")
print(prenom, nom, sep = "--") """

# 2. Affichez un message sur plusieurs lignes avec une fin de ligne personnalisée pour chaque ligne.
""" print("Bonjour", end = "!")
print("Bonjour", end = "!!")
print("Bonjour", end = "!!!") """

# 3. Demandez à l'utilisateur deux mots et affichez-les sur la même ligne, sans espace entre eux.
""" mot1:str = input("Entrez un mot : ")
mot2:str = input("Entrez un mot : ")
print(mot1, mot2, sep = "") """

# 4. Demandez à l'utilisateur deux nombres et affichez leur somme avec une fin de ligne personnalisée.
""" x:int = int(input('Veuillez entrer un chiffre : '))
y:int = int(input('Veuillez entrer un chiffre : '))
print(f"la somme de vos deux chiffres = {x + y}.", end = "\nGG!") """

# 5. Affichez trois valeurs avec un séparateur personnalisé et une fin de ligne personnalisée.
""" x:int = 1
y:int = 2
z:int = 3
print(x, y, z, sep = " + ", end = f" = {x + y + z}") """

### ### ###

# 1. Devinez les résultats des calculs sur les valeurs des variables A, B, C, D, E, F et G à partir des expressions suivantes :
# 1. A = 12

# 2. B = 3 * A + 8 
"44"

# 3. C = B - 2 * A
"20"

# 4. D = (C + 25) * B
"1980"

# 5. E = (A + B) % 10
"6"

# 6. F = (C * D) // (B + 6)
"792"

# 7. G = (D + E) // (F - 9)
"2"


# 2. Utilisez Python pour vérifier vos réponses et afficher les valeurs.
# a = 12
# print(a)

# b = 3 * a + 8
# print(b)

# c = b - 2 * a
# print(c)

# d = (c + 25) * b
# print(d)

# e = (a + b) % 1
# print(e)

# f = (c * d) // (b + 6)
# print(f)

# g = (d + e) // (f - 9)
# print(g)

# 3. Considérons : A = 13 / B = 5 / C = True / D = not(C). Donnez le résultat pour chacune de ces instructions :
# ▪ A > 10) and (B < 20)
"True"
# ▪ (C != 40) or (D >= 100)
"True"
# ▪ (A == 2) and (not (B > 15))
"False"
# ▪ (C > 50) or (not (D < 200))
"False"
# ▪ ((A < B) and (C > 30)) or (D == 270)
"False"
# ▪ not ((A * B) > 100)
"True"
# ▪ ((B == 15) or ((C > 60) and (A < 5)))
"False"
# ▪ (((B == 15) or ((C > 60) and (A < 5))) and (A < B)) or (not (B == 9))
"True"

# 4. Imaginez et réalisez une méthode manuelle permettant d'inverser le contenu d'une variable entière sans utiliser de variable temporaire.
# 1
""" a, b = 5, 6
print(a, b)
a = [a, b]
b = a[0]
a = a[1]
print(a, b)
 """

# 2
""" a += b      # 5 => 5 + 7 => 12
b = a - b   # 7 => 12 - 7 => 5
a -= b      # 12 => 12 - 5 => 7 """

# 5. Écrivez un programme Python convertissant un nombre de secondes en jours, heures, minutes et seconds correspondants. Exemple : 4561 secondes correspondent à 0 jour, 1 heure, 16 minutes et 1 seconde. Réfléchissez à la méthode à utiliser, puis réalisez l'algorithme en Python. Testez-le ensuite pour vérifier sa validité.
""" input_seconds = int(input("Entrer un nombre de secondes : "))

total_jours = input_seconds / 60 / 60 / 24
jours_affiches = int(total_jours // 1)
# print(total_jours, jours_affiches)

total_heures  = (input_seconds / 60 / 60)
heures_affichees = int((total_heures // 1 ) - ((total_jours // 1) * 24))
# print(total_heures, heures_affichees)

total_minutes = (input_seconds / 60)
minutes_affichees = int((total_minutes // 1) - ((total_heures // 1) * 60))
# print(total_minutes, minutes_affichees)

total_secondes = input_seconds
secondes_affichees = int((total_secondes // 1) - ((total_minutes // 1) * 60))
# print(total_secondes, secondes_affichees)

print(f"{input_seconds} secondes correspondent à : {jours_affiches} jours, {heures_affichees} heures, {minutes_affichees} minutes et {secondes_affichees} secondes.")
 """

# CORRECTION
""" seconds = int(input("donne les secondes : "))

days = seconds // (60 * 60 * 24)
seconds %= (60 * 60 * 24)

hours = seconds // (60 * 60)
seconds %= (60 * 60)

minutes = seconds // 60
seconds %= 60

print(f"{days}j {hours}h {minutes}m {seconds}s")
 """

### ### ###

# 1. Créez un programme qui gère les commandes de café en fonction des différentes options telles que la taille, le type de café, les extras, etc. Utilisez des correspondances pour traiter chaque option et calculer le prix total de la commande.
""" coffee_order = {
    "size": 0,
    "type": 0,
    "sugar_qty": 0,
    "milk_qty": 0,
    "price": 0.0
}

print("Bienvenue")
while coffee_order["size"] not in (1, 2, 3):
    coffee_order["size"] = int(input(
        "Quelle taille pour le café ? (Entrez juste le chiffre)\n" +
        "1. Petit\n" +
        "2. Moyen\n" +
        "3. Grand\n"
    ))
coffee_order["price"] += coffee_order["size"] * 1

while coffee_order["type"] not in (1, 2, 3):
    coffee_order["type"] = int(input(
        "Quelle type de café ? (Entrez juste le chiffre)\n" +
        "1. Pas bon\n" +
        "2. Bon\n" +
        "3. Très bon\n"
    ))
coffee_order["price"] += coffee_order["type"] * 1

while coffee_order["sugar_qty"] not in (1, 2, 3, 4):
    coffee_order["sugar_qty"] = int(input(
        "Quelle quantité de sucre ? (Entrez juste le chiffre)\n" +
        "1. Pas du tout\n" +
        "2. Un peu\n" +
        "3. Beaucoup\n" +
        "4. Trop\n"
    ))
coffee_order["price"] += (coffee_order["sugar_qty"] - 1) * 0.1

while coffee_order["milk_qty"] not in (1, 2, 3, 4):
    coffee_order["milk_qty"] = int(input(
        "Quelle quantité de lait ? (Entrez juste le chiffre)\n" +
        "1. Pas du tout\n" +
        "2. Un peu\n" +
        "3. Beaucoup\n" +
        "4. Trop\n"
    ))
coffee_order["price"] += (coffee_order["milk_qty"] - 1) * 0.1

print("Merci")
print(f"Votre café coûte : {coffee_order['price']} €") """

# 2. Créez un programme qui convertit une note numérique en une note alphabétique en utilisant une échelle de notation standard. Utilisez des correspondances pour déterminer la note alphabétique correspondante en fonction de la note numérique.
""" score = -1
letter = ""
while score < 0 or score > 100:
    score = int(input("Quel est le score de l'élève ? (/100) : "))

if score < 60:
    letter = "F"
elif score < 70:
    letter = "D"
elif score < 80:
    letter = "C"
elif score < 90:
    letter = "B"
else:
    letter = "A"

print(f"La note de l'élève ({score}/100) se traduit par un : {letter}.") """

# 3. Créez un programme qui génère un nombre aléatoire (import random) et permet à l'utilisateur de deviner ce nombre. Utilisez des correspondances pour comparer la devinette de l'utilisateur avec le nombre généré et fournir des indices
""" import random

mystery: int = random.randint(1, 10)
guess: int = 0

while guess != mystery:
    guess = int(input("Essaie de deviner le nombre mystère : "))

    if guess < mystery:
        print(f"DOMMAGE ! Le nombre mystère est plus grand que {guess}.")
    elif guess > mystery:
        print(f"DOMMAGE ! le nombre mystère est plus petit que {guess}.")
    else:
        print(f"FELICITATIONS !!! Le nombre mystère était bien {mystery} !") """

# 4. Créez un programme qui calcule l'indice de masse corporelle (IMC) d'une personne en fonction de son poids et de sa taille. Utilisez des correspondances pour interpréter et catégoriser l'IMC résultant en différentes catégories de poids.

""" print("Je vais calculer votre IMC.")

weight: float = float(input("Quel est votre poids ? (en kg) : "))
height_cm: int = int(input("Quelle est votre taille ? (en cm) : "))
height_m: float = height_cm / 100

imc: float = weight / (height_m ** 2)

if imc < 18.5:
    print(f"Votre IMC est {imc:.2f}. Vous êtes en état de 'Sous-poids'.")
elif imc < 25:
    print(f"Votre IMC est {imc:.2f}. Vous êtes en état de 'Poids sain'.")
elif imc < 30:
    print(f"Votre IMC est {imc:.2f}. Vous êtes en état de 'Surpoids'.")
else:
    print(f"Votre IMC est {imc:.2f}. Vous êtes en état de 'Obésité'.") """

# 5. Créez un programme qui permet à l'utilisateur de choisir un menu pour chaque repas (petit-déjeuner, déjeuner, dîner) parmi des options préétablies. Après la sélection, il affiche les choix de l'utilisateur pour chaque repas et résume l'ensemble des repas de la journée.

""" daily_meals = {
    "breakfast" : "",
    "lunch" : "",
    "dinner" : ""
}

breakfasts = {
    "1" : "Couques",
    "2" : "Eggs & Bacon",
    "3" : "Bread & Butter"
}

lunches = {
    "1" : "Bread & Ham",
    "2" : "Eggs & Bacon",
    "3" : "Pasta"
}

dinners = {
    "1" : "Thai Curry",
    "2" : "Steak, Chips & Marmelade",
    "3" : "Chicken Burger"
}

print("Bienvenue")

input_choice: str = ""
while input_choice not in ("1", "2", "3"):
    print("Quel petit-déjeuner voulez-vous ?")
    for b in breakfasts:
        print(f"{b}. {breakfasts[b]}")
    input_choice = input("Entrez juste le chiffre : ")
daily_meals["breakfast"] = breakfasts[input_choice]
input_choice = ""

while input_choice not in ("1", "2", "3"):
    print("Quel déjeuner voulez-vous ?")
    for l in lunches:
        print(f"{l}. {lunches[l]}")
    input_choice = input("Entrez juste le chiffre : ")
daily_meals["lunch"] = lunches[input_choice]
input_choice = ""

while input_choice not in ("1", "2", "3"):
    print("Quel dîner voulez-vous ?")
    for d in dinners:
        print(f"{d}. {dinners[d]}")
    input_choice = input("Entrez juste le chiffre : ")
daily_meals["dinner"] = dinners[input_choice]

print("Voici votre sélection du jour : ")
for m in daily_meals:
    print(f"{m} : {daily_meals[m]}")
print("Bonne journée !") """

# 6. Créez un programme qui génère des citations aléatoires à partir d'un nombre aléatoire. L'utilisateur devrait pouvoir choisir un thème et le programme générera une citation aléatoire correspondante. Utilisez des correspondances pour gérer les différents thèmes et générer les citations appropriées

""" quotes = {
    "theme_1" : ["theme_1_quote_1", "theme_1_quote_2", "theme_1_quote_3"],
    "theme_2" : ["theme_2_quote_1", "theme_2_quote_2", "theme_2_quote_3"],
    "theme_3" : ["theme_3_quote_1", "theme_3_quote_2", "theme_3_quote_3"]
}

themes_list = list(quotes.keys())

print("Bonjour, quel thème pour votre citation ? ")
for i in range(len(themes_list)):
    print(f"{i + 1}. {themes_list[i]}")
chosen_theme = themes_list[int(input("Entrez juste le chiffre : ")) - 1]

print(quotes[chosen_theme][random.randint(0, len(quotes[chosen_theme]))]) """

######

# 1. Concevez un programme qui génère et affiche les nombres premiers jusqu'à 100 en utilisant une boucle.

""" prime_numbers: set = {2}
for i in range(3, 1010):
    for n in range(2, i + 1):
        # print(f"{i} % {n} = {i % n}")
        if n == i:
            prime_numbers.add(i)
        elif i % n == 0:
            break
print(prime_numbers) """


###



# 2. Créez un programme qui demande à l'utilisateur d'entrer son âge. Utilisez un opérateur ternaire pour vérifier si l'utilisateur est majeur ou mineur. Affichez ensuite un message approprié en fonction de la réponse.

""" age = int(input("donne ton age : "))
result = "Tu es majeur" if age >= 18 else "Tu es mineur"
print(result) """

# 3. Jeu de devinette de nombre amélioré : Écrivez un jeu interactif où l'ordinateur génère un nombre aléatoire entre 1 et 100, et l'utilisateur doit deviner ce nombre. 
# Utilisez une boucle pour permettre à l'utilisateur de faire plusieurs tentatives. 
# Après chaque tentative, demandez à l'utilisateur s'il souhaite continuer à jouer. 
# Répétez le processus jusqu'à ce qu'il décide de ne plus jouer. 
# Enfin, affichez le nombre de tentatives utilisées pour deviner le nombre.

""" import random

mystery: int = random.randint(1, 100)
guess: int = 0
tries = 0

while guess != mystery:
    guess = int(input("Essaie de deviner le nombre mystère : "))
    tries += 1

    if guess < mystery:
        print(f"DOMMAGE ! Le nombre mystère est plus grand que {guess}.")
    elif guess > mystery:
        print(f"DOMMAGE ! le nombre mystère est plus petit que {guess}.")
    else:
        print(f"FELICITATIONS !!! Le nombre mystère était bien {mystery} !\n"
              + f"Vous avez trouvé en {tries} essais !")
        again = input("Recommencer ? Oui / Non\n")
        if again == "Non":
            break
        elif again == "Oui":
            mystery: int = random.randint(1, 100)
            guess = 0
            tries = 0
            continue """

# 4. Écrivez un programme qui demande à l'utilisateur d'entrer un mot. Utilisez une boucle pour afficher chaque caractère du mot un par un jusqu'à la fin du mot.

""" word = input("Entre un mot : ")

print("Voici les lettres du mot : ")
for letter in word:
    print(letter) """

# 1'. Gestionnaire de commandes de café amélioré :
# Écrivez un programme interactif qui prend les commandes de café en fonction des options telles que la taille, le type de café et les extras. 
# Utilisez une boucle pour permettre à l'utilisateur de passer plusieurs commandes et affichez le prix total à la fin de chaque commande. 
# Demandez ensuite à l'utilisateur s'il souhaite passer une autre commande et répétez le processus jusqu'à ce qu'il n'en ait plus envie.

""" orders_list: list[dict[str, int|float]] = []
coffee_order_template = {
    "size": 0,
    "type": 0,
    "sugar_qty": 0,
    "milk_qty": 0,
    "price": 0.0
}

ordering: bool = True

print("Bienvenue")
while ordering:
    while coffee_order_template["size"] not in (1, 2, 3):
        coffee_order_template["size"] = int(input(
            "Quelle taille pour le café ? (Entrez juste le chiffre)\n" +
            "1. Petit\n" +
            "2. Moyen\n" +
            "3. Grand\n"
        ))
    coffee_order_template["price"] += coffee_order_template["size"] * 1

    while coffee_order_template["type"] not in (1, 2, 3):
        coffee_order_template["type"] = int(input(
            "Quelle type de café ? (Entrez juste le chiffre)\n" +
            "1. Pas bon\n" +
            "2. Bon\n" +
            "3. Très bon\n"
        ))
    coffee_order_template["price"] += coffee_order_template["type"] * 1

    while coffee_order_template["sugar_qty"] not in (1, 2, 3, 4):
        coffee_order_template["sugar_qty"] = int(input(
            "Quelle quantité de sucre ? (Entrez juste le chiffre)\n" +
            "1. Pas du tout\n" +
            "2. Un peu\n" +
            "3. Beaucoup\n" +
            "4. Trop\n"
        ))
    coffee_order_template["price"] += (coffee_order_template["sugar_qty"] - 1) * 0.1

    while coffee_order_template["milk_qty"] not in (1, 2, 3, 4):
        coffee_order_template["milk_qty"] = int(input(
            "Quelle quantité de lait ? (Entrez juste le chiffre)\n" +
            "1. Pas du tout\n" +
            "2. Un peu\n" +
            "3. Beaucoup\n" +
            "4. Trop\n"
        ))
    coffee_order_template["price"] += (coffee_order_template["milk_qty"] - 1) * 0.1

    print("Merci")
    
    orders_list.append(coffee_order_template.copy())
    coffee_order_template = {
        "size": 0,
        "type": 0,
        "sugar_qty": 0,
        "milk_qty": 0,
        "price": 0.0
    }

    continue_ordering: str = ""
    while continue_ordering != 'Non' and continue_ordering != 'Oui':
        continue_ordering = input("Voulez-vous commander un autre café ? : (Oui / Non) \n")
    if continue_ordering == 'Non':
        ordering = False
    else:
        continue
    
total_price = 0
for order in orders_list:
    total_price += order["price"]

print(f"Votre commande coûte : {total_price} €") """


# 2'. Écrivez un programme qui demande à l'utilisateur d'entrer un mot. 
# Utilisez une boucle pour inverser l'ordre des lettres du mot et affichez le mot inversé à la fin.

""" word = input("donne un mot : ")
new_word = ""

for letter in word:
    new_word = letter + new_word
print(new_word) """


# 3'. Gestion des repas du jour améliorée :
# Développez un programme interactif qui permet à l'utilisateur de choisir un menu pour chaque repas de la journée parmi des options prédéfinies.
# Utilisez une boucle pour faciliter la saisie des choix pour chaque repas et affichez un résumé des choix de repas à la fin.
# Demandez ensuite à l'utilisateur s'il souhaite choisir les repas pour un autre jour.
# Répétez le processus jusqu'à ce qu'il décide de ne plus choisir de repas.

# Code de Raphaël ( à étudier) :
""" sizes = {"S": 1.0, "M": 1.5, "L": 2.0}
coffees = {"Espresso": 0.5, "Americano": 1.0, "Latte": 1.5}

print("Welcome to the Coffee Machine")

while True:
    # 1. Take the order (Inputs are formatted automatically)
    s = input(f"\nSize {list(sizes.keys())} : ").upper()
    c = input(f"Type {list(coffees.keys())} : ").capitalize()
    e = input("Extras (Sugar / Milk / None) : ").capitalize()

    # 2. Calculate total price using dictionary lookups
    # .get(key, default) prevents crashes if the user makes a typo
    size_price = sizes.get(s, 2.0)  # Defaults to L if error
    coffee_price = coffees.get(c, 1.5)  # Defaults to Latte if error
    extra_price = (0.1 if "Sugar" in e else 0) + (0.1 if "Milk" in e else 0)

    total = size_price + coffee_price + extra_price
    print(f"-> Total price : ${total:.2f}")

    # 3. Ask to continue or quit
    if input("\nAnother coffee? (y/n) : ").lower() == "n":
        print("Thank you, goodbye!")
        break """

# Exercice bonus - PGCD (Plus Grand Commun Diviseur)
# Écrivez un programme qui demande à l'utilisateur de saisir deux nombres entiers a et b,
# puis calcule et affiche leur PGCD (le plus grand nombre qui divise à la fois a et b), en utilisant une boucle while.

""" a = int(input("a = "))
b = int(input("b = "))
pgcd = 1
diviseur = 1
min = a if a < b else b
while diviseur <= min:
    if a % diviseur == 0 and b % diviseur == 0:
        pgcd = diviseur
    diviseur += 1

print(pgcd) """

#

""" word = "0123456789"
print(word[::-1]) """

# 1. Commencez par créer une liste de 10 nombres aléatoires compris entre 1 et 100. 
# Ensuite, affichez cette liste générée. 
# Après cela, calculez la somme de tous les éléments de la liste et affichez-la.

""" import random
random_ten = []
sum_ten = 0

for i in range(10):
    random_ten.append(random.randint(1, 100))
    sum_ten += random_ten[i]
print(random_ten)
print(sum_ten) """

# 2. Invitez l'utilisateur à saisir son prénom et son nom. 
# Ensuite, créez un tuple contenant ces informations. 
# Pour finir, affichez séparément le prénom et le nom à partir du tuple

""" tup = input("prénom ? :"), input("nom ? : ")
prenom, nom = tup

print(prenom, nom)
 """

# 3. Générez deux ensembles de nombres aléatoires compris entre 1 et 20. 
# Affichez ces deux ensembles générés. 
# Enfin, trouvez l'intersection des deux ensembles et affichez-la.

""" import random
rand_1 = set([random.randint(1, 20) for i in range(10)])
rand_2 = set([random.randint(1, 20) for i in range(10)])

print(rand_1)
print(rand_2)
print(rand_1.intersection(rand_2)) """

# 4. Créez un dictionnaire contenant les prix de quelques fruits tels que la pomme, la banane et l'orange.
# Demandez à l'utilisateur de saisir le nom d'un fruit, puis affichez le prix correspondant à ce fruit s'il existe dans le dictionnaire.

""" fruits = {
    "pomme": 1,
    "banane": 2,
    "orange": 3
}
user_input = input("fruit ? : ")
if user_input in list(fruits.keys()):
    print(f"{user_input} coûte {fruits[user_input]} €")
else:
    print("Ce fruit n'est pas dans la liste.") """

# 5. Créez une liste de tuples contenant le nom et l'âge de trois personnes. 
# Trouvez ensuite la personne la plus âgée et affichez son nom.

""" people = [
    ("kenny", 38),
    ("scott", 45),
    ("jean", 30)
]

oldest = ("", 0)
for person in people:
    if person[1] > oldest[1]:
        oldest = person
print(people)
print(f"Le plus âgé est : {oldest}") """

# 6. Générez une liste de 10 nombres aléatoires compris entre 1 et 50. 
# Affichez cette liste générée. Ensuite, filtrez les nombres pairs de la liste et 
# créez une nouvelle liste ne contenant que ces nombres pairs. 
# Enfin, affichez la nouvelle liste contenant uniquement les nombres pairs.

""" import random
lst = [random.randint(1, 50) for i in range(10)]
print(lst)
pairs = [i for i in lst if i % 2 == 0]
print(pairs) """

# 7. Créez une liste de mots contenant des doublons. 
# Transformez ensuite cette liste en un ensemble pour éliminer les doublons. 
# Affichez l'ensemble résultant.

""" words = ["abc", "abc", "123", "123", "654", "789", "oiu"]
uniques = set(words)
print(uniques) """

# 8. Créez un dictionnaire de listes représentant différents cours et les étudiants inscrits dans chaque cours. 
# Ajoutez des étudiants à chaque cours. 
# Ensuite, demandez à l'utilisateur de saisir le nom d'un cours et affichez la liste des étudiants inscrits à ce cours.

""" school = {
    "math": ["math1", "math2", "math3", "math4"],
    "sciences": ["sciences1", "sciences2", "sciences3", "sciences4"],
    "anglais": ["anglais1", "anglais2", "anglais3", "anglais4"]
}

school["math"].append(f"math{len(school["math"]) + 1}")
school["sciences"].append(f"sciences{len(school["sciences"]) + 1}")
school["anglais"].append(f"anglais{len(school["anglais"]) + 1}")

cours = input("cours ? : ")
if cours in list(school.keys()):
    print(school[cours])
else:
    print("Il n'y a pas ce cours.") """

# 9. Créez une liste de tuples représentant les commandes d'achat avec les produits et les quantités. 
# Ensuite, créez un dictionnaire de prix pour chaque produit. 
# Calculez ensuite le coût total de toutes les commandes et affichez-le.

""" shop_list = [
    ("produit1", 1),
    ("produit2", 2),
    ("produit3", 3),
    ("produit4", 4),
    ("produit5", 5)
]

shop_dict = dict(shop_list)
total = 0
for produit in shop_dict:
    total += shop_dict[produit]
print(total) """

# 10. Créez une liste de dictionnaires représentant les informations des employés avec leur nom, salaire et département. 
# Calculez la somme des salaires pour chaque département, puis calculez la moyenne des salaires pour chaque département. 
# Enfin, affichez les moyennes des salaires pour chaque département.

""" employees = [
    {
        "nom": "nom1",
        "salaire": 1111,
        "departement": "departement1"
    },
    {
        "nom": "nom2",
        "salaire": 2222,
        "departement": "departement1"
    },
    {
        "nom": "nom3",
        "salaire": 3333,
        "departement": "departement2"
    },
    {
        "nom": "nom4",
        "salaire": 4444,
        "departement": "departement2"
    }
]

departement1_salaires = [i["salaire"] for i in employees if i["departement"] == "departement1"]
departement2_salaires = [i["salaire"] for i in employees if i["departement"] == "departement2"]

departement1_somme = 0
for salaire in departement1_salaires:
    departement1_somme += salaire
departement1_average = departement1_somme / len(departement1_salaires)

departement2_somme = 0
for salaire in departement2_salaires:
    departement2_somme += salaire
departement2_average = departement2_somme / len(departement2_salaires)

print(departement1_average)
print(departement2_average) """
