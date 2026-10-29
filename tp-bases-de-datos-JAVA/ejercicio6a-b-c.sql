USE calzados_sa;

-- Ejercicio 6-a) Devolver el N° más vendido por cada modelo de zapato.
SELECT vz.modelo, vz.numero AS numero_mas_vendido
FROM Vta_Zapato vz
GROUP BY vz.modelo, vz.numero
-- suma la cantidad vendida de cada numero en cada modelo. Despues compara la suma con el total de todos los numeros de cada modelo 
-- si la suma es mayor o igual al total devuelve ese numero porque es el mas vendido 
HAVING SUM(vz.cantidad_vta) >= ALL (SELECT SUM(vz2.cantidad_vta)
                                    FROM Vta_Zapato vz2
                                    WHERE vz2.modelo = vz.modelo
                                    GROUP BY vz2.numero);

-- Ejercicio 6-b) Listado de vendedores con sus ventas totales(monto total) durante 2025.
SELECT v.*, ve.monto FROM Vendedor v INNER JOIN Venta ve 
ON v.dni_vendedor = ve.dni_vendedor
WHERE fecha >= '2025/01/01' AND fecha <= '2025/12/31';

-- Ejercicio 6-c) Apellido y Nombre de los vendedores que no han tenido francos en enero de 2026.
SELECT v.apellido, v.nombre FROM Vendedor v
WHERE v.nro_vendedor NOT IN (SELECT f.nro_vendedor FROM Franco f WHERE fecha >= '2026/01/01' AND fecha <= '2026/01/31');