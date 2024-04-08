-- consulta 1--
WITH MaxViajesPorAño AS (
    SELECT EXTRACT(YEAR FROM fecha_pasaje) AS año,
           destino_pasaje,
           COUNT(*) AS cantidad_de_viajes
    FROM Pasaje P
    INNER JOIN Cliente_Vuelo CV ON P.id_vuelo = CV.id_vuelo
    INNER JOIN Cliente C ON CV.id_cliente = C.id_cliente
    INNER JOIN Vuelo V ON P.id_vuelo = V.id_vuelo
    WHERE C.nacionalidad_cliente = 'Chileno'
      AND P.fecha_pasaje >= CURRENT_DATE - INTERVAL '3 years'
    GROUP BY EXTRACT(YEAR FROM fecha_pasaje), destino_pasaje
),
MaxViajesPorAñoTop AS (
    SELECT año,
           destino_pasaje,
           cantidad_de_viajes,
           ROW_NUMBER() OVER (PARTITION BY año ORDER BY cantidad_de_viajes DESC) AS ranking
    FROM MaxViajesPorAño
)
SELECT año, destino_pasaje, cantidad_de_viajes
FROM MaxViajesPorAñoTop
WHERE ranking = 1;

--consulta 2------

SELECT Seccion.nombre_seccion, COUNT(*) AS cantidad_pasajes
FROM Pasaje
INNER JOIN Cliente_Vuelo ON Pasaje.id_pasaje = Cliente_Vuelo.id_vuelo
INNER JOIN Seccion ON Pasaje.id_seccion = Seccion.id_seccion
INNER JOIN Cliente ON Cliente_Vuelo.id_cliente = Cliente.id_cliente
WHERE Cliente.nacionalidad_cliente = 'Argentino'
GROUP BY Seccion.nombre_seccion
ORDER BY cantidad_pasajes DESC;

--consulta 3-----

SELECT
    EXTRACT(YEAR FROM p.fecha_pasaje) AS año,
    EXTRACT(MONTH FROM p.fecha_pasaje) AS mes,
    p.origen_pasaje AS pais,
    SUM(c.valor_costo) AS total_gastado
FROM
    Pasaje p
JOIN
    Costo c ON p.id_costo = c.id_costo
WHERE
    p.fecha_pasaje >= CURRENT_DATE - interval '4 years'
GROUP BY
    año, mes, pais
ORDER BY
    año DESC, mes DESC, total_gastado DESC;

--consulta 4------

SELECT c.id_cliente, c.nombre_cliente AS nombre_cliente 
FROM Cliente c 
INNER JOIN Cliente_Vuelo cv ON c.id_cliente = cv.id_cliente
INNER JOIN Pasaje p ON cv.id_vuelo = p.id_vuelo 
INNER JOIN Seccion s ON p.id_seccion = s.id_seccion 
INNER JOIN Vuelo v ON p.id_vuelo = v.id_vuelo
WHERE c.nacionalidad_cliente = 'chileno' 
AND s.nombre_seccion = 'Primera Clase' 
AND p.fecha_pasaje >= CURRENT_DATE - INTERVAL '1 month' 
GROUP BY c.id_cliente, DATE_TRUNC('month', p.fecha_pasaje) HAVING COUNT(*) > 4;


--consulta 5------
SELECT id_avion
FROM Avion
WHERE vuelos_avion =( SELECT MIN(vuelos_avion)
		     FROM Avion);


--consulta 6
SELECT mes, anio, nombre_empleado, MAX(monto_sueldo)
FROM (SELECT *,
		EXTRACT(YEAR FROM fecha_pago_sueldo) as anio,
		EXTRACT (MONTH FROM fecha_pago_sueldo) as mes
		FROM empleado e INNER JOIN sueldo s
		ON e.id_sueldo = s.id_sueldo
		WHERE fecha_pago_sueldo >= current_date - interval '4 year'
	 	AND e.cargo_empleado = 'Piloto') as e_s
