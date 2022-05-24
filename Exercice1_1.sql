CREATE DATABASE exercice1
USE exercice1

CREATE TABLE Produit(
Ref INT PRIMARY KEY,
Designation VARCHAR(20),
PrixUnitaire FLOAT,
Dimension VARCHAR(20),
)
INSERT INTO Produit VALUES(1,'pc',100,'32')
INSERT INTO Produit VALUES(2,'pc',150,'32')
INSERT INTO Produit VALUES(3,'phone',50,'32')
INSERT INTO Produit VALUES(4,'mouse',260,'32')

CREATE TABLE Commande(
Ncom INT PRIMARY KEY,
DateCmd DATE
)
INSERT INTO Commande VALUES(1,GETDATE())
INSERT INTO Commande VALUES(2,GETDATE())
INSERT INTO Commande VALUES(3,DATEADD(YEAR,-1,GETDATE()))
INSERT INTO Commande VALUES(4,DATEADD(MONTH,-2,GETDATE()))
INSERT INTO Commande VALUES(5,DATEADD(MONTH,2,GETDATE()))
INSERT INTO Commande VALUES(6,DATEADD(MONTH,3,GETDATE()))
INSERT INTO Commande VALUES(7,DATEADD(MONTH,6,GETDATE()))
INSERT INTO Commande VALUES(8,DATEADD(MONTH,3,GETDATE()))
INSERT INTO Commande VALUES(9,GETDATE())

CREATE TABLE Vente(
Ncom INT FOREIGN KEY REFERENCES Commande(Ncom),
Ref INT FOREIGN KEY REFERENCES Produit(Ref),
Qte INT,
DateLiv DATE,
PRIMARY KEY(Ncom,Ref)
)
INSERT INTO Vente VALUES(1,1,5,GETDATE())
INSERT INTO Vente VALUES(2,1,10,GETDATE())
INSERT INTO Vente VALUES(3,2,4,DATEADD(YEAR,-1,GETDATE()))
INSERT INTO Vente VALUES(4,2,8,GETDATE())
INSERT INTO Vente VALUES(4,1,8,GETDATE())
INSERT INTO Vente VALUES(5,1,8,GETDATE())
INSERT INTO Vente VALUES(6,1,8,GETDATE())
INSERT INTO Vente VALUES(7,1,8,GETDATE())
INSERT INTO Vente VALUES(7,2,8,GETDATE())
CREATE TABLE Produit_Concurrent(
Ref INT PRIMARY KEY,
Designation VARCHAR(20),
PrixUnitaire FLOAT,
Dimension VARCHAR(20),
Nom_Concurrent VARCHAR(20)
)



-- 1
SELECT mois.numero,ISNULL((
	SELECT SUM(p.PrixUnitaire*v.Qte) FROM Produit p JOIN Vente v
	ON p.Ref=v.Ref JOIN Commande c
	ON v.Ncom=c.Ncom
	WHERE MONTH(c.DateCmd)=mois.numero 
	AND YEAR(c.DateCmd)=YEAR(GETDATE())
)
,0) Total
FROM 
(VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12))
mois(numero)
WHERE mois.numero<=MONTH(GETDATE())


-- 2
--  total =>100
--  vendu =>taux
--  taux =>vendu*100/total

SELECT Designation, ISNULL(
(
	SELECT SUM(Qte) from Vente v 
	WHERE v.Ref=p.Ref) *100/total,0
) taux
from Produit p

--With Joins

SELECT p.Ref,(sum(v.Qte)*100)/avg(total) taux from Produit p JOIN Vente v
on p.Ref=v.Ref
GROUP BY p.Ref






-- 3

select top 1 v.Ref,SUM(v.Qte) totalVendu from Vente v
where MONTH(v.DateLiv)=MONTH(GETDATE()) and
year(v.DateLiv)=year(GETDATE())
GROUP BY v.Ref
ORDER by totalVendu desc



--  4



insert into Produit(Ref,Designation,PrixUnitaire) 
select Ref,Designation,PrixUnitaire from Produit_Concurrent
where Nom_Concurrent='GleenAlu'









