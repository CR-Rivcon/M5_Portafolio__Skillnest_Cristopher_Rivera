-- ============================================
-- SCRIPT: Consultas de Agregación
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- FUNCIONES DE AGREGACIÓN BÁSICAS
-- ============================================

-- Consulta 1: Total de empleados
SELECT COUNT(*) AS total_empleados FROM empleados WHERE activo = TRUE;

-- Consulta 2: Total de capacitaciones por tipo
SELECT 
    tipo,
    COUNT(*) AS total_capacitaciones
FROM capacitaciones
WHERE activo = TRUE
GROUP BY tipo
ORDER BY total_capacitaciones DESC;

-- Consulta 3: Total de participaciones por estado
SELECT 
    estado,
    COUNT(*) AS total_participaciones
FROM participaciones
GROUP BY estado
ORDER BY total_participaciones DESC;

-- Consulta 4: Promedio de duración de capacitaciones
SELECT 
    tipo,
    AVG(duracion_horas) AS promedio_horas,
    MIN(duracion_horas) AS minimo_horas,
    MAX(duracion_horas) AS maximo_horas
FROM capacitaciones
GROUP BY tipo
ORDER BY promedio_horas DESC;

-- ============================================
-- AGREGACIÓN POR DEPARTAMENTO
-- ============================================

-- Consulta 5: Empleados por departamento
SELECT 
    d.nombre AS departamento,
    COUNT(e.id_empleado) AS total_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento AND e.activo = TRUE
GROUP BY d.id_departamento, d.nombre
ORDER BY total_empleados DESC;

-- Consulta 6: Participaciones por departamento
SELECT 
    d.nombre AS departamento,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS en_curso
FROM departamentos d
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY d.id_departamento, d.nombre
ORDER BY total_participaciones DESC;

-- ============================================
-- AGREGACIÓN POR CAPACITACIÓN
-- ============================================

-- Consulta 7: Participantes por capacitación
SELECT 
    c.nombre AS capacitacion,
    c.cupos_maximos,
    COUNT(p.id_participacion) AS total_inscritos,
    (c.cupos_maximos - COUNT(p.id_participacion)) AS cupos_disponibles,
    ROUND((COUNT(p.id_participacion) / c.cupos_maximos * 100), 2) AS porcentaje_ocupacion
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.activo = TRUE
GROUP BY c.id_capacitacion, c.nombre, c.cupos_maximos
ORDER BY porcentaje_ocupacion DESC;

-- Consulta 8: Promedio de asistencia por capacitación
SELECT 
    c.nombre AS capacitacion,
    c.tipo,
    COUNT(p.id_participacion) AS total_participantes,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY c.id_capacitacion, c.nombre, c.tipo
HAVING COUNT(p.id_participacion) > 0
ORDER BY promedio_asistencia DESC;

-- ============================================
-- AGREGACIÓN POR EMPLEADO
-- ============================================

-- Consulta 9: Capacitaciones por empleado
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS departamento,
    COUNT(p.id_participacion) AS total_capacitaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN p.estado = 'Inscrito' THEN 1 ELSE 0 END) AS pendientes
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
WHERE e.activo = TRUE
GROUP BY e.id_empleado, e.nombre, e.apellido, d.nombre
ORDER BY total_capacitaciones DESC;

-- Consulta 10: Promedio de asistencia por empleado
SELECT 
    e.nombre,
    e.apellido,
    COUNT(p.id_participacion) AS total_participaciones,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia
FROM empleados e
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING COUNT(p.id_participacion) > 0
ORDER BY promedio_asistencia DESC;

-- ============================================
-- AGREGACIÓN POR MODALIDAD Y TIPO
-- ============================================

-- Consulta 11: Capacitaciones por modalidad
SELECT 
    modalidad,
    COUNT(*) AS total_capacitaciones,
    SUM(cupos_maximos) AS total_cupos,
    ROUND(AVG(duracion_horas), 2) AS promedio_duracion
FROM capacitaciones
WHERE activo = TRUE
GROUP BY modalidad
ORDER BY total_capacitaciones DESC;

-- Consulta 12: Participaciones por tipo de capacitación
SELECT 
    c.tipo,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY c.tipo
ORDER BY total_participaciones DESC;

-- ============================================
-- AGREGACIÓN POR ENTIDAD CAPACITADORA
-- ============================================

-- Consulta 13: Capacitaciones por entidad
SELECT 
    ec.nombre AS entidad,
    ec.tipo AS tipo_entidad,
    COUNT(c.id_capacitacion) AS total_capacitaciones,
    SUM(c.duracion_horas) AS total_horas
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
GROUP BY ec.id_entidad, ec.nombre, ec.tipo
ORDER BY total_capacitaciones DESC;

-- Consulta 14: Participantes por entidad capacitadora
SELECT 
    ec.nombre AS entidad,
    COUNT(DISTINCT p.id_empleado) AS total_empleados_capacitados,
    COUNT(p.id_participacion) AS total_participaciones
FROM entidades_capacitadoras ec
INNER JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY ec.id_entidad, ec.nombre
ORDER BY total_participaciones DESC;

-- ============================================
-- AGREGACIÓN CON HAVING
-- ============================================

-- Consulta 15: Empleados con más de 3 capacitaciones
SELECT 
    e.nombre,
    e.apellido,
    COUNT(p.id_participacion) AS total_capacitaciones
FROM empleados e
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING COUNT(p.id_participacion) > 3
ORDER BY total_capacitaciones DESC;

-- Consulta 16: Capacitaciones con alta demanda (más de 10 inscritos)
SELECT 
    c.nombre AS capacitacion,
    c.tipo,
    COUNT(p.id_participacion) AS total_inscritos
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY c.id_capacitacion, c.nombre, c.tipo
HAVING COUNT(p.id_participacion) > 10
ORDER BY total_inscritos DESC;

-- ============================================
-- ESTADÍSTICAS GENERALES
-- ============================================

-- Consulta 17: Resumen general del sistema
SELECT 
    'Estadísticas Generales' AS categoria,
    (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) AS empleados_activos,
    (SELECT COUNT(*) FROM capacitaciones WHERE activo = TRUE) AS capacitaciones_activas,
    (SELECT COUNT(*) FROM participaciones) AS total_participaciones,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'Completado') AS participaciones_completadas,
    (SELECT ROUND(AVG(porcentaje_asistencia), 2) FROM participaciones) AS promedio_asistencia_general;

-- Consulta 18: Horas totales de capacitación por departamento
SELECT 
    d.nombre AS departamento,
    COUNT(DISTINCT p.id_empleado) AS empleados_capacitados,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(c.duracion_horas) AS total_horas_capacitacion
FROM departamentos d
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
GROUP BY d.id_departamento, d.nombre
ORDER BY total_horas_capacitacion DESC;

SELECT 'Consultas de agregación ejecutadas exitosamente' AS mensaje;
