# Sistema de Gestión de Capacitaciones

## 📋 Descripción del Proyecto

Sistema de base de datos relacional para la gestión integral de capacitaciones en una organización, permitiendo el seguimiento de empleados, cursos, entidades capacitadoras (OTEC) y el progreso de los participantes.

## 🎯 Objetivo

Facilitar la administración y seguimiento de capacitaciones organizacionales, permitiendo:
- Registro de empleados y departamentos
- Gestión de capacitaciones por modalidad y tipo
- Seguimiento de participación y progreso
- Generación de reportes de cumplimiento

## 🏗️ Estructura del Proyecto

```
proyecto_capacitaciones/
├── 01_modelado/          # Modelo Entidad-Relación y diseño
├── 02_ddl/               # Scripts de creación de base de datos
├── 03_dml/               # Scripts de inserción y manipulación
├── 04_consultas/         # Consultas SQL (SELECT)
├── 05_transacciones/     # Manejo de transacciones
├── 06_vistas_triggers/   # Vistas y triggers
├── 07_documentacion/     # Documentación técnica
└── README.md             # Este archivo
```

## 📊 Modelo de Datos

### Entidades Principales

1. **departamentos**: Áreas organizacionales
2. **empleados**: Personal de la organización
3. **entidades_capacitadoras**: OTEC y proveedores de capacitación
4. **capacitaciones**: Cursos y programas de formación
5. **participaciones**: Inscripciones y seguimiento de progreso

### Características del Sistema

**Modalidades de Capacitación:**
- Presencial
- Online Sincrónico
- Online Asincrónico

**Tipos de Capacitación:**
- Técnicas
- Habilidades Blandas
- Mutual
- Optativas
- Normativas

**Estados de Participación:**
- Inscrito
- En Curso
- Completado
- Abandonado

## 🚀 Instalación y Uso

### Requisitos Previos
- MySQL 8.0 o superior / PostgreSQL 12+
- Cliente SQL (MySQL Workbench, DBeaver, pgAdmin, etc.)

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/CR-Rivcon/M5_Portafolio__Skillnest_Cristopher_Rivera.git
```

2. **Crear la base de datos**
```bash
mysql -u root -p < 02_ddl/01_crear_base_datos.sql
```

3. **Crear las tablas**
```bash
mysql -u root -p gestion_capacitaciones < 02_ddl/02_crear_tablas.sql
```

4. **Cargar datos de ejemplo**
```bash
mysql -u root -p gestion_capacitaciones < 03_dml/01_insertar_datos.sql
```

5. **Ejecutar consultas de prueba**
```bash
mysql -u root -p gestion_capacitaciones < 04_consultas/01_consultas_basicas.sql
```

## 📈 Funcionalidades Implementadas

### ✅ Requerimientos Cumplidos

- [x] Modelo Entidad-Relación completo
- [x] Tablas con claves primarias y foráneas
- [x] Restricciones de integridad referencial
- [x] Consultas SQL básicas y complejas (SELECT, WHERE, JOIN, GROUP BY)
- [x] Operaciones DML (INSERT, UPDATE, DELETE)
- [x] Lenguaje DDL (CREATE, ALTER, DROP)
- [x] Transacciones con COMMIT y ROLLBACK
- [x] Vistas para reportes
- [x] Triggers para automatización
- [x] Normalización hasta 3NF

## 📊 Reportes Disponibles

1. **Capacitaciones por Empleado**: Lista de cursos tomados por cada empleado
2. **Participantes por Capacitación**: Empleados inscritos en cada curso
3. **Progreso por Departamento**: Estadísticas de cumplimiento por área
4. **Capacitaciones Pendientes**: Cursos no completados
5. **Ranking de Participación**: Empleados más capacitados
6. **Reporte por OTEC**: Capacitaciones por entidad capacitadora

## 🛠️ Tecnologías Utilizadas

- **SGBD**: MySQL 8.0
- **Lenguaje**: SQL (DDL, DML, DCL)
- **Modelado**: Modelo Entidad-Relación
- **Normalización**: Tercera Forma Normal (3NF)

## 👨‍💻 Autor

Proyecto desarrollado como parte del portafolio de competencias en Gestión de Bases de Datos Relacionales por Cristopher Rivera.



**Última actualización**: Octubre 2025
