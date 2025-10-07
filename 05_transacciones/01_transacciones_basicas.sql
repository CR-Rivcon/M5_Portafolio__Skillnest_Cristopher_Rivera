-- ============================================
-- SCRIPT: Transacciones Básicas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- EJEMPLO 1: Inscribir empleado en capacitación
-- ============================================

START TRANSACTION;

-- Insertar participación
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
VALUES (5, 3, CURRENT_DATE, 'Inscrito');

-- Verificar que se insertó correctamente
SELECT * FROM participaciones WHERE id_empleado = 5 AND id_capacitacion = 3;

-- Confirmar la transacción
COMMIT;

SELECT 'Empleado inscrito exitosamente' AS mensaje;

-- ============================================
-- EJEMPLO 2: Actualizar progreso con validación
-- ============================================

START TRANSACTION;

-- Actualizar porcentaje de asistencia
UPDATE participaciones
SET porcentaje_asistencia = 85.00,
    estado = 'En Curso'
WHERE id_participacion = 1;

-- Verificar actualización
SELECT id_participacion, estado, porcentaje_asistencia
FROM participaciones
WHERE id_participacion = 1;

-- Confirmar cambios
COMMIT;

SELECT 'Progreso actualizado exitosamente' AS mensaje;

-- ============================================
-- EJEMPLO 3: Transacción con ROLLBACK
-- ============================================

START TRANSACTION;

-- Intentar eliminar un empleado
DELETE FROM empleados WHERE id_empleado = 1;

-- Verificar que se eliminó (temporalmente)
SELECT COUNT(*) AS empleados_restantes FROM empleados;

-- Revertir la eliminación
ROLLBACK;

-- Verificar que el empleado sigue existiendo
SELECT COUNT(*) AS empleados_totales FROM empleados;

SELECT 'Transacción revertida - empleado no eliminado' AS mensaje;

-- ============================================
-- EJEMPLO 4: Completar capacitación
-- ============================================

START TRANSACTION;

-- Actualizar estado a completado
UPDATE participaciones
SET estado = 'Completado',
    porcentaje_asistencia = 100.00,
    fecha_completado = CURRENT_DATE
WHERE id_participacion = 2;

-- Verificar cambios
SELECT 
    e.nombre,
    e.apellido,
    c.nombre AS capacitacion,
    p.estado,
    p.fecha_completado
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE p.id_participacion = 2;

-- Confirmar
COMMIT;

SELECT 'Capacitación completada exitosamente' AS mensaje;

-- ============================================
-- EJEMPLO 5: Transacción con validación
-- ============================================

START TRANSACTION;

-- Verificar cupos disponibles antes de inscribir
SET @capacitacion_id = 4;
SET @empleado_id = 10;

SET @cupos_maximos = (SELECT cupos_maximos FROM capacitaciones WHERE id_capacitacion = @capacitacion_id);
SET @inscritos = (SELECT COUNT(*) FROM participaciones WHERE id_capacitacion = @capacitacion_id);

-- Solo inscribir si hay cupos
SELECT @cupos_maximos AS cupos_maximos, @inscritos AS inscritos_actuales;

-- Si hay cupos, inscribir
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
SELECT @empleado_id, @capacitacion_id, CURRENT_DATE, 'Inscrito'
WHERE @inscritos < @cupos_maximos;

-- Verificar si se insertó
SELECT ROW_COUNT() AS filas_afectadas;

COMMIT;

SELECT 'Inscripción procesada según disponibilidad' AS mensaje;

-- ============================================
-- EJEMPLO 6: Actualización masiva con transacción
-- ============================================

START TRANSACTION;

-- Actualizar múltiples participaciones
UPDATE participaciones
SET porcentaje_asistencia = porcentaje_asistencia + 5.00
WHERE id_capacitacion = 1
  AND estado = 'En Curso'
  AND porcentaje_asistencia <= 95.00;

-- Verificar cuántas filas se actualizaron
SELECT ROW_COUNT() AS participaciones_actualizadas;

-- Mostrar resultados
SELECT 
    e.nombre,
    e.apellido,
    p.porcentaje_asistencia
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE p.id_capacitacion = 1 AND p.estado = 'En Curso';

COMMIT;

SELECT 'Asistencias actualizadas en lote' AS mensaje;

-- ============================================
-- EJEMPLO 7: Transacción con SAVEPOINT
-- ============================================

START TRANSACTION;

-- Primer cambio
UPDATE empleados SET cargo = 'Analista Senior' WHERE id_empleado = 5;
SAVEPOINT punto1;

-- Segundo cambio
UPDATE empleados SET id_departamento = 3 WHERE id_empleado = 5;
SAVEPOINT punto2;

-- Tercer cambio
UPDATE empleados SET email = 'nuevo.email@empresa.cl' WHERE id_empleado = 5;

-- Revertir solo el último cambio
ROLLBACK TO punto2;

-- Confirmar los primeros dos cambios
COMMIT;

SELECT 'Transacción con savepoint ejecutada' AS mensaje;

SELECT 'Transacciones básicas ejecutadas exitosamente' AS mensaje;
