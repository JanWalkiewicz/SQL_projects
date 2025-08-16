-- Author: Jan Walkiewicz

-- Set SQL mode to simplify database creation:
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create database

/* Checking whether the "veterinary" database already exists */
DROP SCHEMA IF EXISTS `veterinary` ;

/* Creating and using the "veterinary" database */
CREATE SCHEMA IF NOT EXISTS `veterinary` DEFAULT CHARACTER SET utf8 ;
USE `veterinary` ;

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Create tables:


-- 1) Rooms table

/* Checking whether the "Rooms" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Rooms` ;

/* Creating the "Rooms" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Rooms` (
  `idRooms` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(30) NOT NULL,
  `floor` INT NULL,
  `number` INT NOT NULL,
  PRIMARY KEY (`idRooms`),
  UNIQUE INDEX `number_UNIQUE` (`number` ASC) )
ENGINE = InnoDB;


-- 2) Owners table

/* Checking whether the "Owners" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Owners` ;

/* Creating the "Owners" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Owners` (
  `idOwners` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `address` VARCHAR(100) NULL,
  `phone` VARCHAR(15) NULL,
  `email` VARCHAR(100) NULL UNIQUE,
  PRIMARY KEY (`idOwners`),

/* Checking data */
CHECK (`email` LIKE '%@%'))
ENGINE = InnoDB;


-- 3) Pets table

/* Checking whether the "Pets" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Pets` ;

/* Creating the "Pets" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Pets` (
  `idPets` INT NOT NULL AUTO_INCREMENT,
  `species` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `age` INT NULL,
  `gender` ENUM('male', 'female', 'other', 'unknown') NULL,
  `breed` VARCHAR(30) NULL,
  `idOwners` INT NOT NULL,
  PRIMARY KEY (`idPets`),
  INDEX `fk_Pets_Owners1_idx` (`idOwners` ASC),
  CONSTRAINT `fk_Pets_Owners1`
    FOREIGN KEY (`idOwners`)
	REFERENCES `veterinary`.`Owners` (`idOwners`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

/* Checking data */
  CHECK (`age` >= 0))
ENGINE = InnoDB;


-- 4) Employees table

/* Checking whether the "Employees" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Employees` ;

/* Creating the "Employees" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Employees` (
  `idEmployees` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birth_date` DATE NOT NULL,
  `hourly_rate` DECIMAL(10,2) NOT NULL,
  `hire_date` DATE NOT NULL,
  `phone` VARCHAR(15) NULL,
  `email` VARCHAR(100) NULL UNIQUE,
  PRIMARY KEY (`idEmployees`),

/* Checking data*/
  CHECK (`hourly_rate` > 0),
  CHECK (`phone` REGEXP '^[+]?[0-9]+$'),
  CHECK (`email` LIKE '%@%'))
ENGINE = InnoDB;


-- 5) Doctors table

/* Checking whether the "Doctors" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Doctors` ;

/* Creating the "Doctors" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Doctors` (
  `idEmployees` INT NOT NULL,
  `license` VARCHAR(100) NOT NULL,
  `speciality` VARCHAR(100) NULL,
  PRIMARY KEY (`idEmployees`),
  INDEX `fk_doctors_employees1_idx` (`idEmployees` ASC),
  CONSTRAINT `fk_doctors_employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- 6) Visits table 

/* Checking whether the "Visits" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Visits` ;

/* Creating the "Visits" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Visits` (
  `idVisits` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `type` VARCHAR(45) NULL,
  `cost` DECIMAL(10,2) NOT NULL,
  `is_paid` TINYINT NOT NULL,
  `idRooms` INT NOT NULL,
  `idPets` INT NOT NULL,
  `idEmployees` INT NOT NULL,
  PRIMARY KEY (`idVisits`),
  INDEX `fk_Visit_Rooms_idx` (`idRooms` ASC),
  INDEX `fk_Visit_Pet1_idx` (`idPets` ASC),
  INDEX `fk_Visit_doctors1_idx` (`idEmployees` ASC),
  CONSTRAINT `fk_Visit_Rooms`
    FOREIGN KEY (`idRooms`)
    REFERENCES `veterinary`.`Rooms` (`idRooms`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Visit_Pet1`
    FOREIGN KEY (`idPets`)
    REFERENCES `veterinary`.`Pets` (`idPets`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Visit_doctors1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Doctors` (`idEmployees`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

/* Checking data*/
    CHECK (`cost` >= 0),
    CHECK (`is_paid` IN (0, 1)))
