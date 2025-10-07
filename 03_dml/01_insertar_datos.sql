-- ============================================
-- SCRIPT: Inserción de Datos
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- ============================================

USE gestion_capacitaciones;

-- ============================================
-- INSERTAR DEPARTAMENTOS
-- ============================================

INSERT INTO departamentos (nombre, descripcion) VALUES
('Recursos Humanos', 'Gestión del talento y desarrollo organizacional'),
('Tecnología', 'Desarrollo y soporte de sistemas informáticos'),
('Operaciones', 'Gestión de procesos operativos y logística'),
('Finanzas', 'Administración financiera y contabilidad'),
('Ventas', 'Gestión comercial y atención al cliente'),
('Marketing', 'Estrategias de comunicación y posicionamiento'),
('Administración', 'Gestión administrativa y servicios generales');

SELECT 'Departamentos insertados' AS mensaje;
SELECT * FROM departamentos;

-- ============================================
-- INSERTAR EMPLEADOS
-- ============================================

INSERT INTO empleados (rut, nombre, apellido, email, cargo, fecha_ingreso, id_departamento) VALUES
-- Recursos Humanos
('12345678-9', 'María', 'González', 'maria.gonzalez@empresa.cl', 'Jefe de RRHH', '2020-01-15', 1),
('23456789-0', 'Pedro', 'Martínez', 'pedro.martinez@empresa.cl', 'Analista de Capacitación', '2021-03-20', 1),

-- Tecnología
('34567890-1', 'Ana', 'López', 'ana.lopez@empresa.cl', 'Jefe de TI', '2019-06-10', 2),
('45678901-2', 'Carlos', 'Rodríguez', 'carlos.rodriguez@empresa.cl', 'Desarrollador Senior', '2020-08-05', 2),
('56789012-3', 'Laura', 'Fernández', 'laura.fernandez@empresa.cl', 'Analista de Sistemas', '2021-11-12', 2),
('67890123-4', 'Diego', 'Silva', 'diego.silva@empresa.cl', 'Soporte Técnico', '2022-02-28', 2),

-- Operaciones
('78901234-5', 'Carmen', 'Muñoz', 'carmen.munoz@empresa.cl', 'Jefe de Operaciones', '2018-04-15', 3),
('89012345-6', 'Roberto', 'Vargas', 'roberto.vargas@empresa.cl', 'Supervisor de Logística', '2020-09-01', 3),
('90123456-7', 'Patricia', 'Rojas', 'patricia.rojas@empresa.cl', 'Coordinador Operacional', '2021-05-18', 3),

-- Finanzas
('11223344-5', 'Jorge', 'Soto', 'jorge.soto@empresa.cl', 'Contador General', '2019-01-10', 4),
('22334455-6', 'Valentina', 'Castro', 'valentina.castro@empresa.cl', 'Analista Financiero', '2021-07-22', 4),

-- Ventas
('33445566-7', 'Andrés', 'Pérez', 'andres.perez@empresa.cl', 'Gerente de Ventas', '2018-11-05', 5),
('44556677-8', 'Francisca', 'Morales', 'francisca.morales@empresa.cl', 'Ejecutivo Comercial', '2020-03-15', 5),
('55667788-9', 'Sebastián', 'Herrera', 'sebastian.herrera@empresa.cl', 'Ejecutivo Comercial', '2021-09-20', 5),

-- Marketing
('66778899-0', 'Camila', 'Núñez', 'camila.nunez@empresa.cl', 'Jefe de Marketing', '2019-08-12', 6),
('77889900-1', 'Felipe', 'Gutiérrez', 'felipe.gutierrez@empresa.cl', 'Community Manager', '2022-01-10', 6),

-- Administración
('88990011-2', 'Isabel', 'Ramírez', 'isabel.ramirez@empresa.cl', 'Jefe Administrativo', '2018-05-20', 7),
('99001122-3', 'Rodrigo', 'Torres', 'rodrigo.torres@empresa.cl', 'Asistente Administrativo', '2021-12-01', 7);

SELECT 'Empleados insertados' AS mensaje;
SELECT COUNT(*) AS total_empleados FROM empleados;

-- ============================================
-- INSERTAR ENTIDADES CAPACITADORAS
-- ============================================

