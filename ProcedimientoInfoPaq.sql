/* ========================= CREACION DE PROCESOS ALMACENADOS ========================= */
USE PROYECTO_FINAL
GO
/* ========================= SP_InformacionEnvio ========================= */
CREATE PROCEDURE SP_InformacionEnvio(@CODIGO INT) AS
BEGIN
	IF @CODIGO IN (SELECT Codigo FROM P_Nacional)
		SELECT N.Codigo, Tipo='Nacional', P.Direccion, P.Peso_gramos AS Peso, C.Nombre AS Conductor, R.Descripcion AS Ruta, RCC.Placa AS [Placa del Camion],RCC.Fecha AS Fecha FROM P_Nacional N
		JOIN Ruta_Conductor_Camion RCC ON RCC.id_RCC=N.id_RCC
		JOIN Conductor C ON RCC.RFC=C.RFC
		JOIN Ruta R ON R.Ruta_id=RCC.Ruta_id
		JOIN Paquete P ON P.Codigo=N.Codigo
		WHERE N.Codigo=@CODIGO;
	ELSE
	BEGIN
		IF @CODIGO IN (SELECT Codigo FROM P_Internacional)
			SELECT I.Codigo, Tipo='Internacional', I.LineaAerea, I.Codigo_local FROM P_Internacional I;
		ELSE
			PRINT('El codigo no esta registrada para envio nacional o internacional, favor de ingresar un codigo valido.');
	END
END
GO
/* ========================= SP_AltaCamion ========================= */
/* ==================== Placas | Peso | Locacion ==================== */

CREATE PROCEDURE SP_AltaCamion (@placas varchar(6), @peso numeric, @locacion varchar(25)) AS
BEGIN
	INSERT INTO Camion VALUES (@placas,@peso,@locacion)
END
GO
/* ========================= SP_AltaConductor ========================= */
/* ====================== RFC | Nombre | Direccion ====================== */

CREATE PROCEDURE SP_AltaConductor (@rfc varchar(13), @nombre varchar(25), @direccion varchar(50)) AS 
BEGIN
	INSERT INTO Conductor VALUES (@rfc,@nombre,@direccion)
END
GO
/* ========================= SP_CrearRuta ========================= */
/* =========================== Destino =========================== */

CREATE PROCEDURE SP_CrearRuta (@descripcion varchar(50)) AS
BEGIN
	DECLARE @id numeric
	SET @id = (SELECT MAX(Ruta_id) FROM Ruta) + 1
	IF (@id IS NULL)
	BEGIN
		SET @id = 1
	END
	INSERT INTO Ruta VALUES (@id,@descripcion)
END
GO
/* ========================= SP_NuevoPaqueteNacional ========================= */
/* =============== Destinatario | Direccion | Ciudad | Peso(g) =============== */

CREATE PROCEDURE SP_NuevoPaqueteNacional (@destinatario varchar(50), @direccion varchar(50), @ciudad varchar(25), @peso numeric) AS
BEGIN
	DECLARE @id numeric
	SET @id = (SELECT MAX(Codigo) FROM Paquete) + 1
	IF (@id IS NULL)
	BEGIN
		SET @id = 1
	END
	INSERT INTO Paquete VALUES (@id,@direccion,@peso,@destinatario,'N')
	INSERT INTO P_Nacional VALUES (@id,@ciudad,NULL)
END
GO
/* ========================= SP_NuevoPaqueteInternacional ========================= */
/* ============== Destinatario | Direccion | Aerolinea | Peso | Nombre ============== */

CREATE PROCEDURE SP_NuevoPaqueteInternacional (@destinatario varchar(50), @direccion varchar(50), @lineaAerea varchar(25), @peso numeric, @nombre varchar(50)) AS
BEGIN
	DECLARE @id numeric, @id_Local numeric
	SET @id = (SELECT MAX(Codigo) FROM Paquete) + 1
	IF (@id IS NULL)
	BEGIN
		SET @id = 1
	END
	SET @id_Local = (SELECT MAX(Codigo) FROM C_local) + 1
	IF (@id_Local IS NULL)
	BEGIN
		SET @id_Local = 1
	END
	INSERT INTO Paquete VALUES (@id ,@direccion,@peso,@destinatario,'I')
	INSERT INTO C_local VALUES (@id_Local,@nombre)
	INSERT INTO P_Internacional VALUES (@id,@lineaAerea,GETDATE(),@id_Local)
END
GO
/* ========================= SP_RCC ========================= */
/* ================ RFC | PLACA | PESO | RUTA ================ */

CREATE PROCEDURE SP_RCC (@rfc varchar(13),@placa varchar(6),@peso numeric, @ruta numeric) AS
BEGIN
	DECLARE @id numeric
	SET @id = (SELECT MAX(id_RCC) FROM Ruta_Conductor_Camion) + 1
	IF (@id IS NULL)
	BEGIN
		SET @id = 1
	END
	INSERT INTO Ruta_Conductor_Camion VALUES (@id,@rfc,@placa,GETDATE(),@ruta,@peso,1)