GROUP BY mes, anio, nombre_empleado
ORDER BY anio DESC, mes ASC;

--consulta 7---
SELECT C.id_compañia, C.nombre_compañia, A.id_avion, SUM(Co.valor_costo) AS ingresos_totales
FROM compañia C
JOIN Vuelo V on C.id_compañia = V.id_compañia
JOIN Avion A on V.id_avion = A.id_avion
JOIN Pasaje P on V.id_vuelo = P.id_vuelo
JOIN Costo Co ON P.id_costo = Co.id_costo
WHERE P.fecha_pasaje >= current_date - interval '4 years'
group by
C.nombre_compañia, A.id_avion, C.id_compañia
order by
ingresos_totales ASC;

--consulta 8-------
SELECT a.id_compañia,
EXTRACT(YEAR FROM p.fecha_pasaje) AS año, 
COUNT(a.id_avion) AS cant_aviones FROM Vuelo v 
JOIN Pasaje p ON v.id_vuelo = p.id_vuelo 
JOIN Avion a ON v.id_avion = a.id_avion 
WHERE p.fecha_pasaje >= CURRENT_DATE - interval '10 years' 
GROUP BY a.id_compañia, año ORDER BY a.id_compañia, año;


--consulta 9----------
SELECT Compañia.id_compañia, 
AVG(Sueldo.monto_sueldo) AS promedio_sueldo_anual 
FROM Compañia 
INNER JOIN Empleado ON Compañia.id_compañia = Empleado.id_empleado 
INNER JOIN Emp_vuelo ON Empleado.id_empleado = Emp_vuelo.id_empleado
INNER JOIN Sueldo ON Empleado.id_sueldo = Sueldo.id_sueldo 
GROUP BY Compañia.id_compañia, 
EXTRACT(YEAR FROM Sueldo.fecha_pago_sueldo)
HAVING EXTRACT(YEAR FROM Sueldo.fecha_pago_sueldo) >= EXTRACT(YEAR FROM CURRENT_DATE) - 10 ORDER BY promedio_sueldo_anual DESC;


--consulta 10--------------
WITH tabla1 AS (SELECT nombre_compañia, nombre_modelo, mo.id_modelo, COUNT(nombre_modelo) as total,
					EXTRACT(YEAR FROM fecha_pasaje) AS anio
					FROM avion av
					INNER JOIN compañia co ON av.id_compañia = co.id_compañia
					INNER JOIN modelo mo ON av.id_modelo = mo.id_modelo
					INNER JOIN vuelo v ON av.id_avion = v.id_avion
					INNER JOIN pasaje pa ON v.id_vuelo = pa.id_vuelo
					WHERE EXTRACT(YEAR FROM fecha_pasaje) = 2021
					 GROUP BY 1,2,3, 5),
tabla2 as (SELECT nombre_compañia, MAX(total) AS max_modelos
			FROM (SELECT nombre_compañia, nombre_modelo, mo.id_modelo, COUNT(nombre_modelo) as total,
					EXTRACT(YEAR FROM fecha_pasaje) AS anio
					FROM avion av
					INNER JOIN compañia co ON av.id_compañia = co.id_compañia
					INNER JOIN modelo mo ON av.id_modelo = mo.id_modelo
					INNER JOIN vuelo v ON av.id_avion = v.id_avion
					INNER JOIN pasaje pa ON v.id_vuelo = pa.id_vuelo
					WHERE EXTRACT(YEAR FROM fecha_pasaje) = 2021
					 GROUP BY 1,2,3, 5) as com
			GROUP BY nombre_compañia)


SELECT t1.nombre_compañia, t1.nombre_modelo
FROM tabla1 t1
INNER JOIN tabla2 t2 ON t1.nombre_compañia = t2.nombre_compañia AND t1.total = t2.max_modelos
GROUP BY t1.nombre_compañia, t1.nombre_modelo