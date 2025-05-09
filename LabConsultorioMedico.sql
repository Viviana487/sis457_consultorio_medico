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
  SELECT e.*, d.nombres, d.primerApellido, d.segundoApellido
  FROM Especialidad e
  LEFT JOIN Doctor d ON e.id = d.idEspecialidad
  WHERE e.estado<>-1 AND e.nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
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
  SELECT p.*, h.* ,e.*
  FROM Paciente p
  LEFT JOIN HistorialClinico h ON p.id = h.idPaciente
  LEFT JOIN Doctor d ON h.idCita = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE p.estado<>-1 AND p.cedulaIdentidad+p.nombres+p.primerApellido+p.segundoApellido+e.nombre+d.nombres LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY p.estado DESC, fecha ASC;

GO
CREATE PROC paCitaListar @parametro VARCHAR(100) 
AS
  SELECT p.nombres, p.primerApellido, p.segundoApellido, c.fecha, c.hora, d.nombres, d.primerApellido, d.segundoApellido, e.nombre
  FROM Paciente p
  LEFT JOIN Cita c ON p.id = c.idPaciente
  LEFT JOIN Doctor d ON c.idDoctor = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE p.estado<>-1 AND p.cedulaIdentidad+p.nombres+p.primerApellido+p.segundoApellido+e.nombre+d.nombres LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY p.estado DESC, fecha ASC;

GO
CREATE PROC paPagoListar @parametro VARCHAR(100)
AS 
SELECT p.nombres, p.primerApellido, p.segundoApellido, pa.concepto, c.fecha, c.hora, d.nombres, d.primerApellido, d.segundoApellido, e.nombre
FROM Paciente p
LEFT JOIN Pago pa ON p.id = pa.idCita
LEFT JOIN Cita c ON pa.idCita = c.id
LEFT JOIN Doctor d ON c.idDoctor = d.id
LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
WHERE p.estado<>-1 AND p.cedulaIdentidad+p.nombres+p.primerApellido+p.segundoApellido+e.nombre+d.nombres LIKE '%'+REPLACE(@parametro,' ','%')+'%'
ORDER BY p.estado DESC, fecha ASC;


INSERT INTO Especialidad (nombre)
VALUES ('Cardiología')

INSERT INTO Especialidad (nombre)
VALUES ('Odontología')

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular)
VALUES (1,'12345678','Juan', 'Pérez', 'Lopez', 'ave. americas', 11121314);

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular)
VALUES (1,'12345678','Gloria', 'Rosales', 'Cardona', 'Av. Pacífico #456', 77123456);

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular)
VALUES (2,'87654321', 'María', 'González', 'Padilla', ' 6 de agosto', 12131415);

INSERT INTO Paciente (cedulaIdentidad, nombres, primerApellido, segundoApellido, fechaNacimiento, direccion, celular) VALUES
('12345678', 'Juan', 'Pérez', 'Gómez', '1990-05-15', 'Av. Siempre Viva 123', 789456123),
('87654321', 'María', 'López', 'Sánchez', '1985-08-22', 'Calle Falsa 456', 712345678),
('45678912', 'Carlos', 'Ramírez', 'Salazar', '2000-01-10', 'Av. Central 890', 756789432);

INSERT INTO Cita (idDoctor, idPaciente, fecha, hora) VALUES
(1, 1, '2025-05-01', '09:00'),
(2, 2, '2025-05-02', '10:30'),
(1, 1, '2025-05-08', '11:00'),
(2, 3, '2025-05-07', '15:00');

INSERT INTO Pago (idCita, concepto, monto, cambio) VALUES
(1, 'Consulta médica', 100, 0),
(2, 'Revisión médica', 150, 0),
(3, 'Chequeo odontológico', 100, 0),
(4, 'Consulta médica', 150, 0);

INSERT INTO HistorialClinico (idPaciente, idCita, diagnostico, tratamiento) VALUES
(1, 1, 'Control del corazón normal', 'Reposo, paracetamol 500mg cada 8h'),
(2, 2, 'Dolor abdominal leve', 'Dieta blanda por 3 días'),
(1, 3, 'Limpieza dental', 'Continuar hidratación, sin medicamentos'),
(3, 4, 'Soplo en el corazón', 'Antihistamínico diario por una semana');


UPDATE Doctor SET nombres='Pedro' WHERE id=4;

INSERT INTO Usuario(usuario, clave, idDoctor)
VALUES ('hans', '123456', 4);

SELECT * FROM Doctor;
SELECT * FROM Usuario;
SELECT * FROM HistorialClinico;

EXEC paDoctorListar 'Gloria';
EXEC paEspecialidadListar 'Cardiología';
EXEC paPacienteListar 'María';
EXEC paHistorialClinicoListar 'Juan';
EXEC paCitaListar 'Juan';
EXEC paPagoListar '9';