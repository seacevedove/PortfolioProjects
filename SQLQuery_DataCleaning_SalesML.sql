/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM PortfolioProject.dbo.ML

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format & Remove Outdated Information

SELECT REPLACE("Fecha de venta", ' de marzo de 2023', '-2023-03')
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Fecha de venta" = REPLACE("Fecha de venta", ' de marzo de 2023', '-2023-03')

--DELETE
--FROM PortfolioProject.dbo.ML
--WHERE "Fecha de venta" NOT LIKE '%2023-03%'

SELECT
SUBSTRING("Fecha de venta", 4, CHARINDEX(' ', "Fecha de venta") - 4 ) AS Year_Month, 
SUBSTRING("Fecha de venta", CHARINDEX(' ', "Fecha de venta") + 1 , LEN("Fecha de venta")) AS Time
FROM PortfolioProject.dbo.ML

SELECT "Fecha de venta",
	   LEFT("Fecha de venta", CHARINDEX('-', "Fecha de venta" + '-') - 1) AS Day
FROM PortfolioProject.dbo.ML

SELECT CONCAT(SUBSTRING("Fecha de venta", 4, CHARINDEX(' ', "Fecha de venta") - 4 ),'-',LEFT("Fecha de venta", CHARINDEX('-', "Fecha de venta" + '-') - 1),' ',SUBSTRING("Fecha de venta", CHARINDEX(' ', "Fecha de venta") + 1 , LEN("Fecha de venta")))
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Fecha de venta" = CONCAT(SUBSTRING("Fecha de venta", 4, CHARINDEX(' ', "Fecha de venta") - 4 ),'-',LEFT("Fecha de venta", CHARINDEX('-', "Fecha de venta" + '-') - 1),' ',SUBSTRING("Fecha de venta", CHARINDEX(' ', "Fecha de venta") + 1 , LEN("Fecha de venta")))

--------------------

SELECT "Fecha de venta"
FROM PortfolioProject.dbo.ML
WHERE "Fecha de venta" LIKE '023-03%'

SELECT "Fecha de venta",
CASE WHEN "Fecha de venta" LIKE '023-03%' THEN REPLACE("Fecha de venta", '023-03', '2023-03')
	 ELSE "Fecha de venta"
	 END
FROM PortfolioProject.dbo.ML
ORDER BY "Fecha de venta"

UPDATE PortfolioProject.dbo.ML
SET "Fecha de venta" = CASE WHEN "Fecha de venta" LIKE '023-03%' THEN REPLACE("Fecha de venta", '023-03', '2023-03')
	 ELSE "Fecha de venta"
	 END

---------------------------------------------------------------------------------------------------------

-- Populate Address Data

SELECT Domicilio, 
CASE WHEN Domicilio = '' THEN 'Domicilio'
	 ELSE Domicilio
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET Domicilio = CASE WHEN Domicilio = '' THEN 'Domicilio'
	 ELSE Domicilio
	 END

---------------------------------------------------------------------------------------------------------

-- Case Statement: Correcteted values in city & state fields

SELECT DISTINCT (Estado1), COUNT(Estado1)
FROM PortfolioProject.dbo.ML
GROUP BY (Estado1)
ORDER BY 2 DESC

Select Estado1, 
CASE When Estado1 = 'Bogota D.c' THEN 'Bogotá D.C.'
	 When Estado1 = 'Norte De Santander' THEN 'N. de Santander'
	 When Estado1 = 'Guajira' THEN 'La Guajira'
	 ELSE Estado1
	 END
From PortfolioProject.dbo.ML

Update PortfolioProject.dbo.ML
SET Estado1 = CASE When Estado1 = 'Bogota D.c' THEN 'Bogotá D.C.'
	 When Estado1 = 'Norte De Santander' THEN 'N. de Santander'
	 When Estado1 = 'Guajira' THEN 'La Guajira'
	 ELSE Estado1
	 END

SELECT Distinct("Municipio o ciudad capital"), Count("Municipio o ciudad capital")
FROM PortfolioProject.dbo.ML
GROUP BY "Municipio o ciudad capital"
ORDER BY 2 DESC