END
GO








/* ========================= SP_Asignacion ========================= */

ALTER PROCEDURE SP_Asignacion AS
BEGIN
	DECLARE @codigo numeric, @destino varchar(25), @peso numeric, @id_Ruta numeric, @id_RCC numeric
	-- Cursos para recorrer todos lo paquetes nacionales que no tienen asignado una ruta
	DECLARE paquetes CURSOR FOR SELECT Paquete.Codigo,Ciudad_d,Peso_gramos FROM P_Nacional JOIN Paquete ON P_Nacional.Codigo = Paquete.Codigo WHERE id_RCC IS NULL
	OPEN paquetes
	FETCH NEXT FROM paquetes INTO @codigo, @destino, @peso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Preguntamos si existe ese destino, en caso de que no lo creamos y el id lo guardamos en @id_Ruta
		IF ((SELECT Ruta_id FROM Ruta WHERE Descripcion LIKE @destino) IS NULL)
		BEGIN
			EXEC SP_CrearRuta @destino
		END
		SET @id_Ruta = (SELECT Ruta_id FROM Ruta WHERE Descripcion LIKE @destino)
		--Preguntamos si existe alguna ruta creada con conductor y camion, y que este activa para salir
		IF ((SELECT id_RCC FROM Ruta_Conductor_Camion WHERE Ruta_id = @id_Ruta AND activo = 1) IS NOT NULL)
		BEGIN
			-- Si existe ruta activa le asignamos el paquete si hay espacio en el camion
			IF ((SELECT peso FROM Ruta_Conductor_Camion WHERE Ruta_id = @id_Ruta) > @peso)
			BEGIN
				SET @id_RCC = (SELECT id_RCC FROM Ruta_Conductor_Camion WHERE Ruta_id = @id_Ruta)
				UPDATE P_Nacional
				SET id_RCC = @id_RCC
				WHERE Codigo = @codigo
				UPDATE Ruta_Conductor_Camion
				SET peso = peso - @peso
				WHERE id_RCC = @id_RCC
			END
		END
		-- En el caso de que no la creamos
		ELSE
		BEGIN
			-- La creamos si y solo si hay un camion disponible y un conductor disponible
			IF ((SELECT MAX(Conductor.RFC) FROM Ruta_Conductor_Camion RIGHT JOIN Conductor ON Ruta_Conductor_Camion.RFC = Conductor.RFC WHERE id_RCC IS NULL OR activo = 0 AND Conductor.RFC != ALL(SELECT RFC FROM Ruta_Conductor_Camion WHERE activo = 1)) IS NOT NULL
			AND (SELECT MAX(Camion.Placa) FROM Ruta_Conductor_Camion RIGHT JOIN Camion ON Ruta_Conductor_Camion.Placa = Camion.Placa WHERE id_RCC IS NULL OR activo = 0 AND Camion.Placa != ALL(SELECT Placa FROM Ruta_Conductor_Camion WHERE activo = 1)) IS NOT NULL)
			BEGIN
				DECLARE @rfc varchar(13), @placa varchar(6), @pesoCamion numeric
				SET @rfc = (SELECT MAX(Conductor.RFC) FROM Conductor LEFT JOIN Ruta_Conductor_Camion
							ON Conductor.RFC = Ruta_Conductor_Camion.RFC
							WHERE activo IS NULL OR activo = 0 AND Conductor.RFC != ALL(SELECT RFC FROM Ruta_Conductor_Camion WHERE activo = 1))
				SET @placa = (	SELECT MAX(Camion.Placa) FROM Camion LEFT JOIN Ruta_Conductor_Camion
								ON Camion.Placa = Ruta_Conductor_Camion.Placa
								WHERE activo IS NULL OR activo = 0 AND Camion.Placa != ALL(SELECT Placa FROM Ruta_Conductor_Camion WHERE activo = 1))
				SET @pesoCamion = (	SELECT CargaMax FROM Camion
									WHERE Placa = @placa)
				EXEC SP_RCC @rfc, @placa, @pesoCamion, @id_Ruta
			END
			-- Una vez creado asignamos el paquete al camion
			IF ((SELECT peso FROM Ruta_Conductor_Camion WHERE Ruta_id = @id_Ruta) > @peso)
			BEGIN
				SET @id_RCC = (SELECT id_RCC FROM Ruta_Conductor_Camion WHERE Ruta_id = @id_Ruta)
				UPDATE P_Nacional
				SET id_RCC = @id_RCC
				WHERE Codigo = @codigo
				UPDATE Ruta_Conductor_Camion
				SET peso = peso - @peso
				WHERE id_RCC = @id_RCC
			END
		END
		FETCH NEXT FROM paquetes INTO @codigo, @destino, @peso
	END
	CLOSE paquetes
	DEALLOCATE paquetes
	UPDATE Ruta_Conductor_Camion
	SET activo = 0
END
