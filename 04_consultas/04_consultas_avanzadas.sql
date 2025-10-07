-- ============================================
-- SCRIPT: Consultas Avanzadas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- SUBCONSULTAS EN WHERE
-- ============================================

-- Consulta 1: Empleados sin capacitaciones
SELECT 
    e.nombre,
    e.apellido,
    e.cargo,
    d.nombre AS departamento
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.id_empleado NOT IN (
    SELECT DISTINCT id_empleado 
    FROM participaciones
)
AND e.activo = TRUE
ORDER BY d.nombre, e.apellido;

-- Consulta 2: Capacitaciones sin participantes
SELECT 
    c.codigo,
    c.nombre,
    c.tipo,
    c.modalidad,
    c.fecha_inicio
FROM capacitaciones c
WHERE c.id_capacitacion NOT IN (
    SELECT DISTINCT id_capacitacion 
    FROM participaciones
)
AND c.activo = TRUE
ORDER BY c.fecha_inicio;

-- Consulta 3: Empleados con asistencia superior al promedio
SELECT 
    e.nombre,
    e.apellido,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia
FROM empleados e
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING AVG(p.porcentaje_asistencia) > (
    SELECT AVG(porcentaje_asistencia) 
    FROM participaciones
)
ORDER BY promedio_asistencia DESC;

-- Consulta 4: Capacitaciones más largas que el promedio de su tipo
SELECT 
    c.nombre,
    c.tipo,
    c.duracion_horas
FROM capacitaciones c
WHERE c.duracion_horas > (
    SELECT AVG(duracion_horas)
    FROM capacitaciones c2
    WHERE c2.tipo = c.tipo
)
ORDER BY c.tipo, c.duracion_horas DESC;

-- ============================================
-- SUBCONSULTAS EN SELECT
-- ============================================

-- Consulta 5: Empleados con conteo de capacitaciones
SELECT 
    e.nombre,
    e.apellido,
    e.cargo,
    (SELECT COUNT(*) 
     FROM participaciones p 
     WHERE p.id_empleado = e.id_empleado) AS total_capacitaciones,
    (SELECT COUNT(*) 
     FROM participaciones p 
     WHERE p.id_empleado = e.id_empleado 
     AND p.estado = 'Completado') AS completadas
FROM empleados e
WHERE e.activo = TRUE
ORDER BY total_capacitaciones DESC;

-- Consulta 6: Capacitaciones con estadísticas de participación
SELECT 
    c.nombre AS capacitacion,
    c.cupos_maximos,
    (SELECT COUNT(*) 
     FROM participaciones p 
     WHERE p.id_capacitacion = c.id_capacitacion) AS inscritos,
    (SELECT COUNT(*) 
     FROM participaciones p 
     WHERE p.id_capacitacion = c.id_capacitacion 
     AND p.estado = 'Completado') AS completados,
    (SELECT ROUND(AVG(porcentaje_asistencia), 2)
     FROM participaciones p 
     WHERE p.id_capacitacion = c.id_capacitacion) AS promedio_asistencia
FROM capacitaciones c
WHERE c.activo = TRUE
ORDER BY inscritos DESC;

-- ============================================
-- EXISTS Y NOT EXISTS
-- ============================================

-- Consulta 7: Departamentos con empleados en capacitaciones
SELECT 
    d.nombre AS departamento,
    d.descripcion
FROM departamentos d
WHERE EXISTS (
    SELECT 1
    FROM empleados e
    INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
    WHERE e.id_departamento = d.id_departamento
)
ORDER BY d.nombre;

-- Consulta 8: Empleados que NO han completado ninguna capacitación
SELECT 
    e.nombre,
    e.apellido,
    e.cargo
FROM empleados e
WHERE NOT EXISTS (
    SELECT 1
    FROM participaciones p
    WHERE p.id_empleado = e.id_empleado
    AND p.estado = 'Completado'
)
AND e.activo = TRUE
ORDER BY e.apellido;

-- Consulta 9: Capacitaciones con al menos un participante completado
SELECT 
    c.nombre,
    c.tipo,
    c.modalidad
FROM capacitaciones c
WHERE EXISTS (
    SELECT 1
    FROM participaciones p
    WHERE p.id_capacitacion = c.id_capacitacion
    AND p.estado = 'Completado'
)
ORDER BY c.nombre;

-- ============================================
-- CASE - Lógica condicional
-- ============================================

-- Consulta 10: Clasificación de empleados por nivel de capacitación
SELECT 
    e.nombre,
    e.apellido,
    COUNT(p.id_participacion) AS total_capacitaciones,
    CASE 
        WHEN COUNT(p.id_participacion) = 0 THEN 'Sin capacitaciones'
        WHEN COUNT(p.id_participacion) BETWEEN 1 AND 2 THEN 'Nivel Básico'
        WHEN COUNT(p.id_participacion) BETWEEN 3 AND 5 THEN 'Nivel Intermedio'
        ELSE 'Nivel Avanzado'
    END AS nivel_capacitacion
