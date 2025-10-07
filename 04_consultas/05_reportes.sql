-- ============================================
-- SCRIPT: Reportes de Negocio
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- REPORTE 1: Capacitaciones por Empleado
-- ============================================

SELECT 
    e.rut,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    e.cargo,
    d.nombre AS departamento,
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    c.duracion_horas,
    p.fecha_inscripcion,
    p.estado,
    p.porcentaje_asistencia,
    p.fecha_completado
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN participaciones p ON e.id_empleado = p.id_empleado
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE e.activo = TRUE
ORDER BY e.apellido, e.nombre, p.fecha_inscripcion;

-- ============================================
-- REPORTE 2: Participantes por Capacitación
-- ============================================

SELECT 
    c.codigo,
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    c.duracion_horas,
    c.fecha_inicio,
    c.fecha_fin,
    ec.nombre AS entidad_capacitadora,
    CONCAT(e.nombre, ' ', e.apellido) AS participante,
    e.cargo,
    d.nombre AS departamento,
    p.estado,
    p.porcentaje_asistencia,
    CASE 
        WHEN p.porcentaje_asistencia >= 75 THEN 'Aprobado'
        ELSE 'No Aprobado'
    END AS resultado
FROM capacitaciones c
INNER JOIN entidades_capacitadoras ec ON c.id_entidad = ec.id_entidad
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY c.nombre, e.apellido;

-- ============================================
-- REPORTE 3: Progreso por Departamento
-- ============================================

SELECT 
    d.nombre AS departamento,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN p.estado = 'En Curso' THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN p.estado = 'Inscrito' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN p.estado = 'Abandonado' THEN 1 ELSE 0 END) AS abandonadas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    SUM(c.duracion_horas) AS total_horas_capacitacion,
    ROUND(SUM(c.duracion_horas) / COUNT(DISTINCT e.id_empleado), 2) AS horas_promedio_por_empleado
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento AND e.activo = TRUE
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
LEFT JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
GROUP BY d.id_departamento, d.nombre
ORDER BY total_participaciones DESC;

-- ============================================
-- REPORTE 4: Capacitaciones Pendientes
-- ============================================

SELECT 
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
FROM participaciones p
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE p.estado IN ('Inscrito', 'En Curso')
  AND c.fecha_fin >= CURRENT_DATE
ORDER BY c.fecha_fin, e.apellido;

-- ============================================
-- REPORTE 5: Ranking de Participación
-- ============================================

SELECT 
    RANK() OVER (ORDER BY COUNT(p.id_participacion) DESC) AS ranking,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    e.cargo,
    d.nombre AS departamento,
    COUNT(p.id_participacion) AS total_capacitaciones,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    SUM(c.duracion_horas) AS total_horas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    CASE 
        WHEN COUNT(p.id_participacion) >= 5 THEN 'Alto'
        WHEN COUNT(p.id_participacion) >= 3 THEN 'Medio'
        ELSE 'Bajo'
    END AS nivel_participacion
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN participaciones p ON e.id_empleado = p.id_empleado
LEFT JOIN capacitaciones c ON p.id_capacitacion = c.id_capacitacion
WHERE e.activo = TRUE
GROUP BY e.id_empleado, e.nombre, e.apellido, e.cargo, d.nombre
ORDER BY ranking;

-- ============================================
-- REPORTE 6: Reporte por OTEC/Entidad
-- ============================================

SELECT 
    ec.nombre AS entidad_capacitadora,
    ec.tipo AS tipo_entidad,
    ec.especialidad,
    COUNT(DISTINCT c.id_capacitacion) AS total_capacitaciones,
    COUNT(DISTINCT p.id_empleado) AS total_empleados_capacitados,
    COUNT(p.id_participacion) AS total_participaciones,
    SUM(c.duracion_horas) AS total_horas_dictadas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS participaciones_completadas,
    ROUND((SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) / COUNT(p.id_participacion) * 100), 2) AS tasa_completitud
FROM entidades_capacitadoras ec
LEFT JOIN capacitaciones c ON ec.id_entidad = c.id_entidad
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE ec.activo = TRUE
GROUP BY ec.id_entidad, ec.nombre, ec.tipo, ec.especialidad
ORDER BY total_participaciones DESC;

-- ============================================
-- REPORTE 7: Capacitaciones por Tipo y Modalidad
-- ============================================

