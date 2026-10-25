CREATE DATABASE IF NOT EXISTS tifosi
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

CREATE TABLE `tifosi`.`focaccia` (

    `id_focaccia` INT NOT NULL AUTO_INCREMENT,
    `nom_focaccia` VARCHAR(50) NOT NULL UNIQUE,
    `prix_focaccia` DECIMAL(5,2) NOT NULL,

    PRIMARY KEY(`id_focaccia`)

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`ingredient`(

    `id_ingredient`INT NOT NULL AUTO_INCREMENT,
    `nom_ingredient`VARCHAR(50) NOT NULL UNIQUE,

    PRIMARY KEY(`id_ingredient`)

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`marque`(

    `id_marque` INT NOT NULL AUTO_INCREMENT,
    `nom_marque` VARCHAR(50) NOT NULL UNIQUE,

    PRIMARY KEY(`id_marque`)

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`boisson`(

    `id_boisson` INT NOT NULL AUTO_INCREMENT,
    `nom_boisson` VARCHAR(50) NOT NULL UNIQUE,
    `id_marque` INT NOT NULL,

    PRIMARY KEY(`id_boisson`),

    FOREIGN KEY(`id_marque`) REFERENCES `marque`(`id_marque`) ON DELETE CASCADE

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`menu`(

    `id_menu` INT NOT NULL AUTO_INCREMENT,
    `nom_menu` VARCHAR(50) NOT NULL UNIQUE,
    `prix_menu` DECIMAL(5,2) NOT NULL,
    `id_focaccia` INT NOT NULL,

    PRIMARY KEY(`id_menu`),

    FOREIGN KEY(`id_focaccia`) REFERENCES `focaccia`(`id_focaccia`) ON DELETE CASCADE
    
) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`client`(

    `id_client` INT NOT NULL AUTO_INCREMENT,
    `nom_client` VARCHAR(50) NOT NULL,
    `email_client` VARCHAR(150) NOT NULL UNIQUE,
    `code_postal` INT NOT NULL,

    PRIMARY KEY (`id_client`)

) ENGINE = InnoDB;




CREATE TABLE `tifosi`.`contient`(

    `id_menu` INT NOT NULL,
    `id_boisson` INT NOT NULL,
    `quantite_boisson` INT NOT NULL DEFAULT 1,

    PRIMARY KEY(`id_menu`, `id_boisson`),

    FOREIGN KEY(`id_menu`) REFERENCES `menu`(`id_menu`) ON DELETE CASCADE,
    FOREIGN KEY(`id_boisson`) REFERENCES `boisson`(`id_boisson`) ON DELETE CASCADE

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`comprend`(

    `id_focaccia` INT NOT NULL,
    `id_ingredient` INT NOT NULL,
    `quantite` INT NULL,

    PRIMARY KEY(`id_focaccia`, `id_ingredient`),

    FOREIGN KEY(`id_focaccia`) REFERENCES `focaccia`(`id_focaccia`) ON DELETE CASCADE,
    FOREIGN KEY(`id_ingredient`) REFERENCES `ingredient`(`id_ingredient`) ON DELETE CASCADE

) ENGINE = InnoDB;


CREATE TABLE `tifosi`.`achete`(

    `id_client` INT NOT NULL,
    `id_menu` INT NOT NULL,
    `quantite` INT NULL,

    PRIMARY KEY(`id_client`, `id_menu`),

    FOREIGN KEY(`id_client`) REFERENCES `client`(`id_client`) ON DELETE CASCADE,
    FOREIGN KEY(`id_menu`) REFERENCES `menu`(`id_menu`) ON DELETE CASCADE

) ENGINE = InnoDB;