ENGINE = InnoDB;


-- 7) Receptionists table

/* Checking whether the "Receptionists" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Receptionists` ;

/* Creating the "Receptionists" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Receptionists` (
  `idEmployees` INT NOT NULL,
  `languages_spoken` VARCHAR(100) NULL,
  `shift` ENUM('morning', 'afternoon', 'evening') NULL,
  PRIMARY KEY (`idEmployees`),
  CONSTRAINT `fk_receptionist_employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- 8) Users table

/* Checking whether the "Users" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Users` ;

/* Creating the "Users" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Users` (
  `idEmployees` INT NOT NULL,
  `login` VARCHAR(45) NOT NULL UNIQUE,
  `hashed_password` VARCHAR(200) NOT NULL,
  `role` VARCHAR(50) NULL,
  PRIMARY KEY (`idEmployees`),
  CONSTRAINT `fk_Users_Employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- 9) Pharmacists table

/* Checking whether the "Pharmacists" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Pharmacists` ;

/* Creating the "Pharmacists" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Pharmacists` (
  `idEmployees` INT NOT NULL,
  `license` VARCHAR(250) NULL,
  `shift` ENUM('morning', 'afternoon', 'evening') NULL,
  PRIMARY KEY (`idEmployees`),
  CONSTRAINT `fk_Pharmacist_Employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- 10) Cleaning_staff table

/* Checking whether the "Cleaning_staff" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Cleaning_staff` ;

/* Creating the "Cleaning_staff" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Cleaning_staff` (
  `idEmployees` INT NOT NULL,
  `area_assigned` VARCHAR(45) NULL,
  `shift` ENUM('morning', 'afternoon', 'evening') NULL,
  PRIMARY KEY (`idEmployees`),
  CONSTRAINT `fk_Cleaning_staff_Employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- 11) Manual_workers table

/* Checking whether the "Manual_workers" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Manual_workers` ;

/* Creating the "Manual_workers" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Manual_workers` (
  `idEmployees` INT NOT NULL,
  `specialty` VARCHAR(100) NULL,
  `on_call_24h` TINYINT NULL,
  PRIMARY KEY (`idEmployees`),
  CONSTRAINT `fk_Manual_workers_Employees1`
    FOREIGN KEY (`idEmployees`)
    REFERENCES `veterinary`.`Employees` (`idEmployees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

/* Checking entered data*/
  CHECK (`on_call_24h` IN (0, 1)))
ENGINE = InnoDB;


-- 12) Diseases table