SELECT 
    c.tipo,
    c.modalidad,
    COUNT(DISTINCT c.id_capacitacion) AS total_capacitaciones,
    SUM(c.cupos_maximos) AS cupos_totales,
    COUNT(p.id_participacion) AS total_inscritos,
    ROUND((COUNT(p.id_participacion) / SUM(c.cupos_maximos) * 100), 2) AS porcentaje_ocupacion,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS completadas,
    ROUND(AVG(p.porcentaje_asistencia), 2) AS promedio_asistencia,
    ROUND(AVG(c.duracion_horas), 2) AS promedio_duracion
FROM capacitaciones c
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
WHERE c.activo = TRUE
GROUP BY c.tipo, c.modalidad
ORDER BY c.tipo, c.modalidad;

-- ============================================
-- REPORTE 8: Cumplimiento de Capacitaciones Normativas
-- ============================================

SELECT 
    c.nombre AS capacitacion_normativa,
    c.fecha_inicio,
    c.fecha_fin,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(DISTINCT p.id_empleado) AS empleados_inscritos,
    SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) AS empleados_completados,
    (COUNT(DISTINCT e.id_empleado) - COUNT(DISTINCT p.id_empleado)) AS empleados_sin_inscribir,
    ROUND((COUNT(DISTINCT p.id_empleado) / COUNT(DISTINCT e.id_empleado) * 100), 2) AS porcentaje_inscripcion,
    ROUND((SUM(CASE WHEN p.estado = 'Completado' THEN 1 ELSE 0 END) / COUNT(DISTINCT e.id_empleado) * 100), 2) AS porcentaje_cumplimiento
FROM capacitaciones c
CROSS JOIN empleados e
LEFT JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion AND e.id_empleado = p.id_empleado
WHERE c.tipo = 'Normativas'
  AND c.activo = TRUE
  AND e.activo = TRUE
GROUP BY c.id_capacitacion, c.nombre, c.fecha_inicio, c.fecha_fin
ORDER BY porcentaje_cumplimiento DESC;

-- ============================================
-- REPORTE 9: Análisis de Deserción
-- ============================================

SELECT 
    c.nombre AS capacitacion,
    c.tipo,
    c.modalidad,
    COUNT(p.id_participacion) AS total_inscritos,
    SUM(CASE WHEN p.estado = 'Abandonado' THEN 1 ELSE 0 END) AS abandonos,
    ROUND((SUM(CASE WHEN p.estado = 'Abandonado' THEN 1 ELSE 0 END) / COUNT(p.id_participacion) * 100), 2) AS tasa_desercion,
    ROUND(AVG(CASE WHEN p.estado = 'Abandonado' THEN p.porcentaje_asistencia ELSE NULL END), 2) AS promedio_asistencia_antes_abandono
FROM capacitaciones c
INNER JOIN participaciones p ON c.id_capacitacion = p.id_capacitacion
GROUP BY c.id_capacitacion, c.nombre, c.tipo, c.modalidad
HAVING COUNT(p.id_participacion) > 0
ORDER BY tasa_desercion DESC;

-- ============================================
-- REPORTE 10: Dashboard Ejecutivo
-- ============================================

SELECT 
    'DASHBOARD EJECUTIVO - SISTEMA DE CAPACITACIONES' AS titulo,
    (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) AS empleados_activos,
    (SELECT COUNT(*) FROM capacitaciones WHERE activo = TRUE) AS capacitaciones_activas,
    (SELECT COUNT(*) FROM participaciones) AS total_participaciones,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'Completado') AS participaciones_completadas,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'En Curso') AS participaciones_en_curso,
    (SELECT COUNT(*) FROM participaciones WHERE estado = 'Inscrito') AS participaciones_pendientes,
    (SELECT ROUND(AVG(porcentaje_asistencia), 2) FROM participaciones) AS promedio_asistencia_general,
    (SELECT SUM(duracion_horas) FROM capacitaciones WHERE activo = TRUE) AS total_horas_disponibles,
    (SELECT COUNT(DISTINCT id_empleado) FROM participaciones) AS empleados_con_capacitaciones,
    (SELECT ROUND((COUNT(DISTINCT id_empleado) / (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) * 100), 2) 
     FROM participaciones) AS porcentaje_cobertura;

SELECT 'Reportes ejecutados exitosamente' AS mensaje;
