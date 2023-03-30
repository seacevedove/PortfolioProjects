/*
Cleaning Data in SQL Queries
*/

Select *
From PortfolioProject.dbo.Linio
ORDER BY "Created at" DESC

---------------------------------------------------------------------------------------------------------

-- Remove outdated information

--DELETE
--FROM PortfolioProject.dbo.Linio
--Where "Created at" NOT LIKE '2023-03%'

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select "Created at", CONVERT(Date, "Created at")
From PortfolioProject.dbo.Linio

Update PortfolioProject.dbo.Linio
SET "Created at" = CONVERT(Date, "Created at")

-- If it doesn't Update properly

--ALTER TABLE PortfolioProject.dbo.Linio
--Add CreatedAt Date;

--Update PortfolioProject.dbo.Linio
--SET CreatedAt = CONVERT(Date, "Created at")

---------------------------------------------------------------------------------------------------------

-- Deleting canceled or failed orders.

Select Status, "Order Item Id", "Order Number"--, COUNT(Status)
From PortfolioProject.dbo.Linio
WHERE STATUS NOT IN ('delivered', 'ready_to_ship', 'shipped', 'pending')
--WHERE STATUS <> 'delivered' and STATUS <> 'ready_to_ship' and STATUS <> 'shipped'
--GROUP BY Status
ORDER BY 1

--DELETE
--From PortfolioProject.dbo.Linio
--WHERE Status in ('canceled', 'failed')

--------------------------------------------------------------------------------------------------------------------------

-- Selecting dispatch location.

Select *
From PortfolioProject.dbo.Linio
--Where "Shipment Type Name" = 'Own Warehouse'
Where "Shipment Type Name" = 'Dropshipping'
Order by "Created at" Desc
--------------------------------------------------------------------------------------------------------------------------

-- Concatenate shipping address columns into a string.

SELECT "Shipping Address", "Shipping Address2", "Shipping Address4"
FROM PortfolioProject.dbo.Linio

SELECT "Shipping Address2",
	   LEFT("Shipping Address2", CHARINDEX(',', "Shipping Address2" + ',') - 1) AS Neighborhood
FROM PortfolioProject.dbo.Linio

ALTER TABLE PortfolioProject.dbo.Linio
ADD Neighborhood NVARCHAR(100)

UPDATE PortfolioProject.dbo.Linio
SET Neighborhood = LEFT("Shipping Address2", CHARINDEX(',', "Shipping Address2" + ',') - 1)

SELECT "Shipping Address", Neighborhood, "Shipping Address4",
	CONCAT("Shipping Address",' ',Neighborhood,' ',"Shipping Address4") as ShippingAddress
FROM PortfolioProject.dbo.Linio

ALTER TABLE PortfolioProject.dbo.Linio
ADD ShippingAddress NVARCHAR(355)

UPDATE PortfolioProject.dbo.Linio
SET ShippingAddress = CONCAT("Shipping Address",' ',Neighborhood,' ',"Shipping Address4")

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Shipping City into Individual Columns (City & State)

SELECT "Shipping City",
	   LEFT("Shipping City", CHARINDEX(',', "Shipping City" + ',') - 1) as City,
       STUFF("Shipping City", 1, LEN("Shipping City") + 2 - CHARINDEX(',', REVERSE("Shipping City")), '') as State
FROM PortfolioProject.dbo.Linio

ALTER TABLE PortfolioProject.dbo.Linio
Add City NVARCHAR(100)

UPDATE PortfolioProject.dbo.Linio
SET City = LEFT("Shipping City", CHARINDEX(',', "Shipping City" + ',') - 1)

ALTER TABLE PortfolioProject.dbo.Linio
Add State NVARCHAR(50)

UPDATE PortfolioProject.dbo.Linio
SET State = STUFF("Shipping City", 1, LEN("Shipping City") + 2 - CHARINDEX(',', REVERSE("Shipping City")), '')

--------------------------------------------------------------------------------------------------------------------------

-- Case Statement: Correcteted values in "City" & "State" fields

SELECT Distinct(State)--, Count(State)
From PortfolioProject.dbo.Linio
--Group by State
Order by 1

Select State, 
CASE When State = 'Bogota D.c' THEN 'Bogotá D.C.'
     When State = 'Norte De Santander' THEN 'N. de Santander'
     When State = 'Guajira' THEN 'La Guajira'
     ELSE State
     END
From PortfolioProject.dbo.Linio

Update PortfolioProject.dbo.Linio
SET State = CASE When State = 'Bogota D.c' THEN 'Bogotá D.C.'
     When State = 'Norte De Santander' THEN 'N. de Santander'
     When State = 'Guajira' THEN 'La Guajira'
     ELSE State
     END

SELECT DISTINCT (City)--, Count(City)
From PortfolioProject.dbo.Linio
--Group by City
Order by 1

