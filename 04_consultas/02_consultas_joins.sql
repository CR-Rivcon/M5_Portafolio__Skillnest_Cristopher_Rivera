-- ============================================
-- SCRIPT: Consultas con JOINs
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- INNER JOIN - Relaciones básicas
-- ============================================

-- Consulta 1: Empleados con su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.cargo,
    d.nombre AS departamento
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY d.nombre, e.apellido;

-- Consulta 2: Capacitaciones con su entidad capacitadora
SELECT 
    c.codigo,
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    ec.nombre AS entidad_capacitadora,
    ec.tipo AS tipo_entidad
FROM capacitaciones c
INNER JOIN entidades_capacitadoras ec ON c.id_entidad = ec.id_entidad
ORDER BY c.fecha_inicio;

-- Consulta 3: Participaciones con información completa
SELECT 
    e.nombre,
    e.apellido,
    c.nombre AS capacitacion,
    p.estado,
    p.porcentaje_asistencia,
    p.fecha_inscripcion
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
ORDER BY p.fecha_inscripcion DESC;

-- ============================================
-- MÚLTIPLES JOINS
-- ============================================

-- Consulta 4: Información completa de participaciones
SELECT 
    e.nombre AS empleado_nombre,
    e.apellido AS empleado_apellido,
    d.nombre AS departamento,
    c.nombre AS capacitacion,
    c.tipo AS tipo_capacitacion,
    c.modalidad,
    ec.nombre AS entidad_capacitadora,
    p.estado,
    p.porcentaje_asistencia
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
INNER JOIN entidades_capacitadoras ec ON c.id_entidad = ec.id_entidad
WHERE p.estado = 'En Curso'
ORDER BY d.nombre, e.apellido;

-- Consulta 5: Capacitaciones técnicas con participantes
SELECT 
    c.nombre AS capacitacion,
    c.duracion_horas,
    e.nombre AS empleado,
    e.apellido,
    e.cargo,
    p.estado,
    p.porcentaje_asistencia
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE c.tipo = 'Técnicas'
ORDER BY c.nombre, e.apellido;

-- ============================================
-- LEFT JOIN - Incluir registros sin relación
-- ============================================

-- Consulta 6: Todos los empleados y sus participaciones (incluye sin capacitaciones)
SELECT 
    e.nombre,
    e.apellido,
    e.cargo,
    COUNT(p.id_participacion) AS total_capacitaciones
FROM empleados e
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido, e.cargo
ORDER BY total_capacitaciones DESC;

-- Consulta 7: Capacitaciones con o sin participantes
SELECT 
    c.nombre AS capacitacion,
    c.cupos_maximos,
    COUNT(p.id_participacion) AS inscritos,
    (c.cupos_maximos - COUNT(p.id_participacion)) AS cupos_disponibles
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.activo = TRUE
GROUP BY c.id_capacitacion, c.nombre, c.cupos_maximos
ORDER BY cupos_disponibles;

-- Consulta 8: Departamentos y cantidad de empleados
SELECT 
    d.nombre AS departamento,
    COUNT(e.id_empleado) AS total_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento AND e.activo = TRUE
GROUP BY d.id_departamento, d.nombre
ORDER BY total_empleados DESC;

-- Consulta 9: Entidades capacitadoras y sus capacitaciones
SELECT 
    ec.nombre AS entidad,
    ec.tipo,
    COUNT(c.id_capacitacion) AS total_capacitaciones
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
GROUP BY ec.id_entidad, ec.nombre, ec.tipo
ORDER BY total_capacitaciones DESC;

-- ============================================
-- JOINS CON FILTROS ESPECÍFICOS
-- ============================================

-- Consulta 10: Empleados de TI en capacitaciones técnicas
SELECT 
    e.nombre,
    e.apellido,
    e.cargo,
    c.nombre AS capacitacion,
    p.estado,
    p.porcentaje_asistencia
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE d.nombre = 'Tecnología' 
  AND c.tipo = 'Técnicas'
ORDER BY e.apellido;

-- Consulta 11: Capacitaciones online con participantes activos
SELECT 
    c.nombre AS capacitacion,
    c.modalidad,
    e.nombre AS empleado,
    e.apellido,
    p.porcentaje_asistencia
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE c.modalidad IN ('Online Sincrónico', 'Online Asincrónico')
  AND p.estado IN ('En Curso', 'Completado')
ORDER BY c.nombre, p.porcentaje_asistencia DESC;

-- Consulta 12: Empleados con capacitaciones completadas
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS departamento,
    c.nombre AS capacitacion,
    p.fecha_completado,
    p.porcentaje_asistencia
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE p.estado = 'Completado'
ORDER BY p.fecha_completado DESC;

-- ============================================
-- JOINS COMPLEJOS CON SUBCONSULTAS
-- ============================================

-- Consulta 13: Empleados con más capacitaciones que el promedio
SELECT 
    e.nombre,
    e.apellido,
    COUNT(p.id_participacion) AS total_capacitaciones
FROM empleados e
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING COUNT(p.id_participacion) > (
    SELECT AVG(cap_count)
    FROM (
        SELECT COUNT(*) AS cap_count
        FROM participaciones
        GROUP BY id_empleado
    ) AS subquery
)
ORDER BY total_capacitaciones DESC;

-- Consulta 14: Capacitaciones más populares por departamento
SELECT 
    d.nombre AS departamento,
    c.nombre AS capacitacion,
    COUNT(p.id_participacion) AS total_inscritos
FROM departamentos d
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
GROUP BY d.id_departamento, d.nombre, c.id_capacitacion, c.nombre
ORDER BY d.nombre, total_inscritos DESC;

SELECT 'Consultas con JOINs ejecutadas exitosamente' AS mensaje;
