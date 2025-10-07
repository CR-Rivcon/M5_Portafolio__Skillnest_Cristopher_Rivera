-- ============================================
-- SCRIPT: Eliminación de Datos
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- IMPORTANTE: RESPALDO ANTES DE ELIMINAR
-- ============================================
-- Siempre hacer respaldo antes de eliminar datos
-- Este script incluye ejemplos de eliminación segura

-- ============================================
-- ELIMINAR PARTICIPACIONES
-- ============================================

-- Ejemplo 1: Eliminar una participación específica (inscripción cancelada)
-- Primero verificar que existe
SELECT * FROM participaciones WHERE id_participacion = 999;

-- Eliminar si existe
DELETE FROM participaciones 
WHERE id_participacion = 999 
  AND estado = 'Inscrito';

SELECT 'Participación eliminada (si existía)' AS mensaje;

-- Ejemplo 2: Eliminar participaciones abandonadas antiguas
DELETE FROM participaciones
WHERE estado = 'Abandonado'
  AND fecha_inscripcion < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR);

SELECT 'Participaciones abandonadas antiguas eliminadas' AS mensaje;

-- ============================================
-- BAJA LÓGICA DE EMPLEADOS (RECOMENDADO)
-- ============================================
-- En lugar de eliminar, marcar como inactivo

-- Dar de baja a un empleado
UPDATE empleados
SET activo = FALSE
WHERE id_empleado = 18;

SELECT 'Empleado dado de baja (lógica)' AS mensaje;

-- Verificar empleados inactivos
SELECT id_empleado, nombre, apellido, activo
FROM empleados
WHERE activo = FALSE;

-- ============================================
-- DESACTIVAR CAPACITACIONES (BAJA LÓGICA)
-- ============================================

-- Desactivar capacitaciones antiguas o canceladas
UPDATE capacitaciones
SET activo = FALSE
WHERE fecha_fin < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

SELECT 'Capacitaciones antiguas desactivadas' AS mensaje;

-- ============================================
-- ELIMINACIÓN FÍSICA (USAR CON PRECAUCIÓN)
-- ============================================

-- Ejemplo 1: Eliminar capacitación sin participantes
-- Primero verificar que no tiene participantes
SELECT c.id_capacitacion, c.nombre, COUNT(p.id_participacion) as participantes
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.id_capacitacion = 999
GROUP BY c.id_capacitacion, c.nombre;

-- Eliminar solo si no tiene participantes
DELETE FROM capacitaciones
WHERE id_capacitacion = 999
  AND NOT EXISTS (
    SELECT 1 FROM participaciones 
    WHERE id_capacitacion = 999
  );

SELECT 'Capacitación eliminada (si no tenía participantes)' AS mensaje;

-- ============================================
-- ELIMINAR ENTIDAD CAPACITADORA SIN USO
-- ============================================

-- Verificar que no tiene capacitaciones asociadas
SELECT ec.id_entidad, ec.nombre, COUNT(c.id_capacitacion) as capacitaciones
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
WHERE ec.id_entidad = 999
GROUP BY ec.id_entidad, ec.nombre;

-- Eliminar solo si no tiene capacitaciones
DELETE FROM entidades_capacitadoras
WHERE id_entidad = 999
  AND NOT EXISTS (
    SELECT 1 FROM capacitaciones 
    WHERE id_entidad = 999
  );

SELECT 'Entidad eliminada (si no tenía capacitaciones)' AS mensaje;

-- ============================================
-- LIMPIEZA DE DATOS DUPLICADOS
-- ============================================

-- Identificar participaciones duplicadas (mismo empleado, misma capacitación)
SELECT 
    id_empleado, 
    id_capacitacion, 
    COUNT(*) as duplicados
FROM participaciones
GROUP BY id_empleado, id_capacitacion
HAVING COUNT(*) > 1;

-- Eliminar duplicados manteniendo el más reciente
-- (Este es un ejemplo, ajustar según necesidad)
DELETE p1 FROM participaciones p1
INNER JOIN participaciones p2 
WHERE p1.id_empleado = p2.id_empleado
  AND p1.id_capacitacion = p2.id_capacitacion
  AND p1.id_participacion < p2.id_participacion;

SELECT 'Duplicados eliminados' AS mensaje;

-- ============================================
-- ELIMINAR DATOS DE PRUEBA
-- ============================================

-- Eliminar participaciones de prueba
DELETE FROM participaciones
WHERE observaciones LIKE '%PRUEBA%' OR observaciones LIKE '%TEST%';

-- Eliminar empleados de prueba
DELETE FROM empleados
WHERE email LIKE '%test%' OR email LIKE '%prueba%';

SELECT 'Datos de prueba eliminados' AS mensaje;

-- ============================================
-- VERIFICAR INTEGRIDAD DESPUÉS DE ELIMINAR
-- ============================================

-- Verificar que no hay registros huérfanos
SELECT 'Verificando integridad referencial...' AS mensaje;

-- Empleados sin departamento (no debería haber)
SELECT COUNT(*) as empleados_sin_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.id_departamento IS NULL;

-- Participaciones sin empleado (no debería haber)
SELECT COUNT(*) as participaciones_sin_empleado
FROM participaciones p
LEFT JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE e.id_empleado IS NULL;

-- Participaciones sin capacitación (no debería haber)
SELECT COUNT(*) as participaciones_sin_capacitacion
FROM participaciones p
LEFT JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE c.id_capacitacion IS NULL;

SELECT 'Verificación de integridad completada' AS mensaje;

-- ============================================
-- RESUMEN DESPUÉS DE ELIMINACIONES
-- ============================================

SELECT 
    'RESUMEN DESPUÉS DE ELIMINACIONES' AS titulo,
    (SELECT COUNT(*) FROM departamentos) AS departamentos,
    (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) AS empleados_activos,
    (SELECT COUNT(*) FROM empleados WHERE activo = FALSE) AS empleados_inactivos,
    (SELECT COUNT(*) FROM entidades_capacitadoras WHERE activo = TRUE) AS entidades_activas,
    (SELECT COUNT(*) FROM capacitaciones WHERE activo = TRUE) AS capacitaciones_activas,
    (SELECT COUNT(*) FROM participaciones) AS participaciones_totales;
