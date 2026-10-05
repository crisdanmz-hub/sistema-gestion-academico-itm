# Sistema de Gestión Académica - Proyecto Bases de Datos ITM

Proyecto desarrollado para la gestión institucional con un modelo relacional de **12 tablas** integrado con **Python (pyodbc)** y **MySQL**.

## Estructura del Proyecto
- `db.sql`: Script completo de creación de la base de datos, 12 tablas, relaciones (FK) y procedimientos almacenados.
- `main.py`: Aplicación en consola orientada a objetos que consume la base de datos mediante consultas inline y Stored Procedures.

## Requisitos de Ejecución
1. Python 3.x instalado.
2. Driver ODBC para MySQL configurado (`MySQL ODBC 9.0 Unicode Driver`).
3. Instalar la librería requerida:
   ```bash
   pip install pyodbc
