-- ============================================
-- SCRIPT: Creación de Índices
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- ÍNDICES PARA TABLA: empleados
-- ============================================

-- Índice para búsquedas por nombre
CREATE INDEX idx_empleado_nombre ON empleados(nombre, apellido);

-- Índice para búsquedas por departamento
CREATE INDEX idx_empleado_departamento ON empleados(id_departamento);

-- Índice para filtrar empleados activos
CREATE INDEX idx_empleado_activo ON empleados(activo);

-- Índice para búsquedas por fecha de ingreso
CREATE INDEX idx_empleado_fecha_ingreso ON empleados(fecha_ingreso);

-- ============================================
-- ÍNDICES PARA TABLA: capacitaciones
-- ============================================

-- Índice para búsquedas por tipo y modalidad
CREATE INDEX idx_capacitacion_tipo ON capacitaciones(tipo);
CREATE INDEX idx_capacitacion_modalidad ON capacitaciones(modalidad);

-- Índice compuesto para filtros comunes
CREATE INDEX idx_capacitacion_tipo_modalidad ON capacitaciones(tipo, modalidad);

-- Índice para búsquedas por fechas
CREATE INDEX idx_capacitacion_fechas ON capacitaciones(fecha_inicio, fecha_fin);

-- Índice para filtrar capacitaciones activas
CREATE INDEX idx_capacitacion_activo ON capacitaciones(activo);

-- Índice para búsquedas por entidad capacitadora
CREATE INDEX idx_capacitacion_entidad ON capacitaciones(id_entidad);

-- ============================================
-- ÍNDICES PARA TABLA: participaciones
-- ============================================

-- Índice para búsquedas por empleado
CREATE INDEX idx_participacion_empleado ON participaciones(id_empleado);

-- Índice para búsquedas por capacitación
CREATE INDEX idx_participacion_capacitacion ON participaciones(id_capacitacion);

-- Índice para filtrar por estado
CREATE INDEX idx_participacion_estado ON participaciones(estado);

-- Índice compuesto para reportes comunes
CREATE INDEX idx_participacion_empleado_estado ON participaciones(id_empleado, estado);

-- Índice para búsquedas por fecha de inscripción
CREATE INDEX idx_participacion_fecha_inscripcion ON participaciones(fecha_inscripcion);

-- ============================================
-- ÍNDICES PARA TABLA: entidades_capacitadoras
-- ============================================

-- Índice para búsquedas por tipo
CREATE INDEX idx_entidad_tipo ON entidades_capacitadoras(tipo);

-- Índice para filtrar entidades activas
CREATE INDEX idx_entidad_activo ON entidades_capacitadoras(activo);

-- ============================================
-- Verificar índices creados
-- ============================================

-- Mostrar índices de cada tabla
SHOW INDEX FROM empleados;
SHOW INDEX FROM capacitaciones;
SHOW INDEX FROM participaciones;
SHOW INDEX FROM entidades_capacitadoras;

SELECT 'Índices creados exitosamente' AS mensaje;
