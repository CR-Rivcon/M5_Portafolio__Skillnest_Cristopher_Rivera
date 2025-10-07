-- ============================================
-- SCRIPT: Transacciones Complejas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- TRANSACCIÓN 1: Inscripción múltiple de empleados
-- ============================================

START TRANSACTION;

-- Inscribir múltiples empleados de un departamento en una capacitación
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
SELECT 
    e.id_empleado,
    5 AS id_capacitacion,
    CURRENT_DATE,
    'Inscrito'
FROM empleados e
WHERE e.id_departamento = 2
  AND e.activo = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM participaciones p
    WHERE p.id_empleado = e.id_empleado
    AND p.id_capacitacion = 5
  )
LIMIT 10;

-- Verificar inscripciones
SELECT COUNT(*) AS nuevas_inscripciones FROM participaciones WHERE id_capacitacion = 5;

COMMIT;

SELECT 'Inscripción masiva completada' AS mensaje;

-- ============================================
-- TRANSACCIÓN 2: Transferencia de empleado entre departamentos
-- ============================================

START TRANSACTION;

SET @empleado_id = 6;
SET @nuevo_departamento = 4;

-- Registrar el cambio (en un sistema real, habría una tabla de historial)
UPDATE empleados
SET id_departamento = @nuevo_departamento
WHERE id_empleado = @empleado_id;

-- Verificar el cambio
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nuevo_departamento
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.id_empleado = @empleado_id;

COMMIT;

SELECT 'Empleado transferido exitosamente' AS mensaje;

-- ============================================
-- TRANSACCIÓN 3: Cerrar capacitación y actualizar participaciones
-- ============================================

START TRANSACTION;

SET @capacitacion_id = 7;

-- Marcar capacitación como inactiva
UPDATE capacitaciones
SET activo = FALSE
WHERE id_capacitacion = @capacitacion_id
  AND fecha_fin < CURRENT_DATE;

-- Actualizar participaciones no completadas
UPDATE participaciones
SET estado = 'Abandonado',
    observaciones = CONCAT(COALESCE(observaciones, ''), ' - Capacitación cerrada sin completar')
WHERE id_capacitacion = @capacitacion_id
  AND estado IN ('Inscrito', 'En Curso');

-- Verificar cambios
SELECT 
    c.nombre AS capacitacion,
    c.activo,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'Abandonado' THEN 1 ELSE 0 END) AS abandonadas
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.id_capacitacion = @capacitacion_id
GROUP BY c.id_capacitacion, c.nombre, c.activo;

COMMIT;

SELECT 'Capacitación cerrada y participaciones actualizadas' AS mensaje;

-- ============================================
-- TRANSACCIÓN 4: Crear capacitación e inscribir participantes
-- ============================================

START TRANSACTION;

-- Insertar nueva capacitación
INSERT INTO capacitaciones (
    codigo, nombre, descripcion, tipo, modalidad, 
    duracion_horas, fecha_inicio, fecha_fin, cupos_maximos, id_entidad
)
VALUES (
    'CAP-TEC-999',
    'SQL Avanzado para Analistas',
    'Curso intensivo de SQL con enfoque en optimización',
    'Técnicas',
    'Online Sincrónico',
    40.0,
    DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY),
    DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY),
    20,
    2
);

-- Obtener el ID de la capacitación recién creada
SET @nueva_capacitacion_id = LAST_INSERT_ID();

-- Inscribir empleados del departamento de TI
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
SELECT 
    e.id_empleado,
    @nueva_capacitacion_id,
    CURRENT_DATE,
    'Inscrito'
FROM empleados e
WHERE e.id_departamento = 2
  AND e.activo = TRUE
LIMIT 15;

-- Verificar creación e inscripciones
SELECT 
    c.codigo,
    c.nombre,
    COUNT(p.id_participacion) AS inscritos
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.id_capacitacion = @nueva_capacitacion_id
GROUP BY c.id_capacitacion, c.codigo, c.nombre;

COMMIT;

SELECT 'Capacitación creada e inscripciones realizadas' AS mensaje;

-- ============================================
-- TRANSACCIÓN 5: Proceso de evaluación final
-- ============================================

START TRANSACTION;

SET @capacitacion_eval = 1;

-- Completar automáticamente participaciones con 100% asistencia
UPDATE participaciones
SET estado = 'Completado',
    fecha_completado = CURRENT_DATE
WHERE id_capacitacion = @capacitacion_eval
  AND porcentaje_asistencia = 100.00
  AND estado = 'En Curso';

-- Marcar como abandonadas las que tienen menos de 75% asistencia
UPDATE participaciones
SET estado = 'Abandonado',
    observaciones = 'Asistencia insuficiente'
WHERE id_capacitacion = @capacitacion_eval
  AND porcentaje_asistencia < 75.00
  AND estado = 'En Curso';

-- Generar reporte de resultados
SELECT 
    c.nombre AS capacitacion,
    COUNT(p.id_participacion) AS total_participantes,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS aprobados,
    SUM(CASE WHEN p.estado = 'Abandonado' THEN 1 ELSE 0 END) AS reprobados,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS pendientes,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.id_capacitacion = @capacitacion_eval
GROUP BY c.id_capacitacion, c.nombre;

COMMIT;

SELECT 'Evaluación final procesada' AS mensaje;

-- ============================================
-- TRANSACCIÓN 6: Manejo de errores con ROLLBACK
-- ============================================

START TRANSACTION;

-- Intentar operación que podría fallar
SET @test_empleado = 999;

-- Verificar si el empleado existe
SET @existe = (SELECT COUNT(*) FROM empleados WHERE id_empleado = @test_empleado);

-- Si no existe, hacer rollback
SELECT @existe AS empleado_existe;

-- Simular operación condicional
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado)
SELECT @test_empleado, 1, CURRENT_DATE, 'Inscrito'
WHERE @existe > 0;

-- Verificar si se insertó
SELECT ROW_COUNT() AS filas_insertadas;

-- Si no se insertó nada, hacer rollback
-- En un procedimiento almacenado, aquí iría la lógica de error
ROLLBACK;

SELECT 'Transacción revertida - empleado no existe' AS mensaje;

-- ============================================
-- TRANSACCIÓN 7: Actualización en cascada
-- ============================================

START TRANSACTION;

-- Actualizar información de entidad capacitadora
UPDATE entidades_capacitadoras
SET nombre = 'OTEC Capacita Chile - Actualizado',
    contacto = 'Nuevo Contacto'
WHERE id_entidad = 1;

-- Las capacitaciones asociadas mantienen la referencia por FK
-- Verificar integridad
SELECT 
    ec.nombre AS entidad,
    COUNT(c.id_capacitacion) AS capacitaciones_asociadas
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
WHERE ec.id_entidad = 1
GROUP BY ec.id_entidad, ec.nombre;

COMMIT;

SELECT 'Actualización en cascada completada' AS mensaje;

SELECT 'Transacciones complejas ejecutadas exitosamente' AS mensaje;
