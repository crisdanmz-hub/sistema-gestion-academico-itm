-- Creación de usuario y base de datos
CREATE USER 'usuario_python'@'localhost' IDENTIFIED BY '5sd64g56dfg54';
GRANT CREATE, INSERT, DELETE, SELECT, FILE, EXECUTE ON *.* TO 'usuario_python'@'localhost' WITH GRANT OPTION;

CREATE DATABASE db_clase_07092026_is;
USE db_clase_07092026_is;

-- Tabla 1: Sedes
CREATE TABLE sedes (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(150) NOT NULL,
    PRIMARY KEY (id)
);

-- Tabla 2: Bloques (Depende de Sedes)
CREATE TABLE bloques (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    sede_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_bloque_sede FOREIGN KEY (sede_id) REFERENCES sedes(id)
);

-- Tabla 3: Aulas (Depende de Bloques)
CREATE TABLE aulas (
    id INT NOT NULL AUTO_INCREMENT,
    codigo_aula VARCHAR(20) NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    bloque_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_aula_bloque FOREIGN KEY (bloque_id) REFERENCES bloques(id)
);

-- Tabla 4: Facultades
CREATE TABLE facultades (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

-- Tabla 5: Programas (Depende de Facultades)
CREATE TABLE programas (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    facultad_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_programa_facultad FOREIGN KEY (facultad_id) REFERENCES facultades(id)
);

-- Tabla 6: Estados (Ej: Activo, Inactivo, Graduado)
CREATE TABLE estados (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

-- Tabla 7: Estudiantes (Depende de Programas y Estados)
CREATE TABLE estudiantes (
    id INT NOT NULL AUTO_INCREMENT,
    documento VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    programa_id INT NOT NULL,
    estado_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_estudiante_programa FOREIGN KEY (programa_id) REFERENCES programas(id),
    CONSTRAINT fk_estudiante_estado FOREIGN KEY (estado_id) REFERENCES estados(id)
);

-- Tabla 8: Profesores (Depende de Facultades)
CREATE TABLE profesores (
    id INT NOT NULL AUTO_INCREMENT,
    documento VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    facultad_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_profesor_facultad FOREIGN KEY (facultad_id) REFERENCES facultades(id)
);

-- Tabla 9: Materias
CREATE TABLE materias (
    id INT NOT NULL AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    PRIMARY KEY (id)
);

-- Tabla 10: Horarios (Asocia Materia, Profesor y Aula)
CREATE TABLE horarios (
    id INT NOT NULL AUTO_INCREMENT,
    materia_id INT NOT NULL,
    profesor_id INT NOT NULL,
    aula_id INT NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_horario_materia FOREIGN KEY (materia_id) REFERENCES materias(id),
    CONSTRAINT fk_horario_profesor FOREIGN KEY (profesor_id) REFERENCES profesores(id),
    CONSTRAINT fk_horario_aula FOREIGN KEY (aula_id) REFERENCES aulas(id)
);

-- Tabla 11: Matriculas (Relación Estudiante - Materia)
CREATE TABLE matriculas (
    id INT NOT NULL AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    materia_id INT NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_matricula_estudiante FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    CONSTRAINT fk_matricula_materia FOREIGN KEY (materia_id) REFERENCES materias(id)
);

-- Tabla 12: Notas (Depende de Matriculas)
CREATE TABLE notas (
    id INT NOT NULL AUTO_INCREMENT,
    matricula_id INT NOT NULL,
    corte_1 DECIMAL(3,2) DEFAULT 0.00,
    corte_2 DECIMAL(3,2) DEFAULT 0.00,
    corte_3 DECIMAL(3,2) DEFAULT 0.00,
    definitiva DECIMAL(3,2) DEFAULT 0.00,
    PRIMARY KEY (id),
    CONSTRAINT fk_nota_matricula FOREIGN KEY (matricula_id) REFERENCES matriculas(id)
);

-- Inserción de datos mínimos de prueba (Seeders básicos para verificar)
INSERT INTO sedes (nombre, direccion) VALUES ('Sede Robledo', 'Carrera 75 # 65-87');
INSERT INTO bloques (nombre, sede_id) VALUES ('Bloque A', 1);
INSERT INTO aulas (codigo_aula, capacidad, bloque_id) VALUES ('A-101', 35, 1);
INSERT INTO facultades (nombre) VALUES ('Facultad de Ingenierías');
INSERT INTO programas (nombre, facultad_id) VALUES ('Ingeniería de Sistemas', 1);
INSERT INTO estados (nombre) VALUES ('Activo');
INSERT INTO estudiantes (documento, nombre, apellido, programa_id, estado_id) VALUES ('1001234567', 'Carlos', 'Pérez', 1, 1);
INSERT INTO profesores (documento, nombre, apellido, facultad_id) VALUES ('70123456', 'Andrés', 'Giraldo', 1);
INSERT INTO materias (codigo, nombre, creditos) VALUES ('SIS101', 'Bases de Datos I', 3);
INSERT INTO horarios (materia_id, profesor_id, aula_id, dia_semana, hora_inicio, hora_fin) VALUES (1, 1, 1, 'Lunes', '08:00:00', '10:00:00');
INSERT INTO matriculas (estudiante_id, materia_id, semestre) VALUES (1, 1, '2026-1');
INSERT INTO notas (matricula_id, corte_1, corte_2, corte_3, definitiva) VALUES (1, 4.2, 4.5, 4.8, 4.5);

-- Procedimiento almacenado para consultar estudiantes con su programa y estado
DELIMITER $$
CREATE PROCEDURE proc_select_estudiantes()
BEGIN
    SELECT e.id, e.documento, e.nombre, e.apellido, p.nombre AS programa, es.nombre AS estado
    FROM estudiantes e
    INNER JOIN programas p ON e.programa_id = p.id
    INNER JOIN estados es ON e.estado_id = es.id;
END$$
DELIMITER ;