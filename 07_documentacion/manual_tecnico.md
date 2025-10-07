# Manual Técnico - Sistema de Gestión de Capacitaciones

## 1. Introducción

### 1.1 Propósito
Este documento describe la arquitectura técnica, diseño de base de datos y componentes del Sistema de Gestión de Capacitaciones.

### 1.2 Alcance
El sistema permite gestionar capacitaciones organizacionales, incluyendo:
- Registro de empleados y departamentos
- Gestión de capacitaciones por tipo y modalidad
- Seguimiento de participación y progreso
- Generación de reportes

## 2. Arquitectura del Sistema

### 2.1 Tecnologías Utilizadas
- **SGBD**: MySQL 8.0+
- **Lenguaje**: SQL (DDL, DML, DCL)
- **Modelo**: Relacional normalizado (3NF)

### 2.2 Componentes
1. Base de datos relacional
2. Tablas de datos
3. Vistas para reportes
4. Triggers para automatización
5. Índices para optimización

## 3. Modelo de Datos

### 3.1 Diagrama Entidad-Relación

```
[DEPARTAMENTOS] 1---N [EMPLEADOS] 1---N [PARTICIPACIONES] N---1 [CAPACITACIONES] N---1 [ENTIDADES_CAPACITADORAS]
```

### 3.2 Normalización
El modelo está normalizado hasta la **Tercera Forma Normal (3NF)**:
- **1NF**: Todos los atributos son atómicos
- **2NF**: No hay dependencias parciales
- **3NF**: No hay dependencias transitivas

## 4. Descripción de Tablas

### 4.1 departamentos
Almacena las áreas organizacionales.

**Campos:**
- `id_departamento` (PK): Identificador único
- `nombre`: Nombre del departamento (UNIQUE)
- `descripcion`: Descripción del departamento
- `fecha_creacion`: Fecha de creación del registro

### 4.2 empleados
Almacena información del personal.

**Campos:**
- `id_empleado` (PK): Identificador único
- `rut` (UNIQUE): RUT del empleado
- `nombre`: Nombre del empleado
- `apellido`: Apellido del empleado
- `email` (UNIQUE): Correo electrónico
- `cargo`: Cargo del empleado
- `fecha_ingreso`: Fecha de ingreso a la empresa
- `activo`: Estado del empleado (TRUE/FALSE)
- `id_departamento` (FK): Referencia a departamentos

### 4.3 entidades_capacitadoras
Almacena información de OTEC y proveedores.

**Campos:**
- `id_entidad` (PK): Identificador único
- `nombre`: Nombre de la entidad
- `tipo`: Tipo (OTEC, Universidad, Consultora, Interna)
- `contacto`: Persona de contacto
- `email` (UNIQUE): Correo electrónico
- `telefono`: Teléfono de contacto
- `especialidad`: Área de especialización
- `activo`: Estado de la entidad

### 4.4 capacitaciones
Almacena información de cursos y programas.

**Campos:**
- `id_capacitacion` (PK): Identificador único
- `codigo` (UNIQUE): Código de la capacitación
- `nombre`: Nombre de la capacitación
- `descripcion`: Descripción detallada
- `tipo`: Tipo (Técnicas, Habilidades Blandas, Mutual, Optativas, Normativas)
- `modalidad`: Modalidad (Presencial, Online Sincrónico, Online Asincrónico)
- `duracion_horas`: Duración en horas
- `fecha_inicio`: Fecha de inicio
- `fecha_fin`: Fecha de finalización
- `cupos_maximos`: Número máximo de participantes
- `id_entidad` (FK): Referencia a entidades_capacitadoras
- `activo`: Estado de la capacitación

### 4.5 participaciones
Almacena inscripciones y seguimiento.