/* Checking whether the "Diseases" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Diseases` ;

/* Creating the "Diseases" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Diseases` (
  `idDiseases` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`idDiseases`))
ENGINE = InnoDB;


-- 13) Diagnoses table

/* Checking whether the "Diagnoses" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Diagnoses` ;

/* Creating the "Diagnoses" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Diagnoses` (
  `idDiagnoses` INT NOT NULL AUTO_INCREMENT,
  `symptoms` MEDIUMTEXT NOT NULL,
  `description` LONGTEXT NULL,
  `idDiseases` INT NOT NULL,
  PRIMARY KEY (`idDiagnoses`),
  INDEX `fk_Diagnoses_Diseases1_idx` (`idDiseases` ASC),
  CONSTRAINT `fk_Diagnoses_Diseases1`
    FOREIGN KEY (`idDiseases`)
    REFERENCES `veterinary`.`Diseases` (`idDiseases`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- 14) Visits_history table

/* Checking whether the "Visits_history" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Visits_history` ;

/* Creating the "Visits_history" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Visits_history` (
  `idVisits` INT NOT NULL,
  `additional_information` LONGTEXT NULL,
  `idPrescriptions` INT NOT NULL,
  PRIMARY KEY (`idVisits`),
  INDEX `fk_Visit_history_Prescriptions1_idx` (`idPrescriptions` ASC),
  CONSTRAINT `fk_Visit_history_Visit1`
    FOREIGN KEY (`idVisits`)
    REFERENCES `veterinary`.`Visits` (`idVisits`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Visit_history_Prescriptions1`
    FOREIGN KEY (`idPrescriptions`)
    REFERENCES `veterinary`.`Prescriptions` (`idPrescriptions`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- 15) Diagnoses_Visits_history table

/* Checking whether the "Diagnoses_Visits_history" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Diagnoses_Visits_history` ;

/* Creating the "Diagnoses_Visits_history" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Diagnoses_Visits_history` (
  `idDiagnoses` INT NOT NULL,
  `idVisits` INT NOT NULL,
  PRIMARY KEY (`idDiagnoses`, `idVisits`),
  INDEX `fk_Diagnoses_has_Visits_history_Visits_history1_idx` (`idVisits` ASC),
  INDEX `fk_Diagnoses_has_Visits_history_Diagnoses1_idx` (`idDiagnoses` ASC),
  CONSTRAINT `fk_Diagnoses_has_Visits_history_Diagnoses1`
    FOREIGN KEY (`idDiagnoses`)
    REFERENCES `veterinary`.`Diagnoses` (`idDiagnoses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Diagnoses_has_Visits_history_Visits_history1`
    FOREIGN KEY (`idVisits`)
    REFERENCES `veterinary`.`Visits_history` (`idVisits`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- 16) Prescriptions table

/* Checking whether the "Prescriptions" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Prescriptions` ;

/* Creating the "Prescriptions" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Prescriptions` (
  `idPrescriptions` INT NOT NULL AUTO_INCREMENT,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`idPrescriptions`))
ENGINE = InnoDB;


-- 17) Medications table

/* Checking whether the "Medications" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Medications` ;

/* Creating the "Medications" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Medications` (
  `idMedications` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `dosage` MEDIUMTEXT NULL,
  `administration_method` VARCHAR(100) NULL,
  PRIMARY KEY (`idMedications`))
ENGINE = InnoDB;


-- 18) Prescriptions_Medications table

/* Checking whether the "Prescriptions_Medications" table already exists */
DROP TABLE IF EXISTS `veterinary`.`Prescriptions_Medications` ;

