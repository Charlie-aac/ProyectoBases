/* ========================= CREACION DE LA BASE Y SUS TABLAS ========================= */
CREATE DATABASE PROYECTO_FINAL;
GO
USE [PROYECTO_FINAL]
CREATE TABLE Camion(
    Placa			varchar(6),
    CargaMax		numeric(7),
    CiudadRes		varchar(25),

    CONSTRAINT PK_Camion PRIMARY KEY (Placa)
);
GO
CREATE TABLE Ruta(
    Ruta_id			numeric(2),
    Descripcion		varchar(50),

    CONSTRAINT PK_Ruta PRIMARY KEY (Ruta_id),
    CONSTRAINT CK_Ruta_id CHECK (Ruta_id BETWEEN 1 AND 10)
);
GO
CREATE TABLE Conductor(
    RFC				varchar(13),
    Nombre			varchar(25),
    Direccion		varchar(50),

    CONSTRAINT PK_Conductor PRIMARY KEY (RFC)
);
GO
CREATE TABLE Ruta_Conductor_Camion(
    id_RCC			numeric(6),
    RFC				varchar(13),
    Placa			varchar(6),
    Fecha			date CONSTRAINT DF_CC DEFAULT getdate(),
    Ruta_id			numeric(2),

    CONSTRAINT PK_CC PRIMARY KEY (id_RCC),
    CONSTRAINT FK_Con FOREIGN KEY (RFC)
    REFERENCES Conductor (RFC) ON UPDATE cascade,
    CONSTRAINT FK_Cam FOREIGN KEY (Placa)
    REFERENCES Camion(Placa) ON UPDATE cascade,
    CONSTRAINT FK_Ruta FOREIGN KEY (Ruta_id)
    REFERENCES Ruta (Ruta_id) ON UPDATE cascade
);
GO
CREATE TABLE C_local(
    Codigo			numeric(5),
    Nombre			varchar(50),

    CONSTRAINT PK_CLocal PRIMARY KEY (Codigo)
);
GO
CREATE TABLE Paquete(
    Codigo		  	numeric(5),
    Direccion		varchar(50),
    Peso_gramos		numeric(6),
    Destinatario	varchar(50),
    Tipo			char(1),

    CONSTRAINT PK_Paquete PRIMARY KEY (Codigo),
    CONSTRAINT CK_Tipo CHECK(Tipo IN ('N','I'))
);
GO
CREATE TABLE P_Nacional(
    Codigo			numeric(5),
    Ciudad_d		varchar(25),
    id_RCC			numeric(6),

    CONSTRAINT PK_Nacional PRIMARY KEY (Codigo),
    CONSTRAINT FK_Nac_RCC FOREIGN KEY (id_RCC)
    REFERENCES Ruta_Conductor_Camion (id_RCC),
    CONSTRAINT FK_NAC_PAQ FOREIGN KEY (Codigo)
    REFERENCES Paquete(Codigo)

);
GO
CREATE TABLE Registros(
	Registro_ID 	numeric(5),
	Destino 		varchar(40),

	CONSTRAINT PK_Registros PRIMARY KEY (Registro_ID),
	CONSTRAINT FK_REG_NAC FOREIGN KEY (Registro_ID)
    REFERENCES P_Nacional(Codigo)
);
GO
CREATE TABLE P_Internacional(
    Codigo			  numeric(5),
    LineaAerea		varchar(25),
    F_Entrega		  date,
    Codigo_local	numeric(5),

    CONSTRAINT PK_Internacional PRIMARY KEY (Codigo),
    CONSTRAINT FK_Int_Loc FOREIGN KEY (Codigo_local)
    REFERENCES C_local (Codigo) ON UPDATE cascade,
    CONSTRAINT FK_INT_PAQ FOREIGN KEY (Codigo)
    REFERENCES Paquete(Codigo)
);

--USE master
--DROP DATABASE PROYECTO_FINAL;
