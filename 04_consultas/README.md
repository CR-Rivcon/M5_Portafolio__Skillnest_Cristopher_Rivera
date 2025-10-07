# 04 - Consultas SQL

## Descripción

Scripts SQL con consultas básicas y complejas para obtener información del sistema.

## Contenido

- `01_consultas_basicas.sql`: SELECT simples con WHERE
- `02_consultas_joins.sql`: Consultas con INNER JOIN y LEFT JOIN
- `03_consultas_agregacion.sql`: GROUP BY, COUNT, SUM, AVG
- `04_consultas_avanzadas.sql`: Subconsultas y consultas complejas
- `05_reportes.sql`: Consultas para reportes de negocio

## Tipos de Consultas Implementadas

### Consultas Básicas
- Selección de registros con filtros
- Ordenamiento y limitación de resultados
- Búsquedas con LIKE y operadores

### Consultas con JOINs
- INNER JOIN para relacionar tablas
- LEFT JOIN para incluir registros sin relación
- Múltiples JOINs en una consulta

### Consultas de Agregación
- COUNT para contar registros
- SUM para sumar valores
- AVG para promedios
- GROUP BY para agrupar resultados

### Consultas Avanzadas
- Subconsultas en WHERE
- Subconsultas en SELECT
- EXISTS y NOT EXISTS
- CASE para lógica condicional

## Comandos para Ejecutar

```bash
mysql -u root -p gestion_capacitaciones < 01_consultas_basicas.sql
mysql -u root -p gestion_capacitaciones < 02_consultas_joins.sql
mysql -u root -p gestion_capacitaciones < 03_consultas_agregacion.sql
mysql -u root -p gestion_capacitaciones < 04_consultas_avanzadas.sql
mysql -u root -p gestion_capacitaciones < 05_reportes.sql
```
