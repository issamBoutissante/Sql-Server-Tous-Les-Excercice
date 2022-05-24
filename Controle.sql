CREATE DATABASE banque 
GO
USE banque
GO
CREATE SCHEMA gestion
GO
-- 5- Créer les tables du MCD. (Dans Le shema gestion)

CREATE TABLE gestion.clients(
	num_client INT PRIMARY KEY,
	nom_client VARCHAR(15),
	adresse_client VARCHAR(30),
	mot_de_passe VARCHAR(10),
	date_derniere_consultation DATE,
	secteur INT
)
--table TYPE_COMPTE
CREATE TABLE gestion.type_compte(
	type_compte VARCHAR(3) PRIMARY KEY,
	intitule_compte VARCHAR(20)
)

-- table COMPTES
CREATE TABLE gestion.comptes(
	num_compte int primary key,
	libelle_compte VARCHAR(20),
	date_commande_chequier DATE,
	solde_compte numeric(10,2),
	decouvert_autorise numeric(8,2),
	num_client INT FOREIGN KEY REFERENCES gestion.clients(num_client),
	type_compte VARCHAR(3) FOREIGN KEY REFERENCES gestion.type_compte(type_compte)
)
--table TYPE_OPERATION
CREATE TABLE gestion.type_operation(
	type_operation VARCHAR(10) PRIMARY KEY
)
--table OPERATIONS
CREATE TABLE gestion.operations(
	num_operation INT PRIMARY KEY,
	libelle_operation VARCHAR(20),
	montant_operation NUMERIC(8,2),
	date_operation DATE,
	num_compte INT FOREIGN KEY REFERENCES gestion.comptes(num_compte),
	type_operation VARCHAR(10) FOREIGN KEY REFERENCES gestion.type_operation(type_operation)
)

--6- Insérer un jeu d’essai avec des textes significatifs.

INSERT INTO gestion.clients VALUES
(1,'Boutissante','ait ourir','12345',DATEADD(MONTH,-3,GETDATE()),11),
(2,'Ahrouch','ait abdeslam','52342',DATEADD(YEAR,-1,GETDATE()),11),
(3,'Mchkih','ait zyad','5234',DATEADD(DAY,-10,GETDATE()),11)

INSERT INTO gestion.type_compte VALUES
('ccr','compte courant'),('cep','compte epargne'),('ctr','compte-titres')

INSERT INTO gestion.comptes VALUES
(1,'compte1',DATEADD(MONTH,-10,GETDATE()),2000,500,2,'ccr'),
(2,'compte2',DATEADD(DAY,-30,GETDATE()),5500,1100,1,'cep'),
(3,'compte3',DATEADD(MONTH,-2,GETDATE()),500,100,3,'ctr')

INSERT INTO  gestion.type_operation VALUES('virement'),('retrait')

INSERT INTO gestion.operations VALUES
(1,'operation1',100.30,DATEADD(MONTH,-2,GETDATE()),1,'virement'),
(2,'operation2',400,DATEADD(MONTH,-10,GETDATE()),1,'retrait'),
(3,'operation3',100,DATEADD(MONTH,-3,GETDATE()),2,'virement'),
(4,'operation4',100,DATEADD(MONTH,-1,GETDATE()),3,'retrait')



--    Partie II : Procédures


-- 1- Créer la procédure ou fonction AJOUT_CLIENT qui permet
-- l’insertion d’un nouveau client dans la table CLIENTS.

create procedure AJOUT_CLIENT (  	@num_client int,	@nom_client varchar(15),	@adresse_client VARCHAR(30),	@mot_de_passe VARCHAR(10),	@date_derniere_consultation DATE,	@secteur int)asBegin	insert into gestion.clients values	(@num_client,@nom_client,@adresse_client,@mot_de_passe,@date_derniere_consultation,@secteur)Endexec AJOUT_CLIENT 4,'Abram','ait ourir','2432','2022-03-02',30


-- 2- Créer la procédure ou fonction AJOUT_COMPTES qui permet l’insertion du nouveau
-- compte dans la table COMPTES

create procedure AJOUT_COMPTE (  	@num_compte int,	@libelle_compte VARCHAR(20),	@date_commande_chequier DATE,	@solde_compte numeric(10,2),	@decouvert_autorise numeric(8,2),	@num_client int,	@type_compte VARCHAR(3))asBegin	insert into gestion.comptes values(@num_compte,@libelle_compte,@date_commande_chequier,@solde_compte,@decouvert_autorise,@num_client,@type_compte)Endexec AJOUT_COMPTE 4,'compte4','2022-04-20',5000,2000,1,'ccr'

-- 3- Créer la procédure ou fonction AJOUT_OPERATIONS qui permet de débiter au de
-- créditer le compte. Plusieurs exceptions sont à considérer pour cette procédure (exp :
-- Num_compte inconnu, Type_operation inconnu, test sur decouvert_autorise de la table
-- COMPTES …).

