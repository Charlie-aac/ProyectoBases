/* ========================= PRUEBAS ========================= */
USE PROYECTO_FINAL

/* ========================= CONSULTA TABLAS ========================= */
SELECT * FROM Ruta
SELECT * FROM Conductor
SELECT * FROM Camion
SELECT * FROM C_local
SELECT * FROM Paquete
SELECT * FROM P_Internacional
SELECT * FROM P_Nacional
SELECT * FROM Registros
SELECT * FROM Ruta_Conductor_Camion

/* ==================== PROCESOS ALMACENADOS ==================== */
EXEC SP_InformacionEnvio 2

/* ==================== INSERCION DE TABLAS ==================== */

-- Datos Camiones
INSERT INTO Camion VALUES ('ABC123',1000000,'CDMX')
INSERT INTO Camion VALUES ('DEF456',1000000,'CDMX')
INSERT INTO Camion VALUES ('GHI789',1000000,'CDMX')

-- Datos Conductor
INSERT INTO Conductor VALUES ('ABCDEFGHIJK12','Luis','Calle 1')
INSERT INTO Conductor VALUES ('CJDISKDIALKOS','Fernando','Calle 2')
INSERT INTO Conductor VALUES ('SKDOPTISLZXMP','Pedro','Calle 3')
INSERT INTO Conductor VALUES ('PHAEPLQÑAK9DJ','Superman','Calle 4')

-- Datos Ruta
INSERT INTO Ruta VALUES (1,'CDMX - Yucatan')
INSERT INTO Ruta VALUES (2,'Oaxaca - Edo. Mexico')
INSERT INTO Ruta VALUES (3,'Aguascalientes - Puebla')
INSERT INTO Ruta VALUES (4,'Sinaloa - Chihuhua')

-- Datos Ruta Conductor Camion
INSERT INTO Ruta_Conductor_Camion VALUES (000001,'ABCDEFGHIJK12','ABC123',GETDATE(),1,1000000,1)
INSERT INTO Ruta_Conductor_Camion VALUES (000002,'CJDISKDIALKOS','DEF456',GETDATE(),2,1000000,0)
INSERT INTO Ruta_Conductor_Camion VALUES (000003,'SKDOPTISLZXMP','GHI789',GETDATE(),3,1000000,0)

-- Datos Paquetes
INSERT INTO Paquete VALUES (1,'Direccion 1',500,'Juan','N')
INSERT INTO Paquete VALUES (2,'Direccion 2',1000,'Pedro','N')
INSERT INTO Paquete VALUES (3,'Direccion 3',2000,'Pepe','N')
INSERT INTO Paquete VALUES (4,'Direccion 4',2500,'Papa','N')
INSERT INTO Paquete VALUES (5,'Direccion 5',3500,'Pupu','N')
INSERT INTO Paquete VALUES (6,'Direccion 1',1000,'Juan','I')
INSERT INTO Paquete VALUES (7,'Direccion 2',2000,'Juanito','I')
INSERT INTO Paquete VALUES (8,'Direccion 3',3000,'Juanote','I')
INSERT INTO Paquete VALUES (9,'Direccion 4',4000,'Paco','N')

-- Datos Paquete Nacional
INSERT INTO P_Nacional VALUES (1,'Oaxaca',1)
INSERT INTO P_Nacional VALUES (2,'Sinaloa',2)
INSERT INTO P_Nacional VALUES (3,'CDMX',3)
INSERT INTO P_Nacional VALUES (4,'Yucatan',2)
INSERT INTO P_Nacional VALUES (5,'Quintana Roo',1)

-- Datos C_Local
INSERT INTO C_local VALUES (1,'Nombre 1')
INSERT INTO C_local VALUES (2,'Nombre 2')
INSERT INTO C_local VALUES (3,'Nombre 3')

-- Datos Paquete Internacional
INSERT INTO P_Internacional VALUES (6,'AeroMex',GETDATE(),1)
INSERT INTO P_Internacional VALUES (7,'AeroMex',GETDATE(),3)
INSERT INTO P_Internacional VALUES (8,'AeroMex',GETDATE(),2)

/* ====================== OTRAS PRUEBAS ====================== */

-- Nuevos Camiones
EXEC SP_AltaCamion 'ABC123',1000000,'CDMX' 
EXEC SP_AltaCamion 'DEF456',1000000,'CDMX'
EXEC SP_AltaCamion 'GHI789',1000000,'CDMX'

-- Nuevos Conductres
EXEC SP_AltaConductor 'ABCDEFGHIJK12','Luis','Calle 1'
EXEC SP_AltaConductor 'CJDISKDIALKOS','Fernando','Calle 2'
EXEC SP_AltaConductor 'SKDOPTISLZXMP','Pedro','Calle 3'
EXEC SP_AltaConductor 'PHAEPLQÑAK9DJ','Superman','Calle 4'

-- Nuevo Paquete Nacional
EXEC SP_NuevoPaqueteNacional 'Juan', 'Direccion 1', 'Oaxaca', 500
EXEC SP_NuevoPaqueteNacional 'Pedro', 'Direccion 2', 'Sinaloa', 1000
EXEC SP_NuevoPaqueteNacional 'Pepe', 'Direccion 3', 'CDMX', 2000
EXEC SP_NuevoPaqueteNacional 'Papa', 'Direccion 4', 'Yucatan', 2500
EXEC SP_NuevoPaqueteNacional 'Pupu', 'Direccion 5', 'Quintana Roo', 3500
EXEC SP_NuevoPaqueteNacional 'Paco', 'Direccion 6', 'Guerrero', 4000

-- Nuevo Paquete Internacional
EXEC SP_NuevoPaqueteInternacional 'Juan', 'Direccion 1', 'AeroMex', 1000, 'Nombre 1'
EXEC SP_NuevoPaqueteInternacional 'Juanito', 'Direccion 2', 'AeroMex', 2000, 'Nombre 2'
EXEC SP_NuevoPaqueteInternacional 'Juanote', 'Direccion 3', 'AeroMex', 3000, 'Nombre 3'

-- Asignacion

EXEC SP_Asignacion

/* ====================== PRUEBAS TRIGGER ====================== */

-- Camion
INSERT INTO Camion VALUES ('DEFr6',999999,'CDMX')
INSERT INTO Camion VALUES ('GHIf89',50000,'CDMX')

-- Registro
INSERT INTO P_Nacional VALUES (9,'Rufino Tamayo',null)

/* ====================== BORRAR REGISTROS DE TABLAS ====================== */
DELETE Registros
DELETE P_Nacional
DELETE P_Internacional
DELETE Paquete
DELETE Ruta_Conductor_Camion
DELETE Ruta
DELETE Camion
DELETE C_local
DELETE Conductor
