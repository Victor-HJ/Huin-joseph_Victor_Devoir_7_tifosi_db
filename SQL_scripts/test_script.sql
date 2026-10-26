-- Requête de test n°1 : afficher les focaccias par ordre alphabétique croissant

SELECT `nom_focaccia`
FROM `focaccia`
ORDER BY `nom_focaccia` ASC

-- Résultat attendu : affichage des focaccias par ordre alphabétique
-- Résultat obtenu : affichage des focaccias par ordre alphabétique

-- Requête de test n°2 : afficher le nombre total d'ingrédients

SELECT COUNT(*) AS total_ingredients
FROM `ingredient`

-- Résultat attendu : Affichage du nombre total d'ingrédients dans une colonne total_ingredients
-- Résultat obtenu : Les 25 ingrédients sont afficgés dans ue colonne total_ingredients

-- Requête de test n°3 : Afficher le prix moyen des focaccias

SELECT ROUND(AVG(`prix_focaccia`), 2) AS prix_moyen
FROM `focaccia`

-- Résultat attendu : Affichage du prix moyen des focaccias dans une colonne prix_moyen
-- Résultat obtenu : Prix moyen affiché dans une colonne prix_moyen (10.375000)