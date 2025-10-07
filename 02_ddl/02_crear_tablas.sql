-- ============================================
-- SCRIPT: Creación de Tablas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- TABLA: departamentos
-- Descripción: Áreas organizacionales
-- ============================================
CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_nombre_depto CHECK (LENGTH(nombre) >= 3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: empleados
-- Descripción: Personal de la organización
-- ============================================
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    rut VARCHAR(12) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    id_departamento INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY (id_departamento) 
        REFERENCES departamentos(id_departamento)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_email_empleado CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_rut_formato CHECK (LENGTH(rut) >= 9)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: entidades_capacitadoras
-- Descripción: OTEC y proveedores de capacitación
-- ============================================
CREATE TABLE entidades_capacitadoras (
    id_entidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    tipo ENUM('OTEC', 'Universidad', 'Consultora', 'Interna') NOT NULL,
    contacto VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    especialidad VARCHAR(200),
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_email_entidad CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: capacitaciones
-- Descripción: Cursos y programas de formación
-- ============================================
CREATE TABLE capacitaciones (
    id_capacitacion INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo ENUM('Técnicas', 'Habilidades Blandas', 'Mutual', 'Optativas', 'Normativas') NOT NULL,
    modalidad ENUM('Presencial', 'Online Sincrónico', 'Online Asincrónico') NOT NULL,
    duracion_horas DECIMAL(5,1) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    cupos_maximos INT NOT NULL DEFAULT 30,
    id_entidad INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_capacitacion_entidad 
        FOREIGN KEY (id_entidad) 
        REFERENCES entidades_capacitadoras(id_entidad)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_duracion CHECK (duracion_horas > 0),
    CONSTRAINT chk_cupos CHECK (cupos_maximos > 0),
    CONSTRAINT chk_fechas CHECK (fecha_fin >= fecha_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: participaciones
-- Descripción: Inscripciones y seguimiento de empleados
-- ============================================
CREATE TABLE participaciones (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_capacitacion INT NOT NULL,
    fecha_inscripcion DATE NOT NULL DEFAULT (CURRENT_DATE),
    estado ENUM('Inscrito', 'En Curso', 'Completado', 'Abandonado') NOT NULL DEFAULT 'Inscrito',
    porcentaje_asistencia DECIMAL(5,2) DEFAULT 0.00,
    fecha_completado DATE NULL,
    observaciones TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_participacion_empleado 
        FOREIGN KEY (id_empleado) 
        REFERENCES empleados(id_empleado)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_participacion_capacitacion 
        FOREIGN KEY (id_capacitacion) 
        REFERENCES capacitaciones(id_capacitacion)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_asistencia CHECK (porcentaje_asistencia BETWEEN 0 AND 100),
    CONSTRAINT uq_empleado_capacitacion UNIQUE (id_empleado, id_capacitacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Verificar creación de tablas
-- ============================================
SHOW TABLES;

-- Mostrar estructura de cada tabla
DESCRIBE departamentos;
DESCRIBE empleados;
DESCRIBE entidades_capacitadoras;
DESCRIBE capacitaciones;
DESCRIBE participaciones;

SELECT 'Todas las tablas creadas exitosamente' AS mensaje;
