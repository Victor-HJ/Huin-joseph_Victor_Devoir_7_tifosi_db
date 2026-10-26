USE tifosi;

LOAD DATA INFILE '../data/marque.csv'
INTO TABLE `marque`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(`id_marque`, `nom_marque`);

LOAD DATA INFILE '../data/ingredient.csv'
INTO TABLE `ingredient`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(`id_ingredient`, `nom_ingredient`);

LOAD DATA INFILE '../data/focaccia.csv'
INTO TABLE `focaccia`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(`id_focaccia`, `nom_focaccia`, `prix_focaccia`, @ne_pas_inclure);

CREATE TEMPORARY TABLE temp_boisson(

    `id_boisson` INT,
    `nom_boisson` VARCHAR(50),
    `b_empty` VARCHAR(2),
    `nom_marque` VARCHAR(50)

);

LOAD DATA INFILE '../data/boisson.csv'
INTO TABLE temp_boisson
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(`id_boisson`, `nom_boisson`, `b_empty`, `nom_marque`);

INSERT INTO `boisson`(`id_boisson`, `nom_boisson`, `id_marque`)
SELECT `temp_boisson`.`id_boisson`, `temp_boisson`.`nom_boisson`, `marque`.`id_marque`
FROM `temp_boisson`
JOIN `marque` ON `temp_boisson`.`nom_marque` = `marque`.`nom_marque`;

DROP TEMPORARY TABLE `temp_boisson`;

CREATE TEMPORARY TABLE `temp_focaccia_ingredients`(

    `id_focaccia` INT,
    `liste_ingredients` TEXT

);

LOAD DATA INFILE '../data/focaccia.csv'
INTO TABLE `temp_focaccia_ingredients`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(`id_focaccia`, @nom_focaccia, @prix_focaccia, `liste_ingredients`);

CREATE TEMPORARY TABLE `temp_quantites`(

    `nom_ingredient` VARCHAR(255),
    `quantite` INT

);

INSERT INTO `temp_quantites` (`nom_ingredient`, `quantite`) VALUES 
('Ail', 2), ('Ananas', 40), ('Artichaut', 20), ('Bacon', 80), ('Base Tomate', 200), ('Base crème', 200), ('Champignon', 40), 
('Chevre', 50), ('Cresson', 20), ('Emmental', 50), ('Gorgonzola', 50), ('Jambon cuit', 80), ('Jambon fumé', 80), ('Oeuf', 50), 
('Oignon', 20), ('Olive noire', 20), ('Olive verte', 20), ('Parmesan', 50), ('Piment', 2), ('Poivre', 1), ('Pomme de terre', 80),
('Raclette', 50), ('Salami', 80), ('Tomate cerise', 40), ('Mozarella', 50);

-- 1. Prendre la table temporaire des ingrédients de chaque focaccia
-- 2. Faire une jointure dès qu'un ingrédient de la table ingredient est retrouvé dans la liste contenue dans la table temporaire des ingrédients de chaque focaccia
-- 3. Faire une jointure en insérant la quantité par défaut de l'ingrédient dès que les noms d'ingrédients concordent
-- 4. Insérer le résultat dans la table intermédiaire comprend pour avoir la quantité par défaut

INSERT INTO `comprend` (`id_focaccia`, `id_ingredient`, `quantite`)
SELECT `temp_focaccia_ingredients`.`id_focaccia`, `ingredient`.`id_ingredient`, `temp_quantites`.`quantite`
FROM `temp_focaccia_ingredients`
JOIN `ingredient` ON `temp_focaccia_ingredients`.`liste_ingredients` LIKE CONCAT('%', `ingredient`.`nom_ingredient`, '%')
JOIN `temp_quantites` ON `ingredient`.`nom_ingredient` = `temp_quantites`.`nom_ingredient`;

DROP TEMPORARY TABLE temp_focaccia_ingredients;
DROP TEMPORARY TABLE temp_quantites;

-- Ecraser données par défaut pour certains ingrédients de la n°5
UPDATE `comprend` SET `quantite` = 80 WHERE `id_focaccia` = 5 AND `id_ingredient` = 7;
UPDATE `comprend` SET `quantite` = 10 WHERE `id_focaccia` = 5 AND `id_ingredient` = 16;
UPDATE `comprend` SET `quantite` = 10 WHERE `id_focaccia` = 5 AND `id_ingredient` = 17;

-- Ecraser quantité par défaut pour pommes de terre pour la n°7
UPDATE `comprend` SET `quantite` = 40 WHERE `id_focaccia` = 7 AND `id_ingredient` = 21;