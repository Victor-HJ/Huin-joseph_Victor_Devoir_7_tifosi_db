-- Requête de test n°1 : afficher les focaccias par ordre alphabétique croissant

SELECT `nom_focaccia`
FROM `focaccia`
ORDER BY `nom_focaccia` ASC;

-- Résultat attendu : affichage des focaccias par ordre alphabétique
-- Résultat obtenu : affichage des focaccias par ordre alphabétique

-- Requête de test n°2 : afficher le nombre total d'ingrédients

SELECT COUNT(*) AS total_ingredients
FROM `ingredient`;

-- Résultat attendu : Affichage du nombre total d'ingrédients dans une colonne total_ingredients
-- Résultat obtenu : Les 25 ingrédients sont affichés dans une colonne total_ingredients

-- Requête de test n°3 : Afficher le prix moyen des focaccias

SELECT ROUND(AVG(`prix_focaccia`), 2) AS prix_moyen
FROM `focaccia`;

-- Résultat attendu : Affichage du prix moyen des focaccias dans une colonne prix_moyen (avec une approximation à deux décimales)
-- Résultat obtenu : Prix moyen affiché dans une colonne prix_moyen (10.38, apprixmation à deux décimales)

-- Requête de test n°4 : Afficher la liste des boissons avec leurs marques, triée par nom de boisson

SELECT `nom_boisson`, `nom_marque`
FROM `boisson`
JOIN `marque` ON `boisson`.`id_marque` = `marque`.`id_marque`
ORDER BY `nom_boisson` ASC;

-- Résultat attendu : Affichage dans deux colonnes (nom_boisson \\ nom_marque) des boissons,
-- triées par ordre alphabétique, et de leurs marques respectives
-- Résultat obtenu : Affichage correct des boissons en ordre alphabétique et de leurs marques 

-- Requête de test n°5 : Afficher la liste des ingrédients pour une raclaccia

SELECT `nom_ingredient`, `quantite` AS grammes
FROM `ingredient`
JOIN `comprend` ON `ingredient`.`id_ingredient` = `comprend`.`id_ingredient`
JOIN `focaccia` ON `focaccia`.`id_focaccia` = `comprend`.`id_focaccia`
WHERE `nom_focaccia` = 'Raclaccia';

-- Résultat attendu : Afichage des ingrédients pour une Raclaccia + quantités
-- Résultat obtenu : Affichage des ingrédients pour une Raclaccia + leurs quantités en grammes

-- Requête de test n°6 : Afficher le nom et le nombre d'ingrédients pour chaque focaccia

SELECT `nom_focaccia`, COUNT(`id_ingredient`) AS nombre_ingredients
FROM `focaccia`
JOIN `comprend` ON `focaccia`.`id_focaccia` = `comprend`.`id_focaccia`
GROUP BY `focaccia`.`id_focaccia`
ORDER BY nombre_ingredients DESC;

-- Résultat attendu : Afficher le nombre d'ingrédients pour chque focaccia (par nom)
-- Résultat obtenu : Affichage du nombre d'ingrédients dans une colonne nombre_ingredients pour chaque focaccia dans la colonne nom_focaccia. 
-- Le nombre d'ingrédients est incorrect car sous-estimé par 1 pour toutes celles contenant des oeufs. 
-- Le résultat est affiché en ordre décroissant selon le nombre d'ingrédients

-- Explication du décalage : la différence d'écriture de 'oeuf' entre les CSV focaccia et ingrédient ('œuf' et 'oeuf').
-- Le script d'importation ne l'inclue pas dans la table comprend car les deux lui aparaissent différents. 
-- Par conséquent, l'ingrédient oeuf ne sera jamais inclu dans la table intermédiaire comprend
-- mais sera inclu dans la table ingredient. 

-- Requête de test n°7 : Afficher la focaccia contenant le plus d'ingrédients

SELECT `nom_focaccia`, COUNT(`id_ingredient`) AS nombre_ingredients
FROM `focaccia`
JOIN `comprend` ON `focaccia`.`id_focaccia` = `comprend`.`id_focaccia`
GROUP BY `focaccia`.`id_focaccia`
ORDER BY nombre_ingredients DESC
LIMIT 1;

-- Résultat attendu : Afficher la focaccia paysanne et son nombre d'ingrédients (12) dans la colonne nombre_ingredients
-- Résultat obtenu : Affichage de la focaccia paysanne, mais 11 ingrédients sont comptés dans la colonne nombre_ingredients

-- Explication du décalage : Le CSV focaccia contient l'ingrédient oeuf avec un 'œ', tandis que le CSV ingredient contient 'oeuf'
-- Le script d'import qui envoie les données dans la table intermédiaire comprend passe outre cet ingrédient, car les orthographes
-- ne sont pas absolument identiques dans les deux CSV. Oeuf apparaît bien dans la table ingredient  
-- mais n'apparaîtra par conséquent pas dans la table comprend. Le code qui pose problème pendant l'insertion en table : 
-- JOIN `ingredient` ON `temp_focaccia_ingredients`.`liste_ingredients` LIKE CONCAT('%', `ingredient`.`nom_ingredient`, '%')

-- Requête n°8 : Afficher la liste des focaccias qui contiennent de l'ail

SELECT `nom_focaccia` AS focaccia_avec_ail
FROM `focaccia`
JOIN `comprend` ON `focaccia`.`id_focaccia` = `comprend`.`id_focaccia`
JOIN `ingredient` ON `ingredient`.`id_ingredient` = `comprend`.`id_ingredient`
WHERE `ingredient`.`nom_ingredient` = 'Ail'
ORDER BY `nom_focaccia` ASC;

-- Résultat attendu : Affichage des focaccias qui contiennent de l'ail
-- Résultat obtenu : les 4 focaccias contenant de l'ail sont affichées par ordre alphabétique

-- Requête n°9 : Afficher la liste des ingrédients inutilisés

SELECT `nom_ingredient` AS ingrédients_inutilisés
FROM `ingredient`
WHERE `id_ingredient` NOT IN (SELECT `id_ingredient` FROM `comprend`);

-- Résultat attendu : Affichage dans une colonne ingrédients_inutilisés des ingrédients inutilisés.
-- Résultat obtenu : Affichage de 3 ingrédients inutilisés au lieu de 2. 

-- Explication du décalage : Oeuf est considére comme inutilisé car il n'est pas dans
-- la table intermédiaire comprend, à cause du problème de différence d'orthographe
-- mentionné plus haut. 

-- Requête n°10 : Afficher la liste des focaccias qui n'ont pas de champignons

SELECT `nom_focaccia` AS focaccia_sans_champignons
FROM `focaccia`
WHERE `id_focaccia` NOT IN(
    SELECT `id_focaccia`
    FROM `comprend`
    JOIN `ingredient` ON `comprend`.`id_ingredient` = `ingredient`.`id_ingredient`
    WHERE `ingredient`.`nom_ingredient` = 'Champignon'
)
ORDER BY `nom_focaccia` ASC;

-- Résultat attendu : Affichage de toutes les focaccias ne contenant pas de champignons dans la colonne focaccia_sans_champignons
-- Résultat obtenu : Affichage correct de deux focaccias, les deux seules sans champignons. 