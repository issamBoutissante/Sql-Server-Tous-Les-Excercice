--Q1

--create or alter proc getCA(@mois int,@anne int,@ca float output)
--as
--begin
--	SELECT @ca=ISNULL(SUM(p.PrixUnitaire*v.Qte),0) FROM Produit p JOIN Vente v
--	ON p.Ref=v.Ref JOIN Commande c ON v.Ncom=c.Ncom
--	WHERE MONTH(c.DateCmd)=@mois 
--	AND YEAR(c.DateCmd)=@anne
--end

declare @c float
exec getCA '03','2022', @c output
print @c

--Q2

DECLARE 
@i int=1, @caOutput float;
declare @monTable table( mois int, ca float);
BEGIN
	WHILE @i<=Month(getdate())
		begin
			EXEC getCA @i,'2022',@caOutput OUTPUT
			insert into @monTable values(@i,@caOutput)
			set @i=@i+1
		END
	select * from @monTable
END



--Q3

CREATE or ALTER PROC getTaux(@ref INT,@taux INT OUTPUT)
AS
--BEGIN
--	SELECT @taux=ISNULL(
--	(
--		SELECT SUM(Qte) from Vente v 
--		WHERE v.Ref=p.Ref) *100/total,0
--	)
--	from Produit p
--	WHERE p.Ref=@ref
--END

--Q4
-- Afficher 

DECLARE 
@tauxOutput float,
@CurrentRef int;
declare @monTable table( ref int, taux float);
DECLARE produit_cursor cursor 
for SELECT Ref from Produit;
BEGIN
	open produit_cursor;
	fetch next from produit_cursor into @CurrentRef;

	while @@FETCH_STATUS=0
	begin
		exec getTaux @CurrentRef,@tauxOutput OUTPUT
		INSERT INTO @monTable VALUES(@CurrentRef,@tauxOutput)
		fetch next from produit_cursor into @CurrentRef;
	end
	close produit_cursor
	select * from @monTable
	DEALLOCATE produit_cursor
END

--Sans Cursor

DECLARE 
@tauxOutput float,
@CurrentRef int,
@numbreLignes int,
@i int=0;
declare @tableTemp table (ref int,taux float)
BEGIN
	--Remplir la table avec les references
	insert into @tableTemp(ref) SELECT ref from Produit
    
	select @numbreLignes=COUNT(1) from @tableTemp

	while @i<@numbreLignes
	begin
		--Recuperer la reference courant
		SELECT @CurrentRef=ref from @tableTemp
		ORDER by Ref
		OFFSET @i ROWS FETCH NEXT 1 ROW ONLY
		--Recuperer le taux de reference courant
		exec getTaux @CurrentRef,@tauxOutput OUTPUT
		update @tableTemp set taux=@tauxOutput
		where ref=@CurrentRef
		set @i=@i+1
	end
	select * from @tableTemp
END



--Calculet le temp
/* Switch on statistics time */
SET STATISTICS TIME ON; 
 DECLARE 
@tauxOutput float,
@CurrentRef int,
@numbreLignes int,
@i int=0;
declare @tableTemp table (ref int,taux float)
BEGIN
	--Remplir la table avec les references
	insert into @tableTemp(ref) SELECT ref from Produit
    
	select @numbreLignes=COUNT(1) from @tableTemp

	while @i<@numbreLignes
	begin
		--Recuperer la reference courant
		SELECT @CurrentRef=ref from @tableTemp
		ORDER by Ref
		OFFSET @i ROWS FETCH NEXT 1 ROW ONLY
		--Recuperer le taux de reference courant
		exec getTaux @CurrentRef,@tauxOutput OUTPUT
		update @tableTemp set taux=@tauxOutput
		where ref=@CurrentRef
		set @i=@i+1
	end
	select * from @tableTemp
END
/* Switch off statistics time */
SET STATISTICS TIME OFF; 
GO