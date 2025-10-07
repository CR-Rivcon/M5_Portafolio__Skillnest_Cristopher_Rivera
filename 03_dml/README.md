# 03 - DML (Data Manipulation Language)

## Descripción

Scripts SQL para inserción, actualización y eliminación de datos en el sistema.

## Contenido

- `01_insertar_datos.sql`: Datos iniciales de ejemplo
- `02_actualizar_datos.sql`: Ejemplos de UPDATE
- `03_eliminar_datos.sql`: Ejemplos de DELETE

## Orden de Ejecución

1. Ejecutar `01_insertar_datos.sql` (datos iniciales)
2. Ejecutar `02_actualizar_datos.sql` (actualizaciones)
3. Ejecutar `03_eliminar_datos.sql` (eliminaciones)

## Operaciones Implementadas

### INSERT
- Inserción de departamentos
- Inserción de empleados
- Inserción de entidades capacitadoras
- Inserción de capacitaciones
- Inscripción de empleados en capacitaciones

### UPDATE
- Actualizar estado de participación
- Actualizar porcentaje de asistencia
- Modificar datos de empleados
- Actualizar información de capacitaciones

### DELETE
- Eliminar participaciones
- Dar de baja empleados (lógica)
- Desactivar capacitaciones

## Comandos para Ejecutar

```bash
mysql -u root -p gestion_capacitaciones < 01_insertar_datos.sql
mysql -u root -p gestion_capacitaciones < 02_actualizar_datos.sql
mysql -u root -p gestion_capacitaciones < 03_eliminar_datos.sql
```
