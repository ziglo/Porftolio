--Deleted columns that were not needed. 
ALTER TABLE rcmp
DROP COLUMN column3, column8, column9, column10, column11, column12, STATUS, SYMBOL

--
-- Deleted percentage statistics to be able to practice. 
DELETE FROM rcmp
WHERE UOM = 'Percentage';

-- Table now shows no percentage statistics. 
Select*
FROM rcmp

--Look at percentage of Total Male police officers(FTE) in BC from 1986 to 2023.
;WITH BC_Total AS (
	SELECT
		REF_DATE,
		Value AS Total_Officers
	FROM
		rcmp
	WHERE
		GEO = 'British Columbia' AND Gender = 'Both Genders' AND Personnel LIKE 'Total number of police officers%'
),
BC_Men AS (
	SELECT
		REF_DATE,
		Value AS Male_Officers
	FROM
		rcmp
	WHERE
		GEO = 'British Columbia' AND Gender = 'Men' AND Personnel LIKE 'Total number of police officers%'
)

SELECT
	BC_Men.REF_DATE,
	BC_Total.Total_Officers,
	BC_Men.Male_Officers,
	ROUND((BC_Men.Male_Officers * 100.0/BC_Total.Total_Officers), 2) AS PercentageBC_Male
FROM
	BC_Men
JOIN
	BC_Total
ON
	BC_Men.REF_DATE = BC_Total.REF_DATE
Order by BC_Men.REF_DATE;

-- Look at percentage of totale percentage of female officers in BC from 1986 to 2023.
;WITH BC_Total AS (
	SELECT
		REF_DATE,
		Value AS Total_Officers
	FROM
		rcmp
	WHERE
		GEO = 'British Columbia' AND Gender = 'Both Genders' AND Personnel LIKE 'Total number of police officers%'
),
BC_Female AS (
	SELECT
		REF_DATE,
		Value AS Female_Officers
	FROM
		rcmp
	WHERE
		GEO = 'British Columbia' AND Gender = 'Women' AND Personnel LIKE 'Total number of police officers%'
)

SELECT
	BC_Female.REF_DATE,
	BC_Total.Total_Officers,
	BC_Female.Female_Officers,
	ROUND((BC_Female.Female_Officers * 100.0/BC_Total.Total_Officers), 2) AS PercentageBC_Female
FROM
	BC_Female
JOIN
	BC_Total
ON
	BC_Female.REF_DATE = BC_Total.REF_DATE
Order by PercentageBC_Female DESC

--Looked at the percentage of female offficers compared to total officers for each province from 1986 to 2023. 

WITH ProvinceTotal AS (
	SELECT 
		REF_DATE,
		GEO,
    CASE 
        WHEN VALUE IS NULL THEN 0  -- Replace NULL with 0
        ELSE VALUE
    END AS TotalOfficers
	FROM RCMP..rcmp
	WHERE
        Personnel = 'Total number of police officers (Full-time equivalent - FTE)' 
        AND GEO <> 'Canada' 
        AND GEO <> 'RCMP HQ and Academy'
		AND GEO <> 'Northwest Territories including Nunavut'
        AND Gender = 'Both Genders'
),
ProvinceFemale AS (
	SELECT 
		REF_DATE,
		GEO,
    CASE 
        WHEN VALUE IS NULL THEN 0  -- Replace NULL with 0
        ELSE VALUE
    END AS FemaleOfficers
	FROM RCMP..rcmp
	WHERE
        Personnel = 'Total number of police officers (Full-time equivalent - FTE)' 
        AND GEO <> 'Canada' 
        AND GEO <> 'RCMP HQ and Academy'
		AND GEO <> 'Northwest Territories including Nunavut'
        AND Gender = 'Women'
)

SELECT
	ProvinceFemale.REF_DATE,
	ProvinceFemale.GEO,
	ProvinceFemale.FemaleOfficers,
	ProvinceTotal.TotalOfficers,
    CASE 
        WHEN ProvinceTotal.TotalOfficers = 0 THEN 0  -- Avoid division by zero
        ELSE ROUND((ProvinceFemale.FemaleOfficers * 100.0 / ProvinceTotal.TotalOfficers), 2)
    END AS Percentage_Female
FROM
	ProvinceFemale
JOIN
	ProvinceTotal
ON
	ProvinceFemale.GEO = ProvinceTotal.GEO AND ProvinceFemale.REF_DATE = ProvinceTotal.REF_DATE
Order by ProvinceFemale.REF_DATE

