# 05 - Transacciones SQL

## Descripción

Scripts que demuestran el uso de transacciones para garantizar la integridad de los datos.

## Contenido

- `01_transacciones_basicas.sql`: Ejemplos de BEGIN, COMMIT, ROLLBACK
- `02_transacciones_complejas.sql`: Transacciones con múltiples operaciones

## Conceptos Implementados

### Propiedades ACID
- **Atomicidad**: Todas las operaciones se ejecutan o ninguna
- **Consistencia**: La base de datos mantiene su integridad
- **Aislamiento**: Las transacciones no interfieren entre sí
- **Durabilidad**: Los cambios confirmados son permanentes

### Operaciones
- BEGIN TRANSACTION / START TRANSACTION
- COMMIT (confirmar cambios)
- ROLLBACK (revertir cambios)
- SAVEPOINT (puntos de guardado)

## Comandos para Ejecutar

```bash
mysql -u root -p gestion_capacitaciones < 01_transacciones_basicas.sql
mysql -u root -p gestion_capacitaciones < 02_transacciones_complejas.sql
```
