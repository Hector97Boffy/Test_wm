  /*Hacemos una consulta rápida de nuestra tabla */
SELECT [ID]
      ,[Tienda]
      ,[Producto]
      ,[Venta]
      ,[Descuento]
      ,[DATETIME]
  FROM [walmart].[dbo].[examen$]

 SELECT
	ID,
 /*Separamos en las columnas 'Nombre de Tienda' y 'Numero de Tienda' */
    LEFT(Tienda, CHARINDEX('-', Tienda)-1) AS Lugar, /*Se extrae la info hasta llegar a '-'*/
    RIGHT(Tienda, LEN(Tienda) - (CHARINDEX('-', Tienda))) AS Numero_de_Tienda, /*Se extrae la info después del '-'*/
	/*Sustituimos los valores con porcentaje*/
	    CASE 
        WHEN Descuento<1 THEN (CAST(REPLACE(Descuento, '%', '') AS FLOAT) ) * Venta /* Se utiliza menor a 1 porque en SQL server el 10% se representa como 0.1*/
		WHEN Descuento IS NULL THEN 0 /*Cuando no hay ningun valor*/
   		ELSE Descuento
		END AS Descuento,
		Producto,
		/*Se convierte del tamaño de la cadena de 10 a fromato 101 que es MM/DD/YYYY*/
		CONVERT(VARCHAR(10),CONVERT(DATE,DATETIME,103),101) AS DATE,
		/*Se agrega la columna de Venta Neta con la resta de las columnas Venta y Descuento */
		Venta-Descuento AS Venta_Neta
FROM dbo.examen$

/*Se requiere ver las ventas de cada tienda durante las festividades del mes de Diciembre del 22 al 24*/
SELECT Tienda, SUM(Venta) as Total_Venta
FROM dbo.examen$
WHERE DATETIME >= '2022-12-22' AND DATETIME <= '2022-12-24'
GROUP BY Tienda
ORDER BY Total_Venta DESC

/*Se requiere ver las ventas de cada tienda durante las festividades del mes de Diciembre del 29 al 31*/
SELECT Tienda, SUM(Venta) as Total_Venta
FROM dbo.examen$
WHERE DATETIME >= '2022-12-29' AND DATETIME <= '2022-12-31'
GROUP BY Tienda
ORDER BY Total_Venta DESC