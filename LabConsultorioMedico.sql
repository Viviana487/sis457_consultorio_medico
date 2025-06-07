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
DROP TABLE Concepto;
DROP TABLE Especialidad;

CREATE TABLE Especialidad (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Concepto (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idEspecialidad INT NOT NULL,
  descripcion VARCHAR(250) NOT NULL,
  costo DECIMAL(10, 2) NOT NULL,
  CONSTRAINT fk_Concepto_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(id)
);
CREATE TABLE Paciente (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  cedulaIdentidad VARCHAR(12) NOT NULL,
  nombreCompletoPaciente VARCHAR(30) NOT NULL,
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

ALTER TABLE Concepto ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Concepto ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Concepto ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1:Eliminado, 0: Inactivo, 1: Activo

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
  SELECT *
  FROM Especialidad
  WHERE estado<>-1 AND nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY estado DESC, nombre ASC;

GO
CREATE PROC paPacienteListar @parametro VARCHAR(100)
AS
  SELECT * FROM Paciente
  WHERE estado<>-1 AND cedulaIdentidad+nombreCompletoPaciente LIKE '%'+REPLACE(@parametro,' ','%')+'%'
  ORDER BY estado DESC, nombreCompletoPaciente ASC;

GO
CREATE PROC paDoctorListar @parametro VARCHAR(100)
AS
  SELECT d.id, d.idEspecialidad, d.cedulaIdentidad,d.nombreCompletoDoctor,e.nombre,d.direccion,d.celular, u.usuario, d.usuarioRegistro, d.FechaRegistro, d.estado, e.estado as estadoE
  FROM Doctor d
  LEFT JOIN Usuario u ON d.id = u.idDoctor
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  WHERE d.estado<>-1 AND e.estado<>-1 AND d.cedulaIdentidad+d.nombreCompletoDoctor+e.nombre LIKE '%'+REPLACE(@parametro,' ','%')+'%'
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
BEGIN
  SELECT 
    c.id,
    e.id AS idEspecialidad,
    c.fecha,
    c.hora,
    p.cedulaIdentidad, 
    p.nombreCompletoPaciente, 
    e.nombre, 
    d.nombreCompletoDoctor,
    CASE 
      WHEN pa.idCita IS NOT NULL THEN 'Sí'
      ELSE 'No'
    END AS Pagada,
    pa.fecha as fecha1,
    c.usuarioRegistro, 
    c.fechaRegistro, 
    c.estado
  FROM Cita c
  LEFT JOIN Paciente p ON p.id = c.idPaciente
  LEFT JOIN Doctor d ON c.idDoctor = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  LEFT JOIN Pago pa ON pa.idCita = c.id
  WHERE c.estado <> -1 
    AND c.fecha >= CAST(GETDATE() AS DATE) 
    AND p.cedulaIdentidad LIKE '%' + REPLACE(@parametro,' ','%') + '%'
  ORDER BY c.estado DESC, c.fecha ASC;
END

GO
CREATE PROC paCitaporFechaListar @parametrofecha DATE
AS
BEGIN
  SELECT 
    c.id,
    e.id AS idEspecialidad,
    c.fecha,
    c.hora,
    p.cedulaIdentidad, 
    p.nombreCompletoPaciente, 
    e.nombre, 
    d.nombreCompletoDoctor,
    CASE 
      WHEN pa.idCita IS NOT NULL THEN 'Sí'
      ELSE 'No'
    END AS Pagada,
    pa.fecha as fecha1,
    c.usuarioRegistro, 
    c.fechaRegistro, 
    c.estado
  FROM Cita c
  LEFT JOIN Paciente p ON p.id = c.idPaciente
  LEFT JOIN Doctor d ON c.idDoctor = d.id
  LEFT JOIN Especialidad e ON d.idEspecialidad = e.id
  LEFT JOIN Pago pa ON pa.idCita = c.id
  WHERE c.estado <> -1 
    AND c.fecha >= CAST(GETDATE() AS DATE) 
    AND c.fecha LIKE @parametrofecha
  ORDER BY c.estado DESC, c.fecha ASC;
END


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
(2,'87654321', 'María González Padilla', ' 6 de agosto', 12131415),
(2,'18273737','pablito alcachofa', 'mercado campesino', 18273474);

INSERT INTO Paciente (cedulaIdentidad, nombreCompletoPaciente, direccion, celular) VALUES
('12345678', 'Juan Pérez Gómez', 'Av. Siempre Viva 123', 789456123),
('87654321', 'María López Sánchez', 'Calle Falsa 456', 712345678),
('45678912', 'Carlos Ramírez Salazar', 'Av. Central 890', 756789432);

INSERT INTO Cita (idDoctor, idPaciente,idEspecialidad, fecha, hora) VALUES
(1, 1,1, '2025-07-01', '09:00'),
(2, 2,1, '2025-08-02', '10:30'),
(1, 1,2, '2025-09-08','11:00'),
(2, 3,2, '2025-10-07','15:00');

INSERT INTO Concepto(idEspecialidad,descripcion,costo)
VALUES
(1,'Consulta médica',100),
(1,'Revisión médica',150),
(2,'Chequeo odontológico',100),
(2,'Limpieza dental',150);

INSERT INTO Pago (idCita, idConcepto) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO HistorialClinico (idPaciente, idCita, diagnostico, tratamiento) VALUES
(1, 1, 'Control del corazón normal', 'Reposo, paracetamol 500mg cada 8h'),
(2, 2, 'Dolor abdominal leve', 'Dieta blanda por 3 días'),
(1, 3, 'Limpieza dental', 'Continuar hidratación, sin medicamentos'),
(3, 4, 'Soplo en el corazón', 'Antihistamínico diario por una semana');



INSERT INTO Usuario(usuario, clave, idDoctor)
VALUES ('gvidal', 'i0hcoO/nssY6WOs9pOp5Xw==', 1); --usuario prueba

SELECT * FROM Doctor;
SELECT * FROM Usuario;
SELECT * FROM HistorialClinico;
SELECT * FROM Cita;

EXEC paDoctorListar '';
EXEC paEspecialidadListar '';
EXEC paPacienteListar '';
EXEC paHistorialClinicoListar '';
EXEC paCitaListar '';
EXEC paPagoListar '';
EXEC paCitaPorFechaListar '2025-07-01';