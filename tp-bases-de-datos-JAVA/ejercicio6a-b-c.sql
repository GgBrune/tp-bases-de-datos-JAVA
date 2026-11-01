USE calzados_sa;

-- Ejercicio 6.a. Devolver el N° más vendido por cada modelo de zapato.
SELECT vz.modelo, vz.numero AS numero_mas_vendido
FROM Vta_Zapato vz
GROUP BY vz.modelo, vz.numero
-- Suma la cantidad vendida de cada número en cada modelo. Después compara la suma con el total de todos los números de cada modelo.
-- Si suma >= total, devuelve ese número porque es el más vendido.
HAVING SUM(vz.cantidad_vta) >= ALL (SELECT SUM(vz2.cantidad_vta)
                                    FROM Vta_Zapato vz2
                                    WHERE vz2.modelo = vz.modelo
                                    GROUP BY vz2.numero);


-- Ejercicio 6.b. Listado de vendedores con sus ventas totales (monto total) durante 2025.
SELECT v.*, ve.monto FROM Vendedor v INNER JOIN Venta ve 
ON v.dni_vendedor = ve.dni_vendedor
WHERE fecha >= '2025/01/01' AND fecha <= '2025/12/31';


-- Ejercicio 6.c. Apellido y Nombre de los vendedores que no han tenido francos en enero de 2026.
SELECT v.apellido, v.nombre FROM Vendedor v
WHERE v.nro_vendedor NOT IN (SELECT f.nro_vendedor FROM Franco f WHERE fecha >= '2026/01/01' AND fecha <= '2026/01/31');


-- Ejercicio 6.d. DEFINIR CONSULTAS:

-- 6.d.1. Modelos con Stock > 25.
SELECT modelo, SUM(cantidad) AS stock_disponible
FROM Stock
GROUP BY modelo 
HAVING SUM(cantidad) > 25;

-- 6.d.2. Obtener los vendedores (nombre, apellido) junto a la descripción y fecha de sus francos.
SELECT v.dni_vendedor, v.nombre, v.apellido, f.fecha, f.observaciones
FROM Vendedor v
JOIN Franco f ON f.nro_vendedor = v.nro_vendedor;

-- 6.d.3. Obtener el producto más caro junto a su precio.
SELECT modelo, precio 
FROM Zapato
WHERE precio = (SELECT MAX(precio) FROM Zapato);

-- 6.d.4. Obtener el cliente (dni,apellido,nombre) que realizó la compra más grande, junto al monto.
SELECT c.dni_cliente, c.apellido, c.nombre, v.monto
FROM Cliente c
JOIN Venta v ON v.dni_cliente = c.dni_cliente
WHERE v.monto = (SELECT MAX(monto) FROM Venta);