/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM PortfolioProject.dbo.ML
--WHERE "Fecha de venta" LIKE '%marzo de 2023%'

---------------------------------------------------------------------------------------------------------

-- Remove outdated information

--DELETE
--FROM PortfolioProject.dbo.ML
--Where "Fecha de venta" NOT LIKE '%marzo de 2023%'

---------------------------------------------------------------------------------------------------------

-- Case Statement: Correcteted values in city & state fields

SELECT DISTINCT (Estado1)--, COUNT(Estado1)
FROM PortfolioProject.dbo.ML
--GROUP BY (Estado1)
ORDER BY 1

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
From PortfolioProject.dbo.ML
Group by "Municipio o ciudad capital"
Order by 1

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
	 ELSE "Municipio o ciudad capital"
	 END
FROM PortfolioProject.dbo.ML

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
ADD "Unit Price Before Tax" NVARCHAR(50)

UPDATE PortfolioProject.dbo.ML
SET "Unit Price Before Tax" = CAST("Precio unitario de venta de la publicación (COP)" AS DECIMAL(10, 2))/1.19

UPDATE PortfolioProject.dbo.ML
SET "Unit Price Before Tax" = CAST("Unit Price Before Tax" AS DECIMAL(10, 2))

-- Shipping Cost Before Tax

SELECT REPLACE("Ingresos por envío (COP)", ',', '.')
FROM PortfolioProject.dbo.ML

ALTER TABLE PortfolioProject.dbo.ML
ADD "Shipping Cost Before Tax" FLOAT

UPDATE PortfolioProject.dbo.ML
SET "Shipping Cost Before Tax" = REPLACE("Ingresos por envío (COP)", ',', '.')

SELECT "Shipping Cost Before Tax",
CASE WHEN "Shipping Cost Before Tax" = '0' THEN "Shipping Cost Before Tax"
	 ELSE CAST("Shipping Cost Before Tax" AS DECIMAL(10, 2))/1.19
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Shipping Cost Before Tax" = CASE WHEN "Shipping Cost Before Tax" = '0' THEN "Shipping Cost Before Tax"
	 ELSE CAST("Shipping Cost Before Tax" AS DECIMAL(10, 2))/1.19
	 END

SELECT CASE WHEN "Shipping Cost Before Tax" = '0' THEN "Shipping Cost Before Tax"
	        ELSE CAST("Shipping Cost Before Tax" AS DECIMAL(10, 2))
	        END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "Shipping Cost Before Tax" = CASE WHEN "Shipping Cost Before Tax" = '0' THEN "Shipping Cost Before Tax"
	 ELSE CAST("Shipping Cost Before Tax" AS DECIMAL(10, 2))
	 END
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fixing values in ID type fields

SELECT "Datos personales o de empresa", "Tipo y número de documento", Comprador, CC
FROM PortfolioProject.dbo.ML
WHERE "Tipo y número de documento" LIKE '%NIT%'

ALTER TABLE PortfolioProject.dbo.ML
ADD "ID type" NVARCHAR (50), "Tipo de identificación" NVARCHAR(50), "Tipo de persona" NVARCHAR(50), "Responsabilidad Tributaria" NVARCHAR(50)

Select "Tipo y número de documento", 
SUBSTRING("Tipo y número de documento", 1, CHARINDEX(' ', "Tipo y número de documento") - 1 )
From PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "ID type" = SUBSTRING("Tipo y número de documento", 1, CHARINDEX(' ', "Tipo y número de documento") - 1 )

SELECT "ID type",
CASE WHEN "ID type" = 'NIT' THEN 'NIT'
     ELSE 'CC'
	 END
FROM PortfolioProject.dbo.ML

UPDATE PortfolioProject.dbo.ML
SET "ID type" = CASE WHEN "ID type" = 'NIT' THEN 'NIT'
     ELSE 'CC'
	 END

-- ID type

UPDATE PortfolioProject.dbo.ML
SET "Tipo de identificación" = CASE WHEN "ID type" = 'NIT' THEN 'Número de identificación tributaria'
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

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.ML

ALTER TABLE PortfolioProject.dbo.ML
DROP COLUMN 
-- "Descripción del estado", "Paquete de varios productos", "Ingresos por productos (COP)", "Cargo por venta e impuestos", "Costos de envío", "Anulaciones y reembolsos (COP)", "Total (COP)", "Venta por publicidad", "SKU", "# de publicación", "Título de la publicación", "Variante", "Tipo de publicación", "Factura adjunta", "Datos personales o de empresa", "Tipo y número de documento", "Dirección", "Tipo de contribuyente", "Comprador", "Código postal", "Forma de entrega", "Fecha en camino", "Fecha entregado", "Transportista", "Número de seguimiento", "URL de seguimiento", "Forma de entrega1", "Fecha en camino1", "Fecha entregado1", "Transportista1", "Número de seguimiento1", "URL de seguimiento1", "Reclamo abierto", "Reclamo cerrado", "Con mediación", "ID type"

---------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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
WHERE RowNum > 1
ORDER BY "Fecha de venta"

--DELETE 
--FROM RowNumCTE
--WHERE RowNum > 1

-----------------------------------------------------------------------------------------------------------------------------------------------------------
