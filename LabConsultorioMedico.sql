CREATE DATABASE LabConsultorioMedico;
GO
USE [master]
GO
CREATE LOGIN [usrconsultoriomedico] WITH PASSWORD = N'123456',
	DEFAULT_DATABASE = [LabConsultorioMedico],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = ON
GO
USE [LabConsultorioMedico]
GO
CREATE USER [usrconsultoriomedico] FOR LOGIN [usrconsultoriomedico]
GO
ALTER ROLE [db_owner] ADD MEMBER [usrconsultoriomedico]
GO

DROP TABLE HistorialClinico;
DROP TABLE Pago;
DROP TABLE Cita;
DROP TABLE Usuario;
DROP TABLE Doctor;
DROP TABLE Paciente;
DROP TABLE Especialidad;

CREATE TABLE Especialidad (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Paciente (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  cedulaIdentidad VARCHAR(12) NOT NULL,
  nombres VARCHAR(30) NOT NULL,
  primerApellido VARCHAR(30) NULL,
  segundoApellido VARCHAR(30) NULL,
  fechaNacimiento DATE NOT NULL,
  direccion VARCHAR(250) NOT NULL,
  celular BIGINT NOT NULL
);

CREATE TABLE Doctor (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idEspecialidad INT NOT NULL,
  cedulaIdentidad VARCHAR(12) NOT NULL,
  nombres VARCHAR(30) NOT NULL,
  primerApellido VARCHAR(30) NULL,
  segundoApellido VARCHAR(30) NULL,
  direccion VARCHAR(250) NOT NULL,
  celular BIGINT NOT NULL,
  CONSTRAINT fk_Doctor_Especialidad FOREIGN KEY(idEspecialidad) REFERENCES Especialidad(id)
);

CREATE TABLE Usuario (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idDoctor INT NOT NULL,
  usuario VARCHAR(20) NOT NULL,
  clave VARCHAR(250) NOT NULL,
  CONSTRAINT fk_Usuario_Doctor FOREIGN KEY(idDoctor) REFERENCES Doctor(id)
);

CREATE TABLE Cita (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idDoctor INT NOT NULL,
  idPaciente INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  CONSTRAINT fk_Cita_Doctor FOREIGN KEY(idDoctor) REFERENCES Doctor(id),
  CONSTRAINT fk_Cita_Paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(id)
);

CREATE TABLE Pago (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idCita INT NOT NULL,
  concepto VARCHAR(200) NOT NULL,
  monto INT NOT NULL,
  cambio INT,
  fecha DATE NOT NULL DEFAULT GETDATE(),
  CONSTRAINT fk_Pago_Cita FOREIGN KEY(idCita) REFERENCES Cita(id)
);

CREATE TABLE HistorialClinico (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idPaciente INT NOT NULL,
  idCita INT NOT NULL,
  diagnostico VARCHAR(250) NOT NULL,
  tratamiento VARCHAR(250) NOT NULL,
  fecha DATE NOT NULL DEFAULT GETDATE(),
  CONSTRAINT fk_HistorialClinico_Paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(id),
  CONSTRAINT fk_HistorialClinico_Cita FOREIGN KEY(idCita) REFERENCES Cita(id)
);

ALTER TABLE Especialidad ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Especialidad ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Especialidad ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE Paciente ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Paciente ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE PAciente ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE Doctor ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Doctor ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Doctor ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE Usuario ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Usuario ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Usuario ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE Cita ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Cita ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Cita ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE Pago ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Pago ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Pago ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

ALTER TABLE HistorialClinico ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE HistorialClinico ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE HistorialClinico ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

GO
ALTER PROC paEspecialidadListar @parametro VARCHAR(100)
AS
  SELECT * FROM Especialidad
  WHERE estado<>-1 AND nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY estado DESC, nombre ASC;

GO
ALTER PROC paPacienteListar @parametro VARCHAR(100)
AS
  SELECT * FROM Paciente
  WHERE estado<>-1 AND cedulaIdentidad+nombres+primerApellido+segundoApellido LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY estado DESC, nombres ASC, primerApellido ASC;

GO
ALTER PROC paDoctorListar @parametro VARCHAR(100)
AS
  SELECT d.*, u.usuario, e.nombre
  FROM Doctor d
  LEFT JOIN Usuario u ON d.id = u.idDoctor
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE d.estado<>-1 AND d.cedulaIdentidad+d.nombres+d.primerApellido+d.segundoApellido+e.nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY d.estado DESC, d.nombres ASC, d.primerApellido ASC;

GO
ALTER PROC paHistorialClinicoListar @parametro VARCHAR(100)
AS
  SELECT p.*, h.* 
  FROM Paciente p
  LEFT JOIN HistorialClinico h ON p.id = h.idPaciente
  WHERE p.estado<>-1 AND p.cedulaIdentidad+p.nombres+p.primerApellido+p.segundoApellido LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY p.estado DESC, p.nombres ASC, p.primerApellido ASC;

INSERT INTO Especialidad (nombre)
VALUES ('Cardiología')

INSERT INTO Especialidad (nombre)
VALUES ('Odontología')

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular)
VALUES (1,'12345678','Juan', 'Pérez', 'Lopez', 'ave. americas', 11121314);

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular)
VALUES (2,'87654321', 'María', 'González', 'Padilla', ' 6 de agosto', 12131415);

UPDATE Doctor SET nombres='Pedro' WHERE id=4;

INSERT INTO Usuario(usuario, clave, idDoctor)
VALUES ('hans', '123456', 4);

SELECT * FROM Doctor;
SELECT * FROM Usuario;

EXEC paDoctorListar 'Pedro';
SELECT * FROM Doctor;