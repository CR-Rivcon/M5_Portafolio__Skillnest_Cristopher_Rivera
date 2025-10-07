# 02 - DDL (Data Definition Language)

## Descripción

Scripts SQL para la creación de la base de datos y todas las tablas del sistema.

## Contenido

- `01_crear_base_datos.sql`: Creación de la base de datos
- `02_crear_tablas.sql`: Creación de todas las tablas con restricciones
- `03_indices.sql`: Índices para optimización de consultas

## Orden de Ejecución

1. Ejecutar `01_crear_base_datos.sql`
2. Ejecutar `02_crear_tablas.sql`
3. Ejecutar `03_indices.sql`

## Características Implementadas

- Claves primarias auto-incrementales
- Claves foráneas con integridad referencial
- Restricciones CHECK para validación
- Restricciones UNIQUE para evitar duplicados
- Tipos de datos apropiados (ENUM, DATE, DECIMAL)
- Valores por defecto
- Índices para mejorar rendimiento

## Comandos para Ejecutar

```bash
# MySQL
mysql -u root -p < 01_crear_base_datos.sql
mysql -u root -p gestion_capacitaciones < 02_crear_tablas.sql
mysql -u root -p gestion_capacitaciones < 03_indices.sql
```
