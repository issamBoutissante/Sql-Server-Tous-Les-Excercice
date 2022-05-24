USE ressources
GO
CREATE TABLE produit(
id INT PRIMARY KEY IDENTITY(1,1),
nom VARCHAR(20),
categorie VARCHAR(20),
stock INT,
prix FLOAT
)
INSERT INTO produit VALUES
('ordinateur','informatique',5,950),
('clavier','informatique',32,35),
('souris','informatique',16,30),
('crayon','fourniture',147,2)


SELECT * FROM produit 
WHERE (categorie='informatique' and stock<20) OR 
	  (categorie='fourniture' and stock<200) ;

CREATE TABLE membres(
id INT PRIMARY KEY,
nom VARCHAR(20),
date_inscription DATE
);

insert into membres values(1,'Maurice','2012-03-02'),
(2,'Simon','2012-03-05'),(3,'Chloé','2012-04-14'),
(4,'Marie','2012-04-15'),(5,'Clémentine','2012-04-26');

SELECT * FROM membres 
WHERE date_inscription BETWEEN '2012-04-01' AND '2012-04-20';


CREATE TABLE items(
id INT PRIMARY KEY IDENTITY(1,1),
nom VARCHAR(20),
surcharge INT,
prix_unitaire FLOAT,
quantite int
);

INSERT INTO items VALUES
('Produit A',1.3,6,3),
('Produit B',1.5,8,2),
('Produit C',0.75,7,4),
('Produit D',1,15,2);

INSERT INTO items VALUES('Produit NaN',NULL,3,12);

SELECT *,
  (CASE
    WHEN surcharge>1 THEN 'superieur a 1'
    WHEN surcharge<1 THEN 'inferieur a 1'
    WHEN surcharge=1 THEN 'egale a 1'
	ELSE 'Autre'
  END) AS "Message"
FROM items;








CREATE TABLE candidates(
id INT PRIMARY KEY IDENTITY(1,1),
nom VARCHAR(20)
)
INSERT INTO candidates VALUES('ISSAM'),('CHAIMAE'),('MOHAMMED')

CREATE TABLE Employee(
id INT PRIMARY KEY IDENTITY(1,1),
nom VARCHAR(20)
)
INSERT INTO Employee VALUES('ISSAM'),('CHAIMAE'),('OUSSAMA'),('FARAH')

SELECT * FROM candidates c

SELECT * FROM candidates c,Employee e
WHERE c.nom=e.nom 

SELECT * FROM candidates c INNER JOIN Employee e
ON c.nom = e.nom


CREATE TABLE [USER] (
id INT PRIMARY KEY IDENTITY(1,1),
prenom VARCHAR(20),
nom VARCHAR(20),
email VARCHAR(50),
ville VARCHAR(20)
)
INSERT INTO [USER] VALUES
('Aimee','Marechal','aime.marechal@example.com','Paris'),
('Esmee','Lefort','esmee.lefort@example.com','Lyon'),
('Marine','Presvost','m.prevost@example.com','Lille'),
('Luc','Rolland','lucrolland@example.com','Marseille')

CREATE TABLE COMMANDE(
utilisateur_id INT,
date_achat DATE,
num_facture VARCHAR(10),
prix_total FLOAT,
)
INSERT INTO COMMANDE VALUES
(1,'2013-01-23','A00103',203.14),
(1,'2013-02-14','A00104',124),
(2,'2013-02-17','A00105',149.45),
(2,'2013-02-21','A00106',235.35),
(5,'2013-03-02','A00107',47.58)

SELECT * FROM COMMANDE c INNER JOIN[USER] u
ON c.utilisateur_id=U.id


SELECT * FROM [USER]
SELECT * FROM COMMANDE 


SELECT u.* FROM [USER] u  LEFT JOIN COMMANDE c
ON U.id=c.utilisateur_id
WHERE c.utilisateur_id IS NULL