SELECT "Municipio o ciudad capital", 
CASE WHEN Estado1 = 'Bogotá D.C.' THEN 'Bogotá D.C.'
     WHEN "Municipio o ciudad capital" = 'Águila' THEN 'El Águila'
	 WHEN "Municipio o ciudad capital" = 'Cartagena' THEN 'Cartagena De Indias'
	 WHEN "Municipio o ciudad capital" = 'Itagui' THEN 'Itagüí'
	 WHEN "Municipio o ciudad capital" = 'Itaguí' THEN 'Itagüí'
	 WHEN "Municipio o ciudad capital" = 'Medellin' THEN 'Medellín'
	 WHEN "Municipio o ciudad capital" = 'San Antonio de Prado' THEN 'Medellín'
	 WHEN "Municipio o ciudad capital" = 'Ubaté' THEN 'Villa de San Diego de Ubaté'
	 ELSE "Municipio o ciudad capital"
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Municipio o ciudad capital" = CASE WHEN Estado1 = 'Bogotá D.C.' THEN 'Bogotá D.C.'
     WHEN "Municipio o ciudad capital" = 'Águila' THEN 'El Águila'
	 WHEN "Municipio o ciudad capital" = 'Cartagena' THEN 'Cartagena De Indias'
	 WHEN "Municipio o ciudad capital" = 'Itagui' THEN 'Itagüí'
	 WHEN "Municipio o ciudad capital" = 'Itaguí' THEN 'Itagüí'
	 WHEN "Municipio o ciudad capital" = 'Medellin' THEN 'Medellín'
	 WHEN "Municipio o ciudad capital" = 'San Antonio de Prado' THEN 'Medellín'
	 WHEN "Municipio o ciudad capital" = 'Ubaté' THEN 'Villa de San Diego de Ubaté'
	 WHEN "Municipio o ciudad capital" = 'El Placer' THEN 'El Cerrito'
	 WHEN "Municipio o ciudad capital" = 'Llorente ' THEN 'San Andrés de Tumaco'
	 ELSE "Municipio o ciudad capital"
	 END

--------------------------------------------------------------------------------------------------------------------------

-- String Functions: Breaking out customer name into Individual Columns (FirstName & LastName)

SELECT
SUBSTRING(Comprador, 1, CHARINDEX(' ', Comprador) - 1 ), 
SUBSTRING(Comprador, CHARINDEX(' ', Comprador) + 1 , LEN(Comprador))
FROM PortfolioProject.dbo.ML

ALTER TABLE PortfolioProject.dbo.ML
ADD FirstName NVARCHAR(255), LastName NVARCHAR(255)

UPDATE PortfolioProject.dbo.ML
SET FirstName = SUBSTRING(Comprador, 1, CHARINDEX(' ', Comprador) - 1 )

UPDATE PortfolioProject.dbo.ML
SET LastName = SUBSTRING(Comprador, CHARINDEX(' ', Comprador) + 1 , LEN(Comprador))

--------------------------------------------------------------------------------------------------------------------------

-- String Functions: Trimming "FirstName" & "LastName"

SELECT FirstName, TRIM(FirstName)
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET FirstName = TRIM(FirstName)

SELECT LastName, TRIM(LastName)
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET LastName = TRIM(LastName)

---------------------------------------------------------------------------------------------------------

-- String Functions:  Capitalize first letter for complete name.
--FirstName

SELECT FirstName, LOWER(FirstName)
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET FirstName = LOWER(FirstName)

SELECT FirstName, UPPER(LEFT(FirstName, 1)) + SUBSTRING(FirstName, 2, LEN(FirstName))
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET FirstName = UPPER(LEFT(FirstName, 1)) + SUBSTRING(FirstName, 2, LEN(FirstName))

--LastName

CREATE FUNCTION [dbo].[InitCap] ( @InputString varchar(4000) ) 
RETURNS VARCHAR(4000)
AS
BEGIN

DECLARE @Index          INT
DECLARE @Char           CHAR(1)
DECLARE @PrevChar       CHAR(1)
DECLARE @OutputString   VARCHAR(255)

SET @OutputString = LOWER(@InputString)
SET @Index = 1

