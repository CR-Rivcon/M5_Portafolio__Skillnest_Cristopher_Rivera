-- ============================================
-- SCRIPT: Consultas Básicas
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- CONSULTAS SIMPLES - TABLA EMPLEADOS
-- ============================================

-- Consulta 1: Todos los empleados
SELECT * FROM empleados;

-- Consulta 2: Empleados activos
SELECT id_empleado, nombre, apellido, cargo, email
FROM empleados
WHERE activo = TRUE;

-- Consulta 3: Empleados de un departamento específico
SELECT nombre, apellido, cargo
FROM empleados
WHERE id_departamento = 2;

-- Consulta 4: Empleados por cargo
SELECT nombre, apellido, email
FROM empleados
WHERE cargo LIKE '%Jefe%'
ORDER BY apellido;

-- Consulta 5: Empleados ingresados en un año específico
SELECT nombre, apellido, fecha_ingreso
FROM empleados
WHERE YEAR(fecha_ingreso) = 2021
ORDER BY fecha_ingreso;

-- ============================================
-- CONSULTAS SIMPLES - TABLA CAPACITACIONES
-- ============================================

-- Consulta 6: Todas las capacitaciones activas
SELECT codigo, nombre, tipo, modalidad, duracion_horas
FROM capacitaciones
WHERE activo = TRUE;

-- Consulta 7: Capacitaciones por modalidad
SELECT nombre, duracion_horas, fecha_inicio, fecha_fin
FROM capacitaciones
WHERE modalidad = 'Online Asincrónico'
ORDER BY fecha_inicio;

-- Consulta 8: Capacitaciones por tipo
SELECT codigo, nombre, duracion_horas
FROM capacitaciones
WHERE tipo = 'Técnicas'
ORDER BY duracion_horas DESC;

-- Consulta 9: Capacitaciones en curso (entre fechas)
SELECT nombre, fecha_inicio, fecha_fin, cupos_maximos
FROM capacitaciones
WHERE CURRENT_DATE BETWEEN fecha_inicio AND fecha_fin;

-- Consulta 10: Capacitaciones de corta duración
SELECT nombre, duracion_horas, modalidad
FROM capacitaciones
WHERE duracion_horas <= 20
ORDER BY duracion_horas;

-- ============================================
-- CONSULTAS SIMPLES - TABLA PARTICIPACIONES
-- ============================================

-- Consulta 11: Participaciones completadas
SELECT id_empleado, id_capacitacion, fecha_completado, porcentaje_asistencia
FROM participaciones
WHERE estado = 'Completado';

-- Consulta 12: Participaciones en curso
SELECT id_empleado, id_capacitacion, estado, porcentaje_asistencia
FROM participaciones
WHERE estado = 'En Curso'
ORDER BY porcentaje_asistencia DESC;

-- Consulta 13: Participaciones con alta asistencia
SELECT id_empleado, id_capacitacion, porcentaje_asistencia
FROM participaciones
WHERE porcentaje_asistencia >= 80;

-- Consulta 14: Participaciones abandonadas
SELECT id_empleado, id_capacitacion, observaciones
FROM participaciones
WHERE estado = 'Abandonado';

-- ============================================
-- CONSULTAS CON OPERADORES LÓGICOS
-- ============================================

-- Consulta 15: Capacitaciones técnicas presenciales
SELECT nombre, tipo, modalidad, duracion_horas
FROM capacitaciones
WHERE tipo = 'Técnicas' AND modalidad = 'Presencial';

-- Consulta 16: Capacitaciones online (sincrónico o asincrónico)
SELECT nombre, modalidad, fecha_inicio
FROM capacitaciones
WHERE modalidad IN ('Online Sincrónico', 'Online Asincrónico')
ORDER BY fecha_inicio;

-- Consulta 17: Empleados de múltiples departamentos
SELECT nombre, apellido, id_departamento
FROM empleados
WHERE id_departamento IN (1, 2, 5)
ORDER BY id_departamento, apellido;

-- ============================================
-- CONSULTAS CON LIKE (BÚSQUEDAS)
-- ============================================

-- Consulta 18: Buscar capacitaciones por palabra clave
SELECT nombre, descripcion
FROM capacitaciones
WHERE nombre LIKE '%Excel%' OR descripcion LIKE '%Excel%';

-- Consulta 19: Buscar empleados por nombre
SELECT nombre, apellido, email
FROM empleados
WHERE nombre LIKE 'M%'
ORDER BY nombre;

-- Consulta 20: Buscar entidades OTEC
SELECT nombre, tipo, especialidad
FROM entidades_capacitadoras
WHERE tipo = 'OTEC';

-- ============================================
-- CONSULTAS CON ORDENAMIENTO Y LÍMITE
-- ============================================

-- Consulta 21: Top 5 capacitaciones más largas
SELECT nombre, duracion_horas, tipo
FROM capacitaciones
ORDER BY duracion_horas DESC
LIMIT 5;

-- Consulta 22: Últimos 10 empleados ingresados
SELECT nombre, apellido, fecha_ingreso, cargo
FROM empleados
ORDER BY fecha_ingreso DESC
LIMIT 10;

-- Consulta 23: Participaciones más recientes
SELECT id_empleado, id_capacitacion, fecha_inscripcion, estado
FROM participaciones
ORDER BY fecha_inscripcion DESC
LIMIT 10;

-- ============================================
-- CONSULTAS CON FUNCIONES DE FECHA
-- ============================================

-- Consulta 24: Capacitaciones del mes actual
SELECT nombre, fecha_inicio, fecha_fin
FROM capacitaciones
WHERE MONTH(fecha_inicio) = MONTH(CURRENT_DATE)
  AND YEAR(fecha_inicio) = YEAR(CURRENT_DATE);

-- Consulta 25: Empleados con más de 2 años en la empresa
SELECT nombre, apellido, fecha_ingreso,
       TIMESTAMPDIFF(YEAR, fecha_ingreso, CURRENT_DATE) AS años_antiguedad
FROM empleados
WHERE TIMESTAMPDIFF(YEAR, fecha_ingreso, CURRENT_DATE) > 2
ORDER BY fecha_ingreso;

SELECT 'Consultas básicas ejecutadas exitosamente' AS mensaje;
