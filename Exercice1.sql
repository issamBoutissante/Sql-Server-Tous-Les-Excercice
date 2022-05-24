DECLARE @FAC BIGINT,@I INT;
BEGIN
    SELECT @FAC=1 ,@I=14
	WHILE(@I>1)
		BEGIN
			SELECT @FAC=@FAC*@I
			SET @I=@I-1
		END
	IF(@FAC>100000)
		PRINT('FACTORIELLE DEPASSE LE SEUIL')
	ELSE
		PRINT CONCAT('FACTORIELLE DE NOMBRE 14 EST : ',@FAC)
END








/*
-- Q1
DECLARE @listNombres TABLE(Nombre INT)
DECLARE @Max INT,@Min INT
BEGIN
	INSERT INTO @listNombres VALUES(1),(3),(5)
	select @Max=Max(Nombre),@Min=Min(Nombre) from @listNombres
	PRINT CONCAT('- Max est : ',@Max)
	PRINT CONCAT('- Min est : ',@Min)
END

--Q2
DECLARE @resultat int,@nombre int,@puissance int
BEGIN
	select @nombre=3,@puissance=3
	select @resultat=POWER(@nombre,@puissance)
	PRINT CONCAT(@nombre,'^',@puissance,'=',@resultat)
END


--Q3

DECLARE @resultat int,@N int,@nombre int
BEGIN
	select @N=6,@resultat=1,@nombre=2
	WHILE @N>0
		BEGIN
			SET @resultat=@resultat+POWER(@nombre,@N)
			SET @N=@N-1
		END
	PRINT @resultat
END
*/







--Q4

DECLARE
@mot varchar(20)
BEGIN
	SET @mot='LOLL'
	if @mot=REVERSE(@mot)
		print concat(@mot,' est un palindrome')
	else
	    print concat(@mot,' pas palindrome')

END









--Q5

DECLARE
	@a int,
	@b int,
	@c int,




