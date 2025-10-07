-- ============================================
-- SCRIPT: Creación de Base de Datos
-- PROYECTO: Sistema de Gestión de Capacitaciones
-- AUTOR: [Tu Nombre]
-- FECHA: Octubre 2025
-- ============================================

-- Eliminar base de datos si existe (solo para desarrollo)
DROP DATABASE IF EXISTS gestion_capacitaciones;

-- Crear base de datos
CREATE DATABASE gestion_capacitaciones
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE gestion_capacitaciones;

-- Verificar creación
SELECT 'Base de datos creada exitosamente' AS mensaje;

-- Mostrar información de la base de datos
SHOW DATABASES LIKE 'gestion_capacitaciones';