Select City, 
CASE WHEN State = 'Bogotá D.C.' THEN 'Bogotá D.C.'
     WHEN City = 'Águila' THEN 'El Águila'
     WHEN City = 'Cartagena' THEN 'Cartagena De Indias'
     WHEN City = 'Itagui' THEN 'Itagüí'
     WHEN City = 'Itaguí' THEN 'Itagüí'
     WHEN City = 'Medellin' THEN 'Medellín'
     WHEN City = 'San Antonio de Prado' THEN 'Medellín'
     WHEN City = 'Ubaté' THEN 'Villa de San Diego de Ubaté'	
     ELSE City
     END
From PortfolioProject.dbo.Linio

Update PortfolioProject.dbo.Linio
SET City = CASE WHEN State = 'Bogotá D.C.' THEN 'Bogotá D.C.'
     WHEN City = 'Águila' THEN 'El Águila'
     WHEN City = 'Cartagena' THEN 'Cartagena De Indias'
     WHEN City = 'Itagui' THEN 'Itagüí'
     WHEN City = 'Itaguí' THEN 'Itagüí'
     WHEN City = 'Medellin' THEN 'Medellín'
     WHEN City = 'San Antonio de Prado' THEN 'Medellín'
     WHEN City = 'Ubaté' THEN 'Villa de San Diego de Ubaté'	
     ELSE City
     END
From PortfolioProject.dbo.Linio

--------------------------------------------------------------------------------------------------------------------------

-- String Functions: Breaking out "Billing Name" into Individual Columns (FirstName & LastName)

SELECT
SUBSTRING("Billing Name", 1, CHARINDEX(' ', "Billing Name") -1 ) as FirstName
, SUBSTRING("Billing Name", CHARINDEX(' ', "Billing Name") + 1 , LEN("Billing Name")) as LastName
FROM PortfolioProject.dbo.Linio

ALTER TABLE PortfolioProject.dbo.Linio
ADD FirstName NVARCHAR(255), LastName NVARCHAR(255)

UPDATE PortfolioProject.dbo.Linio
SET FirstName = SUBSTRING("Billing Name", 1, CHARINDEX(' ', "Billing Name") -1)

UPDATE PortfolioProject.dbo.Linio
SET LastName = SUBSTRING("Billing Name", CHARINDEX(' ', "Billing Name") + 1 , LEN("Billing Name"))

--------------------------------------------------------------------------------------------------------------------------

-- String Functions: Trimming "FirstName" & "LastName"

SELECT FirstName, TRIM(FirstName)
FROM PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
SET FirstName = TRIM(FirstName)

SELECT LastName, TRIM(LastName)
FROM PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
SET LastName = TRIM(LastName)

--------------------------------------------------------------------------------------------------------------------------

-- String Functions:  Capitalize first letter.
--FirstName

SELECT FirstName, LOWER(FirstName)
FROM PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
SET FirstName = LOWER(FirstName)

SELECT FirstName, UPPER(LEFT(FirstName, 1)) + SUBSTRING(FirstName, 2, LEN(FirstName))
FROM PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
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

SELECT [dbo].[InitCap] ( LastName ) AS LastName
FROM PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
SET LastName = [dbo].[InitCap] ( LastName )

--------------------------------------------------------------------------------------------------------------------------

-- Remove numbers from string

SELECT
REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE (LastName, '0', ''),
'1', ''),
'2', ''),
'3', ''),
'4', ''),
'5', ''),
'6', ''),
'7', ''),
'8', ''),
'9', '') LastNameFixed
From PortfolioProject.dbo.Linio

UPDATE PortfolioProject.dbo.Linio
SET LastName = REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE
(REPLACE (LastName, '0', ''),
'1', ''),
'2', ''),
'3', ''),
'4', ''),
'5', ''),
'6', ''),
'7', ''),
'8', ''),
'9', '')

--------------------------------------------------------------------------------------------------------------------------

-- Populate Billing Phone Number Data

Select "Billing Phone Number", ISNULL("Billing Phone Number", "Billing Phone Number2")
From PortfolioProject.dbo.Linio
Where "Billing Phone Number" is null

Update a
SET "Billing Phone Number" = ISNULL("Billing Phone Number", "Billing Phone Number2")
From PortfolioProject.dbo.Linio a
Where "Billing Phone Number" is null

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- "Unit Price" before taxes
-- Shows the "Unit Price" before 19% of Taxes

SELECT "Unit Price", CAST("Unit Price" AS DECIMAL(10, 2))/1.19 AS "Unit Price Before Tax"
FROM PortfolioProject.dbo.Linio
ORDER BY 1

ALTER TABLE PortfolioProject.dbo.Linio
ADD "Unit Price Before Tax" FLOAT

UPDATE PortfolioProject.dbo.Linio
SET "Unit Price Before Tax" = CAST("Unit Price" AS DECIMAL(10, 2))/1.19

UPDATE PortfolioProject.dbo.Linio
SET "Unit Price Before Tax" = CAST("Unit Price Before Tax" AS DECIMAL(10, 2))

--------------------------------------------------------------------------------------------------------------------------

-- Fixing values in "Fiscal Person" & "Document Type" fields

