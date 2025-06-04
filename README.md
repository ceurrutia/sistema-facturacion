# Sistema de Facturación - MySQL

### Descripción:
Proyecto completo que simula un sistema de facturación en MySQL para prácticas de:
- Procedimientos almacenados
- Funciones y vistas
- Base de datos de contactos con triggers y una función.

### Tecnologías:
- MySQL 8.x
-MySQL Workbench

### Estructura:
1. Creación de base de datos
2. Tablas y datos de ejemplo
3. Funciones y procedimientos
4. Vistas de reportes


### Cómo probar:
1. Ejecutar `sistema-facturacion.sql`
3. Ver la vista `VistaFacturasConIVA`
4. Llamar al procedimiento:
CALL ReporteFacturacionMensual();

1. Ejecutar `db_empresa.sql`
3. Ver los triggers de auditoría con: `SHOW TRIGGERS LIKE 'contactos'`;
4. Ejecutar `SELECT * FROM contactos_auditoria WHERE accion = 'UPDATE';`
5. Ejecutar `SELECT * FROM contactos_auditoria WHERE accion = 'DELETE';`