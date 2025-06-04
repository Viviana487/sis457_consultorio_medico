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
DROP TABLE Especialidad;
DROP TABLE Cita;
DROP TABLE Usuario;
DROP TABLE Doctor;
DROP TABLE Paciente;
DROP TABLE Concepto;

CREATE TABLE Especialidad (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Concepto (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idEspecialidad INT NOT NULL,
  descripcion VARCHAR(250) NOT NULL
  CONSTRAINT fk_Concepto_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(id)
);
CREATE TABLE Paciente (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  cedulaIdentidad VARCHAR(12) NOT NULL,
  nombreCompletoPaciente VARCHAR(30) NOT NULL,
  fechaNacimiento DATE NOT NULL,
  direccion VARCHAR(250) NOT NULL,
  celular BIGINT NOT NULL
);

CREATE TABLE Doctor (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idEspecialidad INT NOT NULL,
  cedulaIdentidad VARCHAR(12) NOT NULL,
  nombreCompletoDoctor VARCHAR(30) NOT NULL,
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
  idEspecialidad INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  CONSTRAINT fk_Cita_Doctor FOREIGN KEY(idDoctor) REFERENCES Doctor(id),
  CONSTRAINT fk_Cita_Paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(id),
  CONSTRAINT fk_Cita_Especialidad FOREIGN KEY(idEspecialidad) REFERENCES Especialidad(id)
);

CREATE TABLE Pago (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idCita INT NOT NULL,
  idConcepto INT NOT NULL,
  monto INT NOT NULL,
  fecha DATE NOT NULL DEFAULT GETDATE(),
  CONSTRAINT fk_Pago_Cita FOREIGN KEY(idCita) REFERENCES Cita(id),
  CONSTRAINT fk_Pago_Concepto FOREIGN KEY(idConcepto) REFERENCES Concepto(id)
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

DROP PROC paEspecialidadListar;
DROP PROC paPacienteListar;
DROP PROC paDoctorListar;
DROP PROC paHistorialClinicoListar;
DROP PROC paCitaListar;
DROP PROC paPagoListar;
DROP PROC paCitaPorFechaListar;

GO
CREATE PROC paEspecialidadListar @parametro VARCHAR(100)
AS
  SELECT e.id, e.nombre, d.nombreCompletoDoctor,e.usuarioRegistro,e.fechaRegistro,e.estado
  FROM Especialidad e
  INNER JOIN Doctor d ON e.id = d.idEspecialidad
  WHERE e.estado<>-1 AND e.nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY e.estado DESC, nombre ASC;

GO
CREATE PROC paPacienteListar @parametro VARCHAR(100)
AS
  SELECT * FROM Paciente
  WHERE estado<>-1 AND cedulaIdentidad+nombreCompletoPaciente LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY estado DESC, nombreCompletoPaciente ASC;

GO
CREATE PROC paDoctorListar @parametro VARCHAR(100)
AS
  SELECT d.id, d.idEspecialidad, d.cedulaIdentidad,d.nombreCompletoDoctor,e.nombre,d.direccion,d.celular, u.usuario, d.usuarioRegistro, d.FechaRegistro, d.estado
  FROM Doctor d
  LEFT JOIN Usuario u ON d.id = u.idDoctor
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE d.estado<>-1 AND d.cedulaIdentidad+d.nombreCompletoDoctor+e.nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY d.estado DESC, d.nombreCompletoDoctor ASC;

GO
CREATE PROC paHistorialClinicoListar @parametro VARCHAR(100)
AS
  SELECT h.id, h.fecha, p.nombreCompletoPaciente, h.diagnostico, h.tratamiento, e.nombre, d.nombreCompletoDoctor,h.usuarioRegistro, h.fechaRegistro, h.estado
  FROM Paciente p
  LEFT JOIN HistorialClinico h ON p.id = h.idPaciente
  LEFT JOIN Doctor d ON h.idCita = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE p.estado<>-1 AND p.cedulaIdentidad+p.nombreCompletoPaciente LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY p.estado DESC, fecha DESC;

GO
CREATE PROC paCitaListar @parametro VARCHAR(100) 
AS
  SELECT c.id,c.fecha,c.hora,p.cedulaIdentidad, p.nombreCompletoPaciente, e.nombre, d.nombreCompletoDoctor, c.usuarioRegistro, c.fechaRegistro, c.estado
  FROM Cita c
  LEFT JOIN PAciente p ON p.id = c.idPaciente
  LEFT JOIN Doctor d ON c.idDoctor = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE p.estado<>-1 AND p.cedulaIdentidad LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY c.estado DESC, c.fecha DESC;

GO
CREATE PROCEDURE paCitaPorFechaListar @parametrofecha DATE
AS
SELECT c.id, c.fecha, c.hora, p.cedulaIdentidad, p.nombreCompletoPaciente, e.nombre, d.nombreCompletoDoctor, c.usuarioRegistro, c.fechaRegistro, c.estado
    FROM Cita c
    LEFT JOIN Paciente p ON c.idPaciente = p.id
    LEFT JOIN Doctor d ON c.idDoctor = d.id
    LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
    WHERE c.estado <> -1 AND c.fecha LIKE @parametrofecha
     ORDER BY c.estado DESC, c.hora DESC;

GO
CREATE PROC paPagoListar @parametro VARCHAR(100)
AS 
SELECT pa.id, p.nombreCompletoPaciente, co.descripcion, c.fecha, c.hora,e.nombre, d.nombreCompletoDoctor, pa.usuarioRegistro, pa.fechaRegistro, pa.estado
FROM Paciente p
LEFT JOIN Pago pa ON p.id = pa.idCita
LEFT JOIN Cita c ON pa.idCita = c.id
LEFT JOIN Doctor d ON c.idDoctor = d.id
LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
LEFT JOIN Concepto co ON pa.idConcepto = co.id
WHERE pa.estado<>-1 AND p.cedulaIdentidad+p.nombreCompletoPaciente+e.nombre+d.nombreCompletoDoctor LIKE '%'+REPLACE(@parametro,' ','%')+'%'
ORDER BY pa.estado DESC, c.fecha DESC;

INSERT INTO Especialidad (nombre)
VALUES ('Cardiología')

INSERT INTO Especialidad (nombre)
VALUES ('Odontología')

INSERT INTO Doctor (idEspecialidad,cedulaIdentidad, nombreCompletoDoctor, direccion, celular)
VALUES (1,'12345678','Juan Pérez López', 'ave. americas', 11121314), 
(1,'12345678','Gloria Rosales Cardona', 'Av. Pacífico #456', 77123456),
(2,'87654321', 'María González Padilla', ' 6 de agosto', 12131415);

INSERT INTO Paciente (cedulaIdentidad, nombreCompletoPaciente, direccion, celular, fechaNacimiento) VALUES
('12345678', 'Juan Pérez Gómez', 'Av. Siempre Viva 123', 789456123, '1990-03-03'),
('87654321', 'María López Sánchez', 'Calle Falsa 456', 712345678, '2000-05-05'),
('45678912', 'Carlos Ramírez Salazar', 'Av. Central 890', 756789432, '2002-07-07');

INSERT INTO Cita (idDoctor, idPaciente,idEspecialidad, fecha, hora) VALUES
(1, 1,1, '2025-05-01', '09:00'),
(2, 2,1, '2025-05-02', '10:30'),
(1, 1,2, '2025-05-08','11:00'),
(2, 3,2, '2025-05-07','15:00');

INSERT INTO Concepto(idEspecialidad,descripcion)
VALUES
(2,'Consulta médica'),
(1,'Revisión médica'),
(1,'Chequeo odontológico'),
(2,'Limpieza dental');

INSERT INTO Pago (idCita, idConcepto, monto) VALUES
(1, 1, 100),
(2, 2, 150),
(3, 3, 100),
(4, 4, 150);

INSERT INTO HistorialClinico (idPaciente, idCita, diagnostico, tratamiento) VALUES
(1, 1, 'Control del corazón normal', 'Reposo, paracetamol 500mg cada 8h'),
(2, 2, 'Dolor abdominal leve', 'Dieta blanda por 3 días'),
(1, 3, 'Limpieza dental', 'Continuar hidratación, sin medicamentos'),
(3, 4, 'Soplo en el corazón', 'Antihistamínico diario por una semana');



INSERT INTO Usuario(usuario, clave, idDoctor)
VALUES ('hans', '123456', 1);

SELECT * FROM Doctor;
SELECT * FROM Usuario;
SELECT * FROM HistorialClinico;

EXEC paDoctorListar '';
EXEC paEspecialidadListar '';
EXEC paPacienteListar '';
EXEC paHistorialClinicoListar '';
EXEC paCitaListar '1';
EXEC paPagoListar '';
EXEC paCitaPorFechaListar '2025-05-01';