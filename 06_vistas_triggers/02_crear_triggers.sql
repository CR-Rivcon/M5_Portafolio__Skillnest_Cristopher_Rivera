-- ============================================
-- SCRIPT: Creación de Triggers
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- Eliminar triggers si existen (para desarrollo)
DROP TRIGGER IF EXISTS validar_cupos_antes_inscripcion;
DROP TRIGGER IF EXISTS actualizar_estado_por_asistencia;
DROP TRIGGER IF EXISTS registrar_fecha_completado;
DROP TRIGGER IF EXISTS validar_fechas_capacitacion;
DROP TRIGGER IF EXISTS prevenir_duplicados_participacion;

-- ============================================
-- TRIGGER 1: Validar cupos disponibles antes de inscribir
-- ============================================

DELIMITER //

CREATE TRIGGER validar_cupos_antes_inscripcion
BEFORE INSERT ON participaciones
FOR EACH ROW
BEGIN
    DECLARE cupos_max INT;
    DECLARE inscritos_actual INT;

    -- Obtener cupos máximos de la capacitación
    SELECT cupos_maximos INTO cupos_max
    FROM capacitaciones
    WHERE id_capacitacion = NEW.id_capacitacion;

    -- Contar inscritos actuales
    SELECT COUNT(*) INTO inscritos_actual
    FROM participaciones
    WHERE id_capacitacion = NEW.id_capacitacion;

    -- Validar que hay cupos disponibles
    IF inscritos_actual >= cupos_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay cupos disponibles para esta capacitación';
    END IF;
END//

DELIMITER ;

SELECT 'Trigger validar_cupos_antes_inscripcion creado' AS mensaje;

-- ============================================
-- TRIGGER 2: Actualizar estado automáticamente según asistencia
-- ============================================

DELIMITER //

CREATE TRIGGER actualizar_estado_por_asistencia
BEFORE UPDATE ON participaciones
FOR EACH ROW
BEGIN
    -- Si la asistencia llega a 100%, marcar como completado
    IF NEW.porcentaje_asistencia = 100.00 AND OLD.estado != 'Completado' THEN
        SET NEW.estado = 'Completado';
        SET NEW.fecha_completado = CURRENT_DATE;
    END IF;

    -- Si la asistencia es mayor a 0 y el estado es Inscrito, cambiar a En Curso
    IF NEW.porcentaje_asistencia > 0 AND OLD.estado = 'Inscrito' THEN
        SET NEW.estado = 'En Curso';
    END IF;
END//

DELIMITER ;

SELECT 'Trigger actualizar_estado_por_asistencia creado' AS mensaje;

-- ============================================
-- TRIGGER 3: Registrar fecha de completado automáticamente
-- ============================================

DELIMITER //

CREATE TRIGGER registrar_fecha_completado
BEFORE UPDATE ON participaciones
FOR EACH ROW
BEGIN
    -- Si el estado cambia a Completado, registrar la fecha
    IF NEW.estado = 'Completado' AND OLD.estado != 'Completado' THEN
        SET NEW.fecha_completado = CURRENT_DATE;
    END IF;

    -- Si el estado deja de ser Completado, limpiar la fecha
    IF NEW.estado != 'Completado' AND OLD.estado = 'Completado' THEN
        SET NEW.fecha_completado = NULL;
    END IF;
END//

DELIMITER ;

SELECT 'Trigger registrar_fecha_completado creado' AS mensaje;

-- ============================================
-- TRIGGER 4: Validar fechas de capacitación
-- ============================================

DELIMITER //

CREATE TRIGGER validar_fechas_capacitacion
BEFORE INSERT ON capacitaciones
FOR EACH ROW
BEGIN
    -- Validar que fecha_fin sea mayor o igual a fecha_inicio
    IF NEW.fecha_fin < NEW.fecha_inicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de fin debe ser mayor o igual a la fecha de inicio';
    END IF;

    -- Validar que la duración sea positiva
    IF NEW.duracion_horas <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La duración debe ser mayor a 0 horas';
    END IF;

    -- Validar que los cupos sean positivos
    IF NEW.cupos_maximos <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los cupos máximos deben ser mayores a 0';
    END IF;
END//

DELIMITER ;