/* Creating the "Prescriptions_Medications" table */
CREATE TABLE IF NOT EXISTS `veterinary`.`Prescriptions_Medications` (
  `idPrescriptions` INT NOT NULL,
  `idMedications` INT NOT NULL,
  PRIMARY KEY (`idPrescriptions`, `idMedications`),
  INDEX `fk_Prescriptions_has_Medications_Medications1_idx` (`idMedications` ASC),
  INDEX `fk_Prescriptions_has_Medications_Prescriptions1_idx` (`idPrescriptions` ASC),
  CONSTRAINT `fk_Prescriptions_has_Medications_Prescriptions1`
    FOREIGN KEY (`idPrescriptions`)
    REFERENCES `veterinary`.`Prescriptions` (`idPrescriptions`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescriptions_has_Medications_Medications1`
    FOREIGN KEY (`idMedications`)
    REFERENCES `veterinary`.`Medications` (`idMedications`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Insert into tables:

-- 1) Rooms table
/* Entering records into the Rooms table */
INSERT INTO Rooms (idRooms, type, floor, number) VALUES
(1, 'Consultation', 1, 101),
(2, 'Surgery', 2, 201),
(3, 'Consultation', 1, 102);

-- 2) Owners table
/* Entering records into the Owners table */
INSERT INTO Owners (idOwners, first_name, last_name, address, phone, email) VALUES
(1, 'John', 'Evans', '10 Baker Street, London', '123456789', 'john.evans@gmail.com'),
(2, 'Jane', 'Smith', '6 Castle Street, Liverpool', '987654321', 'jane.smith@gmail.com'),
(3, 'Emily', 'Johnson', '12 Grey Street, Newcastle', '555666777', 'emily.johnson@gmail.com');


-- 3) Pets table
/* Entering records into the Pets table */
INSERT INTO Pets (idPets, species, name, age, gender, breed, idOwners) VALUES
(1, 'Dog', 'Diki', 5, 'male', 'Labrador', 1),
(2, 'Cat', 'Miki', 3, 'female', 'Siamese', 2),
(3, 'Bird', 'Kiki', 2, 'other', 'Canary', 3);

-- 4) Employees table
/* Entering records into the Employees table */
INSERT INTO Employees (idEmployees, first_name, last_name, birth_date, hourly_rate, hire_date, phone, email) VALUES
(1, 'Adam', 'Smith', '1980-04-15', 40.0, '2010-06-01', '111222333', 'adam.smith@gmail.com'),
(2, 'Betty', 'Johnson', '1985-07-20', 35.5, '2012-08-15', '444555666', 'betty.johnson@gmail.com'),
(3, 'Charlie', 'Brown', '1990-01-30', 38.0, '2015-03-10', '777888999', 'charlie.brown@gmail.com'),
(4, 'Diana', 'Miller', '1992-05-12', 37.0, '2017-04-22', '222333444', 'diana.miller@gmail.com'),
(5, 'Edward', 'Wilson', '1988-11-23', 42.0, '2013-09-30', '555666777', 'edward.wilson@gmail.com'),
(6, 'Fiona', 'Taylor', '1995-03-17', 33.5, '2018-12-05', '888999000', 'fiona.taylor@gmail.com'),
(7, 'George', 'Anderson', '1983-08-09', 39.0, '2011-01-15', '333444555', 'george.anderson@gmail.com'),
(8, 'Helen', 'Thomas', '1991-10-30', 36.5, '2016-07-18', '666777888', 'helen.thomas@gmail.com');


-- 5) Doctors table
/* Entering records into the Doctors table */
INSERT INTO Doctors (idEmployees, license, speciality) VALUES
(1, 'ABC', 'Veterinary Surgery'),
(2, 'DEF', 'Dermatology'),
(3, 'GHI', 'Internal Medicine');

-- 6) Visits table
/* Entering records into the Visits table */
INSERT INTO Visits (idVisits, date, type, cost, is_paid, idRooms, idPets, idEmployees) VALUES
(1, '2025-08-01', 'Check-up', 100.0, 1, 1, 1, 1),
(2, '2050-08-05', 'Vaccination', 50.0, 0, 2, 2, 2),
(3, '2025-08-10', 'Surgery', 500.0, 1, 2, 3, 3);

-- 7) Receptionists table
/* Entering records into the Receptionists table */
INSERT INTO Receptionists (idEmployees, languages_spoken, shift) VALUES
(4, 'English, Polish', 'morning');

-- 8) Users table
/* Entering records into the Users table */
INSERT INTO Users (idEmployees, login, hashed_password, role) VALUES
(5, 'admin', 'password', 'admin');

-- 9) Pharmacists table
/* Entering records into the Pharmacists table */
INSERT INTO Pharmacists (idEmployees, license, shift) VALUES
(6, 'CAB', 'morning');

-- 10) Cleaning_staff table
/* Entering records into the Cleaning_staff table */
INSERT INTO Cleaning_staff (idEmployees, area_assigned, shift) VALUES
(7, 'First floor', 'morning');

-- 11) Manual_workers table
/* Entering records into the Manual_workers table */
INSERT INTO Manual_workers (idEmployees, specialty, on_call_24h) VALUES
(8, 'Maintenance', 1);

-- 12) Diseases table
/* Entering records into the Diseases table */
INSERT INTO Diseases (idDiseases, name, description) VALUES
(1, 'Parvovirus', 'Highly contagious viral illness in dogs'),
(3, 'Psittacosis', 'Infectious disease in birds');

-- 13) Diagnoses table
/* Entering records into the Diagnoses table */
INSERT INTO Diagnoses (idDiagnoses, symptoms, description, idDiseases) VALUES
(1, 'Vomiting, diarrhea', 'Confirmed parvovirus infection', 1),
(3, 'Respiratory distress', 'Typical symptoms of psittacosis', 3);

-- 14) Visits_history table
/* Entering records into the Visits_history table */
INSERT INTO Visits_history (idVisits, additional_information, idPrescriptions) VALUES
(1, 'Recovery normal', 1),
(3, 'Surgery successful', 3);

-- 15) Diagnoses_Visits_history table
/* Entering records into the Diagnoses_Visits_history table */
INSERT INTO Diagnoses_Visits_history (idDiagnoses, idVisits) VALUES
(1, 1),
(3, 3);

-- 16) Prescriptions table
/* Entering records into the Prescriptions table */
INSERT INTO Prescriptions (idPrescriptions, description) VALUES
(1, 'Treatment for parvovirus'),
(2, 'Routine vaccination'),
(3, 'Pain management post-surgery');

-- 17) Medications table
/* Entering records into the Medications table */
INSERT INTO Medications (idMedications, name, dosage, administration_method) VALUES
(1, 'Antibiotic', '2x daily for 7 days', 'Oral'),
(2, 'Vaccine', 'Single dose', 'Injection'),
(3, 'Painkiller', 'As needed', 'Injection');

-- 18) Prescriptions_Medications table
/* Entering records into the Prescriptions_Medications table */
INSERT INTO Prescriptions_Medications (idPrescriptions, idMedications) VALUES
(1, 1),
(2, 2),
(3, 3);

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Create procedures:


-- 1) Add_employee procedure

/* Checking whether the "Add_employee" procedure already exists */
DROP procedure IF EXISTS `veterinary`.`Add_employee`;

/* Creating the "Add_employee" procedure */
DELIMITER //
CREATE PROCEDURE Add_employee(
	IN new_first_name VARCHAR(45),
    IN new_last_name VARCHAR(45),
    IN new_birth_date DATE,
    IN new_hourly_rate FLOAT,
    IN new_hire_date DATE,
    IN new_phone VARCHAR(15),
    IN new_email VARCHAR(100))
BEGIN
    INSERT INTO Employees (first_name, last_name, birth_date, hourly_rate, hire_date, phone, email)
    VALUES (new_first_name, new_last_name, new_birth_date, new_hourly_rate, new_hire_date, new_phone, new_email);
END//
DELIMITER ;


-- 2) Delete_visit procedure

/* Checking whether the "Delete_visit" procedure already exists */
DROP procedure IF EXISTS `veterinary`.`Delete_visit`;

/* Creating the "Delete_visit" procedure */
DELIMITER //
CREATE PROCEDURE Delete_visit (
	IN delete_idVisit INT)
BEGIN
    DECLARE visitDate DATE;
    SELECT date INTO visitDate
    FROM Visits
    WHERE idVisits = delete_idVisit;
    IF visitDate >= CURDATE() THEN
		DELETE FROM Visits
        WHERE idVisits = delete_idVisit;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a visit that already happened or is today.';
    END IF;
END//
DELIMITER ;


-- 3) Add_diagnosis procedure

/* Checking whether the "Add_diagnosis" procedure already exists */
DROP procedure IF EXISTS `veterinary`.`Add_diagnosis`;

/* Creating the "Add_diagnosis" procedure */
DELIMITER //
CREATE PROCEDURE Add_diagnosis (
    IN what_idVisit INT,
    IN new_idDiagnoses INT)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Diagnoses_Visits_history
        WHERE idDiagnoses = new_idDiagnoses AND idVisits = what_idVisit)
    THEN
        INSERT INTO Diagnoses_Visits_history (idDiagnoses, idVisits) 
        VALUES (new_idDiagnoses, what_idVisit);
    END IF;
END//
DELIMITER ;

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Create views:


-- 1) Unpaid_visits view

/* Checking whether the "Unpaid_visits" view already exists */
DROP VIEW IF EXISTS `veterinary`.`Unpaid_visits` ;

/* Creating the "Unpaid_visits" view */
CREATE  OR REPLACE VIEW `Unpaid_visits` AS
SELECT Pets.idPets AS Pet_id,
Pets.name AS Pet_name, 
Owners.first_name AS Owner_first_name, 
Owners.last_name AS Owner_last_name,
COUNT(Visits.is_paid) AS Number_of_unpaid_visits
FROM Pets
JOIN Owners ON Pets.idOwners = Owners.idOwners
JOIN Visits ON Pets.idPets = Visits.idPets
WHERE Visits.is_paid = 0
GROUP BY Pets.idPets, Pets.name, Owners.first_name, Owners.last_name;


-- 2) Future_visits view

/* Checking whether the "Future_visits" view already exists */
DROP VIEW IF EXISTS `veterinary`.`Future_visits` ;

/* Creating the "Future_visits" view */
CREATE  OR REPLACE VIEW Future_visits AS
SELECT Visits.idVisits AS Visit_id, 
Visits.date AS Visit_date,
CONCAT(Employees.first_name, ' ', Employees.last_name) AS Doctor_name, 
Pets.name AS Pet_name, 
Pets.species AS Pet_species
FROM Visits
JOIN Doctors ON Doctors.idEmployees = Visits.idEmployees
JOIN Employees ON Employees.idEmployees = Doctors.idEmployees
JOIN Pets ON Pets.idPets = Visits.idPets
WHERE Visits.date > CURDATE()
ORDER BY Visits.date;


-- 3) Pet_diseases view

/* Checking whether the "Pet_diseases" view already exists */
DROP VIEW IF EXISTS `veterinary`.`Pet_diseases` ;

/* Creating the "Pet_diseases" view */
CREATE  OR REPLACE VIEW `Pet_diseases` AS
SELECT Pets.idPets AS Pet_id,
Pets.name AS Pet_name,
CONCAT(Owners.first_name, ' ',Owners.last_name) AS Owner_name,
Diseases.name AS Disease_name
FROM Pets
LEFT JOIN Owners ON Owners.idOwners = Pets.idOwners
JOIN Visits ON Visits.idPets = Pets.idPets
JOIN Visits_history ON Visits_history.idVisits = Visits.idVisits
JOIN Diagnoses_Visits_history ON Diagnoses_Visits_history.idVisits = Visits_history.idVisits
JOIN Diagnoses ON Diagnoses.idDiagnoses = Diagnoses_Visits_history.idDiagnoses
JOIN Diseases ON Diseases.idDiseases = Diagnoses.idDiseases;

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Create triggers:


-- 1) Set_default_cost trigger

/* Creating the "Set_default_cost" trigger */
DELIMITER //
CREATE TRIGGER `Set_default_cost`
BEFORE INSERT ON Visits
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = CASE NEW.type
            WHEN 'Consultation' THEN 50
            WHEN 'Surgery' THEN 500
            WHEN 'Injection' THEN 25
            ELSE 100
        END;
    END IF;
END//
DELIMITER ;


-- 2) set_hire_date_automatically trigger

/* Creating the "set_hire_date_automatically" trigger */
DELIMITER //
CREATE TRIGGER set_hire_date_automatically
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.hire_date IS NULL OR NEW.hire_date = '' THEN
        SET NEW.hire_date=CURDATE();
    END IF;
END//
DELIMITER ;


-- 3) check_employee_dates trigger

/* Creating the "check_employee_dates" trigger */
DELIMITER //
CREATE TRIGGER `check_employee_dates`
BEFORE INSERT ON Employees
FOR EACH ROW 
BEGIN
    IF NEW.birth_date >= CURDATE() THEN
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'The date of birth must be in the past.';
    END IF;
    IF NEW.hire_date < NEW.birth_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The date of employment cannot be earlier than the date of birth.';
    END IF;
END//
DELIMITER ;

-- ------------------------------------------------------
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Restore previous SQL settings:
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;