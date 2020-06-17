/* ========================= CREACION DE LOS TRIGGERS ========================= */
USE [PROYECTO_FINAL];
GO
/* ========================= NACIONAL ========================= */
CREATE TRIGGER INSERT_NACIONAL
ON P_Nacional
FOR INSERT
AS
	DECLARE @CODIGO INT;
	SET @CODIGO = (SELECT Codigo FROM INSERTED)
	IF @CODIGO IN (SELECT Codigo FROM P_Internacional)
	BEGIN
		RAISERROR('El Codigo insertado ya existe para un envio Internacional, favor de usar otro.',16,1)
		ROLLBACK TRANSACTION
	END
GO
/* ========================= INTERNACIONAL ========================= */
CREATE TRIGGER INSERT_INTERNACIONAL
ON P_Internacional
FOR INSERT
AS
	DECLARE @CODIGO INT;
	SET @CODIGO = (SELECT Codigo FROM INSERTED)
	IF @CODIGO IN (SELECT Codigo FROM P_Nacional)
	BEGIN
		RAISERROR('El Codigo insertado ya existe para un envio Nacional, favor de usar otro.',16,1)
		ROLLBACK TRANSACTION
	END
GO
/*========================== CAMIÓN ==================================*/
CREATE TRIGGER Peso_Camion
ON Camion
FOR INSERT 
AS
	DECLARE @Peso NUMERIC(7);
	SET @Peso = (SELECT CargaMax FROM INSERTED)
	IF @Peso < 250000
	BEGIN
		RAISERROR('No se pueden dar de alta camiones con cargas menores a 250Kg',16,1)
		ROLLBACK TRANSACTION
	END
	ELSE IF @Peso > 1250000
	BEGIN
		RAISERROR('No se pueden dar de alta camiones con cargas mayores a 1250Kg',16,1)
		ROLLBACK TRANSACTION
	END
GO
/*==================== NACIONAL_REGISTROS==========================*/

CREATE TRIGGER Registro_nac
ON P_Nacional
FOR INSERT
AS
BEGIN
	DECLARE @destino varchar(20), @id numeric, @contador numeric
	SET @destino = (SELECT Ciudad_d FROM inserted)
	SET @id = (SELECT Codigo FROM inserted)
	IF ((SELECT MAX(Registro_ID) FROM Registros WHERE Destino = @destino) IS NULL)
	BEGIN
		INSERT INTO Registros VALUES (@id,@destino,1)
	END
	ELSE
	BEGIN
		SET @contador = (SELECT COUNT(*) FROM Registros WHERE Destino = @destino) + 1
		INSERT INTO Registros VALUES (@id,@destino,@contador)
		UPDATE Registros
		SET Contador = @contador
		WHERE Destino LIKE @destino
	END	
END

