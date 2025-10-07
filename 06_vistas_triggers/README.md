# 06 - Vistas y Triggers

## Descripción

Scripts para crear vistas (consultas guardadas) y triggers (automatizaciones).

## Contenido

- `01_crear_vistas.sql`: Vistas para reportes frecuentes
- `02_crear_triggers.sql`: Triggers para automatización y validación

## Vistas Implementadas

1. **vista_empleados_capacitaciones**: Información completa de empleados y sus capacitaciones
2. **vista_capacitaciones_disponibles**: Capacitaciones activas con cupos disponibles
3. **vista_progreso_departamentos**: Estadísticas por departamento
4. **vista_ranking_participacion**: Ranking de empleados más capacitados

## Triggers Implementados

1. **validar_cupos_antes_inscripcion**: Valida cupos disponibles antes de inscribir
2. **actualizar_estado_por_asistencia**: Actualiza estado según asistencia
3. **registrar_fecha_completado**: Registra fecha al completar capacitación
4. **validar_fechas_capacitacion**: Valida que fecha_fin >= fecha_inicio

## Comandos para Ejecutar

```bash
mysql -u root -p gestion_capacitaciones < 01_crear_vistas.sql
mysql -u root -p gestion_capacitaciones < 02_crear_triggers.sql
```
