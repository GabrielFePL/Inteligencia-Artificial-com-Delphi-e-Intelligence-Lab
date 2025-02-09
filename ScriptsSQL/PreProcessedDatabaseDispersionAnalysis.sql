USE sales;

SELECT * FROM pre_processed_data;

SELECT Gender, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Gender;

SELECT Age, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Age;

SELECT Marital_Status, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Marital_Status;

SELECT Dependents, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Dependents;

SELECT Income, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Income;

SELECT Residence_Type, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Residence_Type;

SELECT Vehicle, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Vehicle;

SELECT Client_Profile, COUNT(*) AS Count
FROM pre_processed_data
GROUP BY Client_Profile;