CREATE OR ALTER PROCEDURE AJOUT_OPERATION(
	@num_operation INT ,
	@libelle_operation VARCHAR(20),
	@montant_operation NUMERIC(8,2),
	@num_compte INT,
	@type_operation VARCHAR(10)
)
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		--validation de numero de compte
		IF @num_compte not in (select num_compte from gestion.comptes)
		BEGIN
			RAISERROR('Num_compte inconnu',16,1);
		END
		IF @type_operation not in (SELECT type_operation from gestion.type_operation)
		BEGIN
			RAISERROR('Type_operation inconnu',16,1);
		END
		--si l'operation est virement
		IF @type_operation='virement'
			BEGIN
				UPDATE gestion.comptes SET solde_compte=(solde_compte+@montant_operation)
				WHERE num_compte=@num_compte
			END
		ELSE --si l'operation est retrait
			BEGIN
				DECLARE @solde NUMERIC(10,2),@decouvert NUMERIC(8,2)
				select @solde=solde_compte,@decouvert=decouvert_autorise 
				from gestion.comptes WHERE num_compte=@num_compte
			
				IF @montant_operation <=@solde
					BEGIN
						UPDATE gestion.comptes SET solde_compte=(solde_compte-@montant_operation)
						WHERE num_compte=@num_compte
					END
				ELSE --on vas ajouter le decouvert a le solde
					BEGIN
						--si le montant < (solde+decouvert)
						if @montant_operation <=(@solde+@decouvert)
							BEGIN
								DECLARE @updatedDecouvert NUMERIC(10,2);
								set @updatedDecouvert=((@solde+@decouvert)-@montant_operation);
								update gestion.comptes set solde_compte=0,
									 decouvert_autorise=@updatedDecouvert
								WHERE num_compte=@num_compte;
							END
						ELSE
							BEGIN
								RAISERROR('Argent pas suffissante',16,1);
							END
					END
			END
		INSERT INTO gestion.operations VALUES(@num_operation,@libelle_operation,@montant_operation,GETDATE(),@num_compte,@type_operation)
		COMMIT --si tous est bien pass
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK
	END CATCH
END

select * from gestion.comptes

EXEC AJOUT_OPERATION 11,'test',2000,1,'virement'



-- 4- Créer la procédure ou fonction VIREMENT qui permet d’effectuer une transaction
-- entre 2 comptes. Cette procédure doit gérer aussi les logs des opérations selon leurs
-- types et de mettre à jour le solde des 2 comptes considérés. Plusieurs exceptions sont à
-- considérer pour cette procédure (exp : Num_compte inconnu, test sur
-- decouvert_autorise de la table COMPTES …).

CREATE or ALTER PROCEDURE gestion.VIREMENT(	@compteDebiteur int,	@compteCrediteur int,	@montant NUMERIC(8,2),	@libelle_operation VARCHAR(20))ASBEGIN	DECLARE @lastOperationNumber int,@solde NUMERIC(10,2),@decouvert NUMERIC(8,2)	-- On peut utiliser l'identity pour auto incrementer	select @lastOperationNumber=MAX(num_operation) from gestion.operations	-- test si le solde de debiteur est suffissant	select @solde=solde_compte,@decouvert=decouvert_autorise 				from gestion.comptes WHERE num_compte=@compteDebiteur	IF @montant>(@solde+@decouvert)		BEGIN		  print'Solde insifusant'		END	ELSE		BEGIN			DECLARE @debiteurOperation int=(@lastOperationNumber+1)			EXEC AJOUT_OPERATION @debiteurOperation,@libelle_operation,@montant,@compteDebiteur,'retrait'						DECLARE @crediteurOperation int=(@lastOperationNumber+2)			EXEC AJOUT_OPERATION @crediteurOperation,@libelle_operation,@montant,@compteCrediteur,'virement'		ENDENDSELECT * from gestion.comptesSELECT * from gestion.operationsEXEC VIREMENT 2,1,500,'2=>1 (500)'-- 5- Créer la procédure ou fonction RELEVE_COMPTE qui permet l’affichage (facile à
-- lire) de toutes les informations utiles du compte.

create or alter function gestion.RELEVE_COMPTE(@num_compte int)
returns table
AS
return 
	SELECT clt.num_client,clt.nom_client,MIN(o.date_operation) Depuis,MAX(o.date_operation) Jusqua,
	o.date_operation,o.libelle_operation,cpt.libelle_compte,
	CASE
		WHEN o.type_operation = 'virement' THEN convert(varchar(20),o.montant_operation)
		ELSE ''
	END AS Debit,
	CASE
		WHEN o.type_operation = 'retrait' THEN convert(varchar(20),o.montant_operation)
		ELSE ''
	END AS Credit
	from gestion.comptes cpt join gestion.clients clt on cpt.num_client=clt.num_client
	join gestion.type_compte tc on tc.type_compte=cpt.type_compte
	join gestion.operations o on o.num_compte=cpt.num_compte
	WHERE cpt.num_compte=@num_compte
	GROUP BY
	clt.num_client,clt.nom_client,o.date_operation,o.libelle_operation,
	cpt.libelle_compte,o.type_operation,o.montant_operation

select * from gestion.RELEVE_COMPTE(1)

EXEC AJOUT_OPERATION 20,'test2',2000,1,'virement'