INSERT INTO entidades_capacitadoras (nombre, tipo, contacto, email, telefono, especialidad) VALUES
('OTEC Capacita Chile', 'OTEC', 'Juan Pérez', 'contacto@capacitachile.cl', '+56912345678', 'Capacitaciones técnicas y normativas'),
('Universidad Técnica', 'Universidad', 'María Silva', 'extension@utecnica.cl', '+56987654321', 'Programas de especialización'),
('Consultora Desarrollo Humano', 'Consultora', 'Pedro González', 'info@desarrollohumano.cl', '+56911223344', 'Habilidades blandas y liderazgo'),
('Centro de Formación Mutual', 'OTEC', 'Ana Martínez', 'formacion@mutual.cl', '+56922334455', 'Prevención de riesgos y seguridad'),
('Capacitación Interna', 'Interna', 'Departamento RRHH', 'capacitacion@empresa.cl', '+56933445566', 'Inducción y procesos internos');

SELECT 'Entidades capacitadoras insertadas' AS mensaje;
SELECT * FROM entidades_capacitadoras;

-- ============================================
-- INSERTAR CAPACITACIONES
-- ============================================

INSERT INTO capacitaciones (codigo, nombre, descripcion, tipo, modalidad, duracion_horas, fecha_inicio, fecha_fin, cupos_maximos, id_entidad) VALUES
-- Técnicas
('CAP-TEC-001', 'Excel Avanzado para Análisis de Datos', 'Curso de Excel con tablas dinámicas, macros y análisis avanzado', 'Técnicas', 'Online Asincrónico', 40.0, '2025-01-15', '2025-02-15', 25, 1),
('CAP-TEC-002', 'Programación Python Básico', 'Introducción a la programación con Python', 'Técnicas', 'Online Sincrónico', 60.0, '2025-02-01', '2025-03-15', 20, 2),
('CAP-TEC-003', 'Power BI para Reportería', 'Creación de dashboards y reportes interactivos', 'Técnicas', 'Presencial', 32.0, '2025-03-10', '2025-04-10', 15, 1),

-- Habilidades Blandas
('CAP-HB-001', 'Liderazgo y Gestión de Equipos', 'Desarrollo de habilidades de liderazgo efectivo', 'Habilidades Blandas', 'Presencial', 24.0, '2025-01-20', '2025-02-20', 30, 3),
('CAP-HB-002', 'Comunicación Efectiva', 'Técnicas de comunicación asertiva y presentaciones', 'Habilidades Blandas', 'Online Sincrónico', 16.0, '2025-02-15', '2025-03-01', 35, 3),
('CAP-HB-003', 'Trabajo en Equipo y Colaboración', 'Dinámicas de trabajo colaborativo', 'Habilidades Blandas', 'Presencial', 12.0, '2025-03-05', '2025-03-19', 25, 3),

-- Mutual (Prevención de Riesgos)
('CAP-MUT-001', 'Prevención de Riesgos Laborales', 'Normativa y prácticas de seguridad en el trabajo', 'Mutual', 'Presencial', 20.0, '2025-01-10', '2025-01-31', 40, 4),
('CAP-MUT-002', 'Primeros Auxilios Básicos', 'Técnicas de primeros auxilios y RCP', 'Mutual', 'Presencial', 16.0, '2025-02-10', '2025-02-24', 20, 4),

-- Optativas
('CAP-OPT-001', 'Inglés Empresarial Nivel Intermedio', 'Inglés aplicado al contexto laboral', 'Optativas', 'Online Asincrónico', 80.0, '2025-01-08', '2025-04-08', 30, 2),
('CAP-OPT-002', 'Gestión del Tiempo y Productividad', 'Técnicas para optimizar el tiempo laboral', 'Optativas', 'Online Sincrónico', 8.0, '2025-02-20', '2025-02-27', 50, 3),

-- Normativas
('CAP-NOR-001', 'Ley de Protección de Datos Personales', 'Cumplimiento normativo de protección de datos', 'Normativas', 'Online Asincrónico', 12.0, '2025-01-05', '2025-01-26', 100, 5),
('CAP-NOR-002', 'Código de Ética Empresarial', 'Principios éticos y conducta organizacional', 'Normativas', 'Online Asincrónico', 6.0, '2025-01-15', '2025-01-29', 100, 5),
('CAP-NOR-003', 'Prevención de Acoso Laboral', 'Protocolo y normativa de prevención de acoso', 'Normativas', 'Online Sincrónico', 4.0, '2025-02-05', '2025-02-05', 80, 5);

SELECT 'Capacitaciones insertadas' AS mensaje;
SELECT COUNT(*) AS total_capacitaciones FROM capacitaciones;

-- ============================================
-- INSERTAR PARTICIPACIONES
-- ============================================

-- Capacitaciones Normativas (obligatorias para todos)
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia) VALUES
-- CAP-NOR-001: Ley de Protección de Datos
(1, 11, '2025-01-02', 'Completado', 100.00),
(2, 11, '2025-01-02', 'Completado', 100.00),
(3, 11, '2025-01-02', 'En Curso', 75.00),
(4, 11, '2025-01-02', 'Completado', 100.00),
(5, 11, '2025-01-02', 'En Curso', 80.00),
(6, 11, '2025-01-02', 'Inscrito', 0.00),

-- CAP-NOR-002: Código de Ética
(1, 12, '2025-01-10', 'Completado', 100.00),
(2, 12, '2025-01-10', 'En Curso', 50.00),
(3, 12, '2025-01-10', 'Completado', 100.00),

-- Capacitaciones Técnicas
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia) VALUES
-- Excel Avanzado
(2, 1, '2025-01-10', 'En Curso', 60.00),
(11, 1, '2025-01-10', 'En Curso', 55.00),
(17, 1, '2025-01-10', 'En Curso', 70.00),

-- Python Básico
(4, 2, '2025-01-25', 'Inscrito', 0.00),
(5, 2, '2025-01-25', 'Inscrito', 0.00),

-- Power BI
(10, 3, '2025-03-01', 'Inscrito', 0.00),
(11, 3, '2025-03-01', 'Inscrito', 0.00);

-- Habilidades Blandas
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia) VALUES
-- Liderazgo
(1, 4, '2025-01-15', 'En Curso', 45.00),
(3, 4, '2025-01-15', 'En Curso', 50.00),
(7, 4, '2025-01-15', 'En Curso', 40.00),
(12, 4, '2025-01-15', 'En Curso', 48.00),

-- Comunicación Efectiva
(13, 5, '2025-02-10', 'Inscrito', 0.00),
(14, 5, '2025-02-10', 'Inscrito', 0.00),
(15, 5, '2025-02-10', 'Inscrito', 0.00);

-- Mutual
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia) VALUES
-- Prevención de Riesgos
(7, 7, '2025-01-05', 'Completado', 100.00),
(8, 7, '2025-01-05', 'Completado', 100.00),
(9, 7, '2025-01-05', 'Completado', 95.00),

-- Primeros Auxilios
(6, 8, '2025-02-05', 'Inscrito', 0.00),
(8, 8, '2025-02-05', 'Inscrito', 0.00);

-- Optativas
INSERT INTO participaciones (id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia) VALUES
-- Inglés Empresarial
(13, 9, '2025-01-05', 'En Curso', 35.00),
(14, 9, '2025-01-05', 'En Curso', 40.00),

-- Gestión del Tiempo
(2, 10, '2025-02-15', 'Inscrito', 0.00),
(5, 10, '2025-02-15', 'Inscrito', 0.00),
(11, 10, '2025-02-15', 'Inscrito', 0.00);

SELECT 'Participaciones insertadas' AS mensaje;
SELECT COUNT(*) AS total_participaciones FROM participaciones;

-- ============================================
-- RESUMEN DE DATOS INSERTADOS
-- ============================================

SELECT 
    'RESUMEN DE DATOS INSERTADOS' AS titulo,
    (SELECT COUNT(*) FROM departamentos) AS departamentos,
    (SELECT COUNT(*) FROM empleados) AS empleados,
    (SELECT COUNT(*) FROM entidades_capacitadoras) AS entidades,
    (SELECT COUNT(*) FROM capacitaciones) AS capacitaciones,
    (SELECT COUNT(*) FROM participaciones) AS participaciones;
