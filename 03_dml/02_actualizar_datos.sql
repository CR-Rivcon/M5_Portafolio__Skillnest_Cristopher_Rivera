-- ============================================
-- SCRIPT: Actualización de Datos
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- ACTUALIZAR ESTADO DE PARTICIPACIONES
-- ============================================

-- Ejemplo 1: Actualizar estado a "En Curso" cuando comienza la capacitación
UPDATE participaciones
SET estado = 'En Curso',
    porcentaje_asistencia = 10.00
WHERE id_participacion = 6 AND estado = 'Inscrito';

SELECT 'Participación actualizada a En Curso' AS mensaje;

-- Ejemplo 2: Completar una capacitación
UPDATE participaciones
SET estado = 'Completado',
    porcentaje_asistencia = 100.00,
    fecha_completado = CURRENT_DATE
WHERE id_empleado = 2 AND id_capacitacion = 1;

SELECT 'Capacitación completada' AS mensaje;

-- Ejemplo 3: Marcar como abandonado
UPDATE participaciones
SET estado = 'Abandonado',
    observaciones = 'Empleado solicitó baja por motivos personales'
WHERE id_participacion = 15;

SELECT 'Participación marcada como abandonada' AS mensaje;

-- ============================================
-- ACTUALIZAR PORCENTAJE DE ASISTENCIA
-- ============================================

-- Actualizar asistencia de múltiples participantes de una capacitación
UPDATE participaciones
SET porcentaje_asistencia = porcentaje_asistencia + 10.00
WHERE id_capacitacion = 4 
  AND estado = 'En Curso'
  AND porcentaje_asistencia < 100;

SELECT 'Asistencias actualizadas' AS mensaje;

-- ============================================
-- ACTUALIZAR DATOS DE EMPLEADOS
-- ============================================

-- Ejemplo 1: Cambiar cargo de un empleado
UPDATE empleados
SET cargo = 'Gerente de Recursos Humanos'
WHERE id_empleado = 1;

SELECT 'Cargo actualizado' AS mensaje;

-- Ejemplo 2: Cambiar departamento de un empleado
UPDATE empleados
SET id_departamento = 2
WHERE id_empleado = 6;

SELECT 'Departamento actualizado' AS mensaje;

-- Ejemplo 3: Actualizar email de empleado
UPDATE empleados
SET email = 'maria.gonzalez.nueva@empresa.cl'
WHERE id_empleado = 1;

SELECT 'Email actualizado' AS mensaje;

-- ============================================
-- ACTUALIZAR INFORMACIÓN DE CAPACITACIONES
-- ============================================

-- Ejemplo 1: Extender fecha de finalización
UPDATE capacitaciones
SET fecha_fin = DATE_ADD(fecha_fin, INTERVAL 15 DAY)
WHERE id_capacitacion = 1;

SELECT 'Fecha de capacitación extendida' AS mensaje;

-- Ejemplo 2: Aumentar cupos máximos
UPDATE capacitaciones
SET cupos_maximos = cupos_maximos + 10
WHERE id_capacitacion = 5;

SELECT 'Cupos aumentados' AS mensaje;

-- Ejemplo 3: Actualizar descripción
UPDATE capacitaciones
SET descripcion = 'Curso actualizado de Excel con nuevos módulos de Power Query y DAX'
WHERE codigo = 'CAP-TEC-001';

SELECT 'Descripción actualizada' AS mensaje;

-- ============================================
-- ACTUALIZAR ENTIDADES CAPACITADORAS
-- ============================================

-- Actualizar información de contacto
UPDATE entidades_capacitadoras
SET contacto = 'Carolina Méndez',
    telefono = '+56944556677'
WHERE id_entidad = 1;

SELECT 'Contacto de entidad actualizado' AS mensaje;

-- ============================================
-- ACTUALIZACIONES MASIVAS
-- ============================================

-- Ejemplo 1: Marcar como completadas todas las participaciones con 100% asistencia
UPDATE participaciones
SET estado = 'Completado',
    fecha_completado = CURRENT_DATE
WHERE porcentaje_asistencia = 100.00 
  AND estado != 'Completado';

SELECT 'Participaciones completadas automáticamente' AS mensaje;

-- Ejemplo 2: Actualizar estado de capacitaciones finalizadas
UPDATE capacitaciones
SET activo = FALSE
WHERE fecha_fin < CURRENT_DATE;

SELECT 'Capacitaciones finalizadas desactivadas' AS mensaje;

-- ============================================
-- VERIFICAR ACTUALIZACIONES
-- ============================================

-- Ver participaciones actualizadas recientemente
SELECT 
    e.nombre,
    e.apellido,
    c.nombre AS capacitacion,
    p.estado,
    p.porcentaje_asistencia,
    p.fecha_actualizacion
FROM participaciones p
JOIN empleados e ON p.id_empleado = e.id_empleado
JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
ORDER BY p.fecha_actualizacion DESC
LIMIT 10;

SELECT 'Actualizaciones verificadas' AS mensaje;