FROM empleados e
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
WHERE e.activo = TRUE
GROUP BY e.id_empleado, e.nombre, e.apellido
ORDER BY total_capacitaciones DESC;

-- Consulta 11: Estado de cumplimiento de asistencia
SELECT 
    e.nombre,
    e.apellido,
    c.nombre AS capacitacion,
    p.porcentaje_asistencia,
    CASE 
        WHEN p.porcentaje_asistencia >= 90 THEN 'Excelente'
        WHEN p.porcentaje_asistencia >= 75 THEN 'Bueno'
        WHEN p.porcentaje_asistencia >= 60 THEN 'Regular'
        ELSE 'Insuficiente'
    END AS evaluacion_asistencia,
    p.estado
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE p.estado IN ('En Curso', 'Completado')
ORDER BY p.porcentaje_asistencia DESC;

-- Consulta 12: Prioridad de capacitaciones por cupos
SELECT 
    c.nombre AS capacitacion,
    c.cupos_maximos,
    COUNT(p.id_participacion) AS inscritos,
    CASE 
        WHEN COUNT(p.id_participacion) >= c.cupos_maximos THEN 'Completo'
        WHEN COUNT(p.id_participacion) >= c.cupos_maximos * 0.8 THEN 'Casi lleno'
        WHEN COUNT(p.id_participacion) >= c.cupos_maximos * 0.5 THEN 'Disponible'
        ELSE 'Baja demanda'
    END AS estado_cupos
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.activo = TRUE
GROUP BY c.id_capacitacion, c.nombre, c.cupos_maximos
ORDER BY inscritos DESC;

-- ============================================
-- CONSULTAS CON MÚLTIPLES SUBCONSULTAS
-- ============================================

-- Consulta 13: Ranking de empleados más capacitados por departamento
SELECT 
    d.nombre AS departamento,
    e.nombre,
    e.apellido,
    COUNT(p.id_participacion) AS total_capacitaciones,
    (SELECT COUNT(*) 
     FROM participaciones p2 
     INNER JOIN empleados e2 ON p2.id_empleado = e2.id_empleado
     WHERE e2.id_departamento = d.id_departamento
     AND p2.estado = 'Completado') AS total_completadas_depto
FROM departamentos d
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
WHERE e.activo = TRUE
GROUP BY d.id_departamento, d.nombre, e.id_empleado, e.nombre, e.apellido
HAVING COUNT(p.id_participacion) > 0
ORDER BY d.nombre, total_capacitaciones DESC;

-- Consulta 14: Capacitaciones con mejor rendimiento que el promedio
SELECT 
    c.nombre AS capacitacion,
    c.tipo,
    COUNT(p.id_participacion) AS participantes,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    (SELECT ROUND(AVG(porcentaje_asistencia), 2) 
     FROM participaciones) AS promedio_general
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY c.id_capacitacion, c.nombre, c.tipo
HAVING AVG(p.porcentaje_asistencia) > (
    SELECT AVG(porcentaje_asistencia) 
    FROM participaciones
)
ORDER BY promedio_asistencia DESC;

-- ============================================
-- CONSULTAS CON UNION
-- ============================================

-- Consulta 15: Resumen de estados de participación
SELECT 
    'Completadas' AS estado,
    COUNT(*) AS cantidad
FROM participaciones
WHERE estado = 'Completado'

UNION ALL

SELECT 
    'En Curso' AS estado,
    COUNT(*) AS cantidad
FROM participaciones
WHERE estado = 'En Curso'

UNION ALL

SELECT 
    'Inscritas' AS estado,
    COUNT(*) AS cantidad
FROM participaciones
WHERE estado = 'Inscrito'

UNION ALL

SELECT 
    'Abandonadas' AS estado,
    COUNT(*) AS cantidad
FROM participaciones
WHERE estado = 'Abandonado';

-- ============================================
-- CONSULTAS CON WINDOW FUNCTIONS (MySQL 8.0+)
-- ============================================

-- Consulta 16: Ranking de empleados por capacitaciones
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS departamento,
    COUNT(p.id_participacion) AS total_capacitaciones,
    RANK() OVER (ORDER BY COUNT(p.id_participacion) DESC) AS ranking_general,
    RANK() OVER (PARTITION BY d.id_departamento ORDER BY COUNT(p.id_participacion) DESC) AS ranking_departamento
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
WHERE e.activo = TRUE
GROUP BY e.id_empleado, e.nombre, e.apellido, d.id_departamento, d.nombre
ORDER BY ranking_general;

SELECT 'Consultas avanzadas ejecutadas exitosamente' AS mensaje;
