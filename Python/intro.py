# Trouvez un moyen d'inverser les valeurs de a et b sans utiliser l'affectation multiple (a, b = b, a)
""" a:int = 5
b:int = 7
print(f"a = {a} -- b = {b}")
c:int = a
a = b
b = c
print(f"a = {a} -- b = {b}")
 """

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
""" a, b = 5, 6
print(a, b)
a = [a, b]
b = a[0]
a = a[1]
print(a, b) """

# 5. Écrivez un programme Python convertissant un nombre de secondes en jours, heures, minutes et seconds correspondants. Exemple : 4561 secondes correspondent à 0 jour, 1 heure, 16 minutes et 1 seconde. Réfléchissez à la méthode à utiliser, puis réalisez l'algorithme en Python. Testez-le ensuite pour vérifier sa validité.
input_seconds = int(input("Entrer un nombre de secondes : "))

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