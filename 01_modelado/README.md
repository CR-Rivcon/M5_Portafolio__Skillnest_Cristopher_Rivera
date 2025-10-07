# 01 - Modelado de Datos

## Descripción

Esta carpeta contiene el modelo conceptual y lógico del sistema de gestión de capacitaciones.

## Contenido

- `modelo_er.txt`: Descripción textual del Modelo Entidad-Relación
- `modelo_relacional.txt`: Esquema del modelo relacional con claves

## Modelo Entidad-Relación

### Entidades

1. **DEPARTAMENTOS**
   - Representa las áreas organizacionales
   - Atributos: id, nombre, descripción

2. **EMPLEADOS**
   - Personal de la organización
   - Atributos: id, rut, nombre, apellido, email, cargo, fecha_ingreso, id_departamento

3. **ENTIDADES_CAPACITADORAS**
   - OTEC y proveedores de capacitación
   - Atributos: id, nombre, tipo, contacto, email, especialidad

4. **CAPACITACIONES**
   - Cursos y programas de formación
   - Atributos: id, nombre, descripción, tipo, modalidad, duracion_horas, fecha_inicio, fecha_fin, id_entidad

5. **PARTICIPACIONES**
   - Inscripciones y seguimiento
   - Atributos: id, id_empleado, id_capacitacion, fecha_inscripcion, estado, porcentaje_asistencia, observaciones

### Relaciones

- Un DEPARTAMENTO tiene muchos EMPLEADOS (1:N)
- Un EMPLEADO puede tener muchas PARTICIPACIONES (1:N)
- Una CAPACITACIÓN puede tener muchas PARTICIPACIONES (1:N)
- Una ENTIDAD_CAPACITADORA puede dictar muchas CAPACITACIONES (1:N)

## Normalización

El modelo está normalizado hasta la **Tercera Forma Normal (3NF)**:

- **1NF**: Todos los atributos son atómicos
- **2NF**: No hay dependencias parciales
- **3NF**: No hay dependencias transitivas

## Diagrama ER (Descripción Textual)

```
[DEPARTAMENTOS] 1---N [EMPLEADOS] 1---N [PARTICIPACIONES] N---1 [CAPACITACIONES] N---1 [ENTIDADES_CAPACITADORAS]
```

## Decisiones de Diseño

1. **Separación de entidades capacitadoras**: Permite gestionar múltiples OTEC
2. **Tabla de participaciones**: Facilita el seguimiento individual
3. **Enumeraciones**: Modalidad, tipo y estado como ENUM para integridad
4. **Porcentaje de asistencia**: Permite seguimiento cuantitativo sin notas