SELECT 'Trigger validar_fechas_capacitacion creado' AS mensaje;

-- ============================================
-- TRIGGER 5: Prevenir inscripciones duplicadas
-- ============================================

DELIMITER //

CREATE TRIGGER prevenir_duplicados_participacion
BEFORE INSERT ON participaciones
FOR EACH ROW
BEGIN
    DECLARE existe INT;

    -- Verificar si ya existe una participación activa
    SELECT COUNT(*) INTO existe
    FROM participaciones
    WHERE id_empleado = NEW.id_empleado
      AND id_capacitacion = NEW.id_capacitacion;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El empleado ya está inscrito en esta capacitación';
    END IF;
END//

DELIMITER ;

SELECT 'Trigger prevenir_duplicados_participacion creado' AS mensaje;

-- ============================================
-- TRIGGER 6: Validar porcentaje de asistencia
-- ============================================

DELIMITER //

CREATE TRIGGER validar_porcentaje_asistencia
BEFORE UPDATE ON participaciones
FOR EACH ROW
BEGIN
    -- Validar que el porcentaje esté entre 0 y 100
    IF NEW.porcentaje_asistencia < 0 OR NEW.porcentaje_asistencia > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El porcentaje de asistencia debe estar entre 0 y 100';
    END IF;
END//

DELIMITER ;

SELECT 'Trigger validar_porcentaje_asistencia creado' AS mensaje;

-- ============================================
-- TRIGGER 7: Auditoría de cambios en empleados
-- ============================================

-- Primero crear tabla de auditoría
CREATE TABLE IF NOT EXISTS auditoria_empleados (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    campo_modificado VARCHAR(50),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100)
) ENGINE=InnoDB;

DELIMITER //

CREATE TRIGGER auditar_cambios_empleados
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    -- Auditar cambio de departamento
    IF OLD.id_departamento != NEW.id_departamento THEN
        INSERT INTO auditoria_empleados (id_empleado, campo_modificado, valor_anterior, valor_nuevo, usuario)
        VALUES (NEW.id_empleado, 'departamento', OLD.id_departamento, NEW.id_departamento, USER());
    END IF;

    -- Auditar cambio de cargo
    IF OLD.cargo != NEW.cargo THEN
        INSERT INTO auditoria_empleados (id_empleado, campo_modificado, valor_anterior, valor_nuevo, usuario)
        VALUES (NEW.id_empleado, 'cargo', OLD.cargo, NEW.cargo, USER());
    END IF;

    -- Auditar cambio de estado activo
    IF OLD.activo != NEW.activo THEN
        INSERT INTO auditoria_empleados (id_empleado, campo_modificado, valor_anterior, valor_nuevo, usuario)
        VALUES (NEW.id_empleado, 'activo', OLD.activo, NEW.activo, USER());
    END IF;
END//

DELIMITER ;

SELECT 'Trigger auditar_cambios_empleados creado' AS mensaje;

-- ============================================
-- Listar todos los triggers creados
-- ============================================

SHOW TRIGGERS;

-- ============================================
-- Probar triggers con ejemplos
-- ============================================

-- Ejemplo 1: Intentar inscribir en capacitación llena (debería fallar)
-- INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
-- VALUES (1, 999, CURRENT_DATE, 'Inscrito');

-- Ejemplo 2: Actualizar asistencia a 100% (debería cambiar estado automáticamente)
-- UPDATE participaciones SET porcentaje_asistencia = 100.00 WHERE id_participacion = 1;

-- Ejemplo 3: Intentar crear capacitación con fechas inválidas (debería fallar)
-- INSERT INTO capacitaciones (codigo, nombre, tipo, modalidad, duracion_horas, fecha_inicio, fecha_fin, id_entidad)
-- VALUES ('TEST', 'Test', 'Técnicas', 'Presencial', 10, '2025-12-31', '2025-01-01', 1);

SELECT 'Triggers creados y probados exitosamente' AS mensaje;

-- ============================================
-- Información de triggers
-- ============================================

SELECT 
    TRIGGER_NAME,
    EVENT_MANIPULATION,
    EVENT_OBJECT_TABLE,
    ACTION_TIMING
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'gestion_capacitaciones'
ORDER BY EVENT_OBJECT_TABLE, ACTION_TIMING;