SELECT "Fiscal Person", Count("Fiscal Person")
From PortfolioProject.dbo.Linio
Group by "Fiscal Person"
Order by 1

Select "Fiscal Person", 
CASE WHEN "Fiscal Person" = 'Persona Juridica-1' THEN 'Jurídica'
	 ELSE 'Natural'
	 END
From PortfolioProject.dbo.Linio

Update PortfolioProject.dbo.Linio
SET "Fiscal Person" = CASE WHEN "Fiscal Person" = 'Persona Juridica-1' THEN 'Jurídica'
	 ELSE 'Natural'
	 END

SELECT "Document Type", Count("Document Type")
FROM PortfolioProject.dbo.Linio
GROUP BY "Document Type"
ORDER BY 2 DESC

Select "Document Type", 
CASE WHEN "Document Type" = 'CÃ©dula de CiudadanÃ­a-13' THEN 'Cédula de ciudadanía'
     WHEN "Document Type" = 'CÃ©dula de ExtranjerÃ­a-22' THEN 'Cédula de extranjería'
	 WHEN "Document Type" = 'Tarjeta de Identidad-12' THEN 'Tarjeta de identidad'
	 WHEN "Document Type" = 'NIT-31' THEN 'Número de identificación tributaria'	   
	 WHEN "Document Type" = 'Tarjeta de Extranjeria-21' THEN 'Tarjeta de extranjería'
	 WHEN "Document Type" = 'Registro Civil-11' THEN 'Registro civil'
	 WHEN "Document Type" = 'Pasaporte-41' THEN 'Pasaporte'
	 ELSE 'Cédula de ciudadanía'
	 END
From PortfolioProject.dbo.Linio

Update PortfolioProject.dbo.Linio
SET "Document Type" = CASE WHEN "Document Type" = 'CÃ©dula de CiudadanÃ­a-13' THEN 'Cédula de ciudadanía'
     WHEN "Document Type" = 'CÃ©dula de ExtranjerÃ­a-22' THEN 'Cédula de extranjería'
	 WHEN "Document Type" = 'Tarjeta de Identidad-12' THEN 'Tarjeta de identidad'
	 WHEN "Document Type" = 'NIT-31' THEN 'Número de identificación tributaria'	   
	 WHEN "Document Type" = 'Tarjeta de Extranjeria-21' THEN 'Tarjeta de extranjería'
	 WHEN "Document Type" = 'Registro Civil-11' THEN 'Registro civil'
	 WHEN "Document Type" = 'Pasaporte-41' THEN 'Pasaporte'
	 ELSE 'Cédula de ciudadanía'
	 END

-- Tax Responsibility

SELECT "Customer Name",
CASE WHEN "Customer Name" LIKE 'Iglesia%' THEN 'No responsable del IVA'
     WHEN "Fiscal Person" = 'Jurídica' THEN  'Responsable del IVA' 
	 ELSE 'No responsable del IVA'
	 END
FROM PortfolioProject.dbo.Linio

ALTER TABLE PortfolioProject.dbo.Linio
ADD "Tax Responsibility" NVARCHAR(225)

UPDATE PortfolioProject.dbo.Linio
SET "Tax Responsibility" = CASE WHEN "Customer Name" LIKE 'Iglesia%' THEN 'No responsable del IVA'
     WHEN "Fiscal Person" = 'Jurídica' THEN  'Responsable del IVA' 
	 ELSE 'No responsable del IVA'
	 END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.Linio
Order by "Created at" DESC

ALTER TABLE PortfolioProject.dbo.Linio
DROP COLUMN "Shipping Address2", "Shipping Address4", "Billing Phone Number2",  "Billing Country", "Neighborhood", "Linio Id", "Billing Name", "Item Name", "Unit Price",  "Linio SKU", "Paid Price", "Receiver Legal Name", "Receiver Address", "Customer Name", "Billing Address", "Billing Address2", "Shipping Address3", "Shipping Address5", "Shipping Fee", "Shipping Name", "Updated at", "Order Source", "Invoice Required","Order Currency", "Shipping City", "Shipping Postcode", "Billing Address3", "Billing Address4", "Billing Address5", "Shipping Phone Number", "Shipping Phone Number2", "Billing City",  "Billing Postcode", "Payment Means ID", "Payment Means ID Code", "Tax Scheme Code", "Payer Obligations Code", "Customer Verifier Digit", "Receiver Type Regimen", "Receiver Postcode", "Receiver Commercial Name", "Receiver Region", "Receiver Municipality", "English name", "Reason", "Premium", "Promised shipping time", "Tracking URL", "Tracking Code", "CD Tracking Code", "Shipping Provider Type", "Shipping Provider", "CD Shipping Provider", "Variation", "Wallet Credits", "Payment Method"

---------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY "National Registration Number"
				 ORDER BY
					"Order Item Id"
					) RowNum
From PortfolioProject.dbo.Linio
--Order by "National Registration Number"
)
Select *
From RowNumCTE
Where RowNum > 1
Order by "National Registration Number"

--Delete 
--From RowNumCTE
--Where RowNum > 1
