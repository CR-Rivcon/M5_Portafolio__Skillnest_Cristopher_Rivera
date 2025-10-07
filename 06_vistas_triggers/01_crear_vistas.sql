-- ============================================
-- SCRIPT: Creación de Vistas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- VISTA 1: Información completa de empleados y capacitaciones
-- ============================================

CREATE OR REPLACE VIEW vista_empleados_capacitaciones AS
SELECT 
    e.id_empleado,
    e.rut,
    CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo,
    e.cargo,
    d.nombre AS departamento,
    c.codigo AS codigo_capacitacion,
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    c.duracion_horas,
    p.fecha_inscripcion,
    p.estado,
    p.porcentaje_asistencia,
    p.fecha_completado,
    ec.nombre AS entidad_capacitadora
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
INNER JOIN entidades_capacitadoras ec ON c.id_entidad = ec.id_entidad
WHERE e.activo = TRUE;

-- Probar la vista
SELECT * FROM vista_empleados_capacitaciones LIMIT 10;

-- ============================================
-- VISTA 2: Capacitaciones disponibles con cupos
-- ============================================

CREATE OR REPLACE VIEW vista_capacitaciones_disponibles AS
SELECT 
    c.id_capacitacion,
    c.codigo,
    c.nombre,
    c.descripcion,
    c.tipo,
    c.modalidad,
    c.duracion_horas,
    c.fecha_inicio,
    c.fecha_fin,
    c.cupos_maximos,
    COUNT(p.id_participacion) AS inscritos,
    (c.cupos_maximos - COUNT(p.id_participacion)) AS cupos_disponibles,
    ROUND((COUNT(p.id_participacion) / c.cupos_maximos * 100), 2) AS porcentaje_ocupacion,
    ec.nombre AS entidad_capacitadora,
    CASE 
        WHEN CURRENT_DATE < c.fecha_inicio THEN 'Próxima'
        WHEN CURRENT_DATE BETWEEN c.fecha_inicio AND c.fecha_fin THEN 'En Curso'
        ELSE 'Finalizada'
    END AS estado_temporal
FROM capacitaciones c
INNER JOIN entidades_capacitadoras ec ON c.id_entidad = ec.id_entidad
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.activo = TRUE
GROUP BY c.id_capacitacion, c.codigo, c.nombre, c.descripcion, c.tipo, c.modalidad,
         c.duracion_horas, c.fecha_inicio, c.fecha_fin, c.cupos_maximos, ec.nombre;

-- Probar la vista
SELECT * FROM vista_capacitaciones_disponibles WHERE cupos_disponibles > 0;

-- ============================================
-- VISTA 3: Progreso por departamento
-- ============================================

CREATE OR REPLACE VIEW vista_progreso_departamentos AS
SELECT 
    d.id_departamento,
    d.nombre AS departamento,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN p.estado = 'Inscrito' THEN 1 ELSE 0 END) AS pendientes,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    SUM(c.duracion_horas) AS total_horas,
    ROUND(SUM(c.duracion_horas) / NULLIF(COUNT(DISTINCT e.id_empleado), 0), 2) AS horas_por_empleado
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento AND e.activo = TRUE
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
LEFT JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
GROUP BY d.id_departamento, d.nombre;

-- Probar la vista
SELECT * FROM vista_progreso_departamentos ORDER BY total_participaciones DESC;

-- ============================================
-- VISTA 4: Ranking de participación
-- ============================================

CREATE OR REPLACE VIEW vista_ranking_participacion AS
SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo,
    e.cargo,
    d.nombre AS departamento,
    COUNT(p.id_participacion) AS total_capacitaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS en_curso,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    SUM(c.duracion_horas) AS total_horas_capacitacion,
    CASE 
        WHEN COUNT(p.id_participacion) >= 5 THEN 'Alto'
        WHEN COUNT(p.id_participacion) >= 3 THEN 'Medio'
        WHEN COUNT(p.id_participacion) >= 1 THEN 'Bajo'
        ELSE 'Sin capacitaciones'
    END AS nivel_participacion
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
LEFT JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE e.activo = TRUE
GROUP BY e.id_empleado, e.nombre, e.apellido, e.cargo, d.nombre;

-- Probar la vista
SELECT * FROM vista_ranking_participacion ORDER BY total_capacitaciones DESC LIMIT 10;

-- ============================================
-- VISTA 5: Capacitaciones por entidad
-- ============================================

CREATE OR REPLACE VIEW vista_capacitaciones_por_entidad AS
SELECT 
    ec.id_entidad,
    ec.nombre AS entidad,
    ec.tipo AS tipo_entidad,
    ec.especialidad,
    COUNT(DISTINCT c.id_capacitacion) AS total_capacitaciones,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS participaciones_completadas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    SUM(c.duracion_horas) AS total_horas_dictadas
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE ec.activo = TRUE
GROUP BY ec.id_entidad, ec.nombre, ec.tipo, ec.especialidad;

-- Probar la vista
SELECT * FROM vista_capacitaciones_por_entidad ORDER BY total_participaciones DESC;

-- ============================================
-- VISTA 6: Capacitaciones pendientes por empleado
-- ============================================

CREATE OR REPLACE VIEW vista_capacitaciones_pendientes AS
SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    e.cargo,
    d.nombre AS departamento,
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    c.fecha_inicio,
    c.fecha_fin,
    p.estado,
    p.porcentaje_asistencia,
    DATEDIFF(c.fecha_fin, CURRENT_DATE) AS dias_restantes
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE p.estado IN ('Inscrito', 'En Curso')
  AND c.fecha_fin >= CURRENT_DATE
  AND e.activo = TRUE;

-- Probar la vista
SELECT * FROM vista_capacitaciones_pendientes ORDER BY dias_restantes;

-- ============================================
-- VISTA 7: Resumen ejecutivo
-- ============================================

CREATE OR REPLACE VIEW vista_resumen_ejecutivo AS
SELECT 
    (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) AS empleados_activos,
    (SELECT COUNT(*) FROM capacitaciones WHERE activo = TRUE) AS capacitaciones_activas,
    (SELECT COUNT(*) FROM participaciones) AS total_participaciones,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'Completado') AS completadas,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'En Curso') AS en_curso,
    (SELECT ROUND(AVG(porcentaje_asistencia), 2) FROM participaciones) AS promedio_asistencia,
    (SELECT COUNT(DISTINCT id_empleado) FROM participaciones) AS empleados_con_capacitaciones,
    (SELECT ROUND((COUNT(DISTINCT id_empleado) / (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) * 100), 2) 
     FROM participaciones) AS porcentaje_cobertura;

-- Probar la vista
SELECT * FROM vista_resumen_ejecutivo;

-- ============================================
-- Listar todas las vistas creadas
-- ============================================

SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT 'Vistas creadas exitosamente' AS mensaje;