**Campos:**
- `id_participacion` (PK): Identificador único
- `id_empleado` (FK): Referencia a empleados
- `id_capacitacion` (FK): Referencia a capacitaciones
- `fecha_inscripcion`: Fecha de inscripción
- `estado`: Estado (Inscrito, En Curso, Completado, Abandonado)
- `porcentaje_asistencia`: Porcentaje de asistencia (0-100)
- `fecha_completado`: Fecha de completado
- `observaciones`: Observaciones adicionales

## 5. Restricciones de Integridad

### 5.1 Claves Primarias
Todas las tablas tienen clave primaria auto-incremental.

### 5.2 Claves Foráneas
- `empleados.id_departamento` → `departamentos.id_departamento`
- `capacitaciones.id_entidad` → `entidades_capacitadoras.id_entidad`
- `participaciones.id_empleado` → `empleados.id_empleado`
- `participaciones.id_capacitacion` → `capacitaciones.id_capacitacion`

**Políticas:**
- ON DELETE RESTRICT: No permite eliminar si hay dependencias
- ON UPDATE CASCADE: Propaga actualizaciones

### 5.3 Restricciones CHECK
- `porcentaje_asistencia BETWEEN 0 AND 100`
- `duracion_horas > 0`
- `cupos_maximos > 0`
- `fecha_fin >= fecha_inicio`
- `precio > 0` (si aplica)

### 5.4 Restricciones UNIQUE
- `empleados.rut`
- `empleados.email`
- `capacitaciones.codigo`
- `entidades_capacitadoras.email`
- `(id_empleado, id_capacitacion)` en participaciones

## 6. Índices

### 6.1 Índices en empleados
- `idx_empleado_nombre`: (nombre, apellido)
- `idx_empleado_departamento`: (id_departamento)
- `idx_empleado_activo`: (activo)

### 6.2 Índices en capacitaciones
- `idx_capacitacion_tipo`: (tipo)
- `idx_capacitacion_modalidad`: (modalidad)
- `idx_capacitacion_fechas`: (fecha_inicio, fecha_fin)

### 6.3 Índices en participaciones
- `idx_participacion_empleado`: (id_empleado)
- `idx_participacion_capacitacion`: (id_capacitacion)
- `idx_participacion_estado`: (estado)

## 7. Vistas

### 7.1 vista_empleados_capacitaciones
Información completa de empleados y sus capacitaciones.

### 7.2 vista_capacitaciones_disponibles
Capacitaciones activas con cupos disponibles.

### 7.3 vista_progreso_departamentos
Estadísticas de capacitación por departamento.

### 7.4 vista_ranking_participacion
Ranking de empleados más capacitados.

## 8. Triggers

### 8.1 validar_cupos_antes_inscripcion
Valida que haya cupos disponibles antes de inscribir.

### 8.2 actualizar_estado_por_asistencia
Actualiza el estado según el porcentaje de asistencia.

### 8.3 registrar_fecha_completado
Registra automáticamente la fecha al completar.

### 8.4 validar_fechas_capacitacion
Valida que las fechas sean coherentes.

## 9. Seguridad

### 9.1 Usuarios y Permisos
Se recomienda crear usuarios con permisos específicos:
- **admin**: Todos los permisos
- **rrhh**: SELECT, INSERT, UPDATE en todas las tablas
- **consulta**: Solo SELECT en vistas

### 9.2 Respaldos
Se recomienda realizar respaldos diarios:
```bash
mysqldump -u root -p gestion_capacitaciones > backup_$(date +%Y%m%d).sql
```

## 10. Mantenimiento

### 10.1 Optimización
- Ejecutar ANALYZE TABLE periódicamente
- Revisar y optimizar índices
- Limpiar datos antiguos

### 10.2 Monitoreo
- Revisar logs de errores
- Monitorear rendimiento de consultas
- Verificar integridad referencial

## 11. Contacto Técnico

Para soporte técnico o consultas sobre el sistema, contactar al equipo de desarrollo.

---
**Versión**: 1.0  
**Fecha**: Octubre 2025