WHILE @Index <= LEN(@InputString)
BEGIN
    SET @Char     = SUBSTRING(@InputString, @Index, 1)
    SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
                         ELSE SUBSTRING(@InputString, @Index - 1, 1)
                    END

    IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
    BEGIN
        IF @PrevChar != '''' OR UPPER(@Char) != 'S'
            SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))
    END

    SET @Index = @Index + 1
END

RETURN @OutputString

END

SELECT [dbo].[InitCap] ( LastName )
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET LastName = [dbo].[InitCap] ( LastName )

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Income before taxes
-- Shows the income before 19% of Taxes

-- Unit Price Before Tax

SELECT "Precio unitario de venta de la publicación (COP)", CAST("Precio unitario de venta de la publicación (COP)" AS DECIMAL(10, 2))/1.19
FROM PortfolioProject.dbo.ML

ALTER TABLE PortfolioProject.dbo.ML
ADD "Unit Price Before Tax" DECIMAL(10, 2)

UPDATE PortfolioProject.dbo.ML
SET "Unit Price Before Tax" = CAST("Precio unitario de venta de la publicación (COP)" AS DECIMAL(10, 2))/1.19

-- Shipping Cost Before Tax

SELECT REPLACE("Ingresos por envío (COP)", ',', '.')
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Ingresos por envío (COP)" = REPLACE("Ingresos por envío (COP)", ',', '.')

SELECT "Ingresos por envío (COP)",
CASE WHEN "Ingresos por envío (COP)" = '' THEN NULL
	 ELSE "Ingresos por envío (COP)"
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Ingresos por envío (COP)" = CASE WHEN "Ingresos por envío (COP)" = '' THEN NULL
	 ELSE "Ingresos por envío (COP)"
	 END

ALTER TABLE PortfolioProject.dbo.ML
ADD "Shipping Cost Before Tax" DECIMAL(10, 2)

UPDATE PortfolioProject.dbo.ML
SET "Shipping Cost Before Tax" = CAST("Ingresos por envío (COP)" AS FLOAT)/1.19

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Fixing values in ID type fields

ALTER TABLE PortfolioProject.dbo.ML
ADD "ID type" NVARCHAR (50), "Tipo de identificación" NVARCHAR(50), "Tipo de persona" NVARCHAR(50), "Responsabilidad Tributaria" NVARCHAR(50)

Select "Tipo y número de documento", 
SUBSTRING("Tipo y número de documento", 1, CHARINDEX(' ', "Tipo y número de documento") - 1 )
From PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "ID type" = SUBSTRING("Tipo y número de documento", 1, CHARINDEX(' ', "Tipo y número de documento") - 1 )

SELECT DISTINCT "ID type"
FROM PortfolioProject.dbo.ML

SELECT "ID type",
CASE WHEN "ID type" = 'NIT' THEN 'NIT'
     WHEN "ID type" = 'CE' THEN 'CE'
	 ELSE 'CC'
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "ID type" = CASE WHEN "ID type" = 'NIT' THEN 'NIT'
     WHEN "ID type" = 'CE' THEN 'CE'
	 ELSE 'CC'
	 END

-- ID type
SELECT "ID type",
CASE WHEN "ID type" = 'NIT' THEN 'Número de identificación tributaria'
     WHEN "ID type" = 'CE' THEN 'Cédula de extranjería'
	 WHEN "ID type" = 'TI' THEN 'Tarjeta de identidad'   
	 WHEN "ID type" = 'TE' THEN 'Tarjeta de extranjería'
	 WHEN "ID type" = 'RC' THEN 'Registro civil'
	 WHEN "ID type" = 'Pasaporte-41' THEN 'Pasaporte'
	 ELSE 'Cédula de ciudadanía'
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Tipo de identificación" = CASE WHEN "ID type" = 'NIT' THEN 'Número de identificación tributaria'
     WHEN "ID type" = 'CE' THEN 'Cédula de extranjería'
	 WHEN "ID type" = 'TI' THEN 'Tarjeta de identidad'   
	 WHEN "ID type" = 'TE' THEN 'Tarjeta de extranjería'
	 WHEN "ID type" = 'RC' THEN 'Registro civil'
	 WHEN "ID type" = 'Pasaporte-41' THEN 'Pasaporte'
	 ELSE 'Cédula de ciudadanía'
	 END

-- Person type

UPDATE PortfolioProject.dbo.ML
SET "Tipo de persona" = CASE WHEN "ID type" = 'NIT' THEN 'Jurídica'
     ELSE 'Natural'
	 END

-- Tax Responsibility

SELECT Comprador,
CASE WHEN Comprador LIKE 'Iglesia%' THEN 'No responsable del IVA'
     WHEN "ID type" = 'NIT' THEN 'Responsable del IVA' 
	 ELSE 'No responsable del IVA'
	 END
FROM PortfolioProject.dbo.ML
--WHERE Comprador LIKE 'Iglesia%'

UPDATE PortfolioProject.dbo.ML
SET "Responsabilidad Tributaria" = CASE WHEN Comprador LIKE 'Iglesia%' THEN 'No responsable del IVA'
     WHEN "ID type" = 'NIT' THEN 'Responsable del IVA' 
	 ELSE 'No responsable del IVA'
	 END

---------------------------------------------------------------------------------------------------------

-- Deleting canceled or failed orders.

SELECT *--Estado, "# de venta"
FROM PortfolioProject.dbo.ML
WHERE Estado NOT IN ('En camino', 'Entregado', 'Mediación finalizada. Te dimos el dinero.', '')
ORDER BY 2

DELETE
FROM PortfolioProject.dbo.ML
WHERE "Total (COP)" <= '0' AND Estado IN ('Cancelada por el comprador', 'Paquete cancelado por Mercado Libre', 'Devolución finalizada con reembolso al comprador')

DELETE
FROM PortfolioProject.dbo.ML
WHERE "Total (COP)" IS NULL AND Estado IN ('Cancelada por el comprador', 'Paquete cancelado por Mercado Libre', 'Devolución finalizada con reembolso al comprador')

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProject.dbo.ML

ALTER TABLE PortfolioProject.dbo.ML
DROP COLUMN "Total (COP)", "Ingresos por envío (COP)", "Precio unitario de venta de la publicación (COP)", "Descripción del estado", "Paquete de varios productos", "Ingresos por productos (COP)", "Cargo por venta e impuestos", "Costos de envío", "Anulaciones y reembolsos (COP)", "Venta por publicidad", "# de publicación", "Título de la publicación", "Variante", "Tipo de publicación", "Factura adjunta", "Datos personales o de empresa", "Tipo y número de documento", "Dirección", "Tipo de contribuyente", "Comprador", "Código postal", "Forma de entrega", "Fecha en camino", "Fecha entregado", "Transportista", "Número de seguimiento", "URL de seguimiento", "Forma de entrega1", "Fecha en camino1", "Fecha entregado1", "Transportista1", "Número de seguimiento1", "URL de seguimiento1", "Reclamo abierto", "Reclamo cerrado", "Con mediación", "ID type"

---------------------------------------------------------------------------------------------------------

-- Remove Duplicates for Client Creation

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY CC
				 ORDER BY
					"Fecha de venta"
					) RowNum
FROM PortfolioProject.dbo.ML
--Order by "National Registration Number"
)
SELECT *
FROM RowNumCTE
WHERE RowNum > 1 OR CC = ''
ORDER BY RowNum

--DELETE 
--FROM RowNumCTE
--WHERE RowNum > 1 OR CC = ''

---------------------------------------------------------------------------------------------------------

-- Filling Down In SQL for Invoice Bulk Upload

SELECT CC,
CASE WHEN CC = '' THEN NULL
	 ELSE CC
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET CC = CASE WHEN CC = '' THEN NULL
	 ELSE CC
	 END

--

WITH CTE_grouped_table AS(
SELECT "Fecha de venta",
	   CC,
       COUNT (CC) OVER (
	   ORDER BY "Fecha de venta"
	   ) AS GRCC
FROM PortfolioProject.dbo.ML
), CTE_final_table AS (
SELECT "Fecha de venta",
	   CC,
	   GRCC,
	   FIRST_VALUE (CC) OVER (PARTITION BY GRCC ORDER BY "Fecha de venta") AS CC_filled
FROM CTE_grouped_table
)
SELECT "Fecha de venta",
	   CC, 
       CC_filled
FROM CTE_final_table

--UPDATE CTE_final_table
--SET CC = CC_filled

---------------------------------------------------------------------------------------------------------

-- Group CC values

ALTER TABLE PortfolioProject.dbo.ML
ADD CC_Group NVARCHAR (50)

WITH CTE_grouped_table AS(
SELECT "Fecha de venta",
	   CC,
	   CC_Group,
       COUNT (CC) OVER (
	   ORDER BY "Fecha de venta"
	   ) AS CC_Group_Filled
FROM PortfolioProject.dbo.ML
)
--SELECT "Fecha de venta",
--	   CC, 
--       CC_Group_Filled
--FROM CTE_grouped_table

UPDATE CTE_grouped_table
SET CC_Group = CC_Group_Filled

---------------------------------------------------------------------------------------------------------

-- Remove NULL values for Invoice Bulk Upload

SELECT *
FROM PortfolioProject.dbo.ML
WHERE Unidades IS NULL AND "Shipping Cost Before Tax" IS NULL

--DELETE 
--FROM PortfolioProject.dbo.ML
--WHERE Unidades IS NULL AND "Shipping Cost Before Tax" IS NULL

------------------------------------------------------------------------------------------------------------------------------------------------------------
