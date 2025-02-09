USE sales;

-- ANÁLISE DA TABELA pessoas
SELECT * FROM pessoas;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR GÊNERO
SELECT DISTINCT(genero) FROM pessoas;

SELECT genero, COUNT(*) AS quantidade FROM pessoas GROUP BY genero;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR IDADE
SELECT YEAR(nascimento) FROM pessoas ORDER BY 1;

DELIMITER $$
CREATE FUNCTION GetAge(age INTEGER) RETURNS CHAR(5) DETERMINISTIC
BEGIN
    DECLARE AgeRange CHAR(5);
    IF age < 25 THEN
        SET AgeRange = '<25';
    ELSEIF age BETWEEN 25 AND 44 THEN
        SET AgeRange = '25-34';
    ELSE
        SET AgeRange = '>=45';
    END IF;
    RETURN AgeRange;
END $$
DELIMITER ;

SELECT 
    GetAge(YEAR(NOW()) - YEAR(nascimento)) AS faixa_etaria,
    COUNT(*) AS quantidade
FROM pessoas
GROUP BY faixa_etaria;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR ESTADO CIVIL
SELECT DISTINCT(estado_civil) FROM pessoas;

SELECT estado_civil, COUNT(*) AS quantidade
FROM pessoas
GROUP BY estado_civil;

DELIMITER $$
CREATE FUNCTION GetMaritalStatus(maritalStatus INTEGER) RETURNS CHAR(10) DETERMINISTIC
BEGIN
	DECLARE response CHAR(10);
	IF (maritalStatus = 1) THEN
		SET response = "Married";
	ELSEIF (maritalStatus = 2) THEN
		SET response = "Single";
	ELSEIF (maritalStatus = 3) THEN
		SET response = "Divorced";
	ELSEIF (maritalStatus = 4) THEN
		SET response = "Widowed";
	ELSE
		SET response = "Married";
	END IF;
    
    RETURN response;
END $$
DELIMITER ;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR DEPENDENTES
SELECT * from pessoa_dependentes;

SELECT idpessoa, COUNT(*) AS quantidade
FROM pessoa_dependentes pd
INNER JOIN pessoas p
	ON pd.idpessoa = p.id
GROUP BY 1;

DELIMITER $$
CREATE FUNCTION GetDependentPeople(dependentQuantity INTEGER) RETURNS CHAR(3) DETERMINISTIC
BEGIN
	DECLARE dependents CHAR(3);
    IF (dependentQuantity >= 0 AND dependentQuantity < 3) THEN
		SET dependents = "0-2";
	ELSEIF (dependentQuantity > 2 AND dependentQuantity < 6) THEN
		SET dependents = "3-5";
	ELSE
		SET dependents = ">5";
	END IF;
	RETURN dependents;
END $$
DELIMITER ;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR SALÁRIO
SELECT * FROM pessoa_empresas;

SELECT idpessoa, SUM(salario) AS salario
FROM pessoa_empresas pe
INNER JOIN pessoas p
	ON pe.idpessoa = p.id
GROUP BY 1
ORDER BY 2;

DELIMITER $$
CREATE FUNCTION GetIncomeRange(incomeSum FLOAT) RETURNS CHAR(10) DETERMINISTIC
BEGIN
	DECLARE incomeRange CHAR(10);
    IF (incomeSum >= 700 AND incomeSum <= 8000) THEN
		SET incomeRange = "700-8000";
	ELSEIF (incomeSum > 8000 AND incomeSum <= 15000) THEN
		SET incomeRange = "8001-15000";
	ELSEIF (incomeSum > 15000) THEN
		SET incomeRange = ">15000";
	ELSE
		SET incomeRange = "700-8000";
	END IF;
    RETURN incomeRange;
END $$
DELIMITER ;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR RESIDÊNCIA
SELECT * FROM pessoas;

SELECT DISTINCT(residencia) FROM pessoas;

DELIMITER $$
CREATE FUNCTION GetResidenceType(residence INTEGER) RETURNS CHAR(8) DETERMINISTIC
BEGIN
	DECLARE residenceType CHAR(8);
    IF (residence = 1) THEN
		SET residenceType = "Own";
	ELSEIF (residence = 2) THEN
		SET residenceType = "Rented";
	ELSEIF (residence = 3) THEN
		SET residenceType = "Family";
	ELSE
		SET residenceType = "Family";
	END IF;
    RETURN residenceType;
END $$
DELIMITER ;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO PREVISOR VEÍCULO
SELECT DISTINCT(veiculo) FROM pessoas;

DELIMITER $$
CREATE FUNCTION GetVehicle(vehicle INTEGER) RETURNS CHAR(3) DETERMINISTIC
BEGIN
	DECLARE hasVehicle CHAR(3);
    IF (vehicle = 1) THEN
		SET hasVehicle = "Yes";
	ELSE
		SET hasVehicle = "No";
	END IF;
    RETURN hasVehicle;
END $$
DELIMITER ;

-- PRÉ-PROCESSAMENTO DO ATRIBUTO CLASSE PERFIL DO PAGADOR
SELECT v.idpessoa, COUNT(*) AS parcelas
FROM pessoas p
INNER JOIN vendas v ON p.id = v.idpessoa
INNER JOIN venda_parcelas vp ON vp.idvenda = v.idvenda
GROUP BY 1;

DELIMITER $$
CREATE FUNCTION GetClientProfile(clientProfile INTEGER) RETURNS CHAR(10) DETERMINISTIC
BEGIN
	DECLARE profileClassification CHAR(10);
    DECLARE installments INTEGER;
    SELECT COUNT(*) INTO installments
    FROM pessoas p
    INNER JOIN vendas v ON p.id = v.idpessoa
    INNER JOIN venda_parcelas vp ON vp.idvenda = v.idvenda
    WHERE p.id = clientProfile AND vp.pago = 0;
    IF (installments >= 0 AND installments < 7) THEN
		SET profileClassification = "Good";
	ELSEIF (installments >= 7 AND installments < 21) THEN
		SET profileClassification = "Average";
	ELSE
		SET profileClassification = "Bad";
	END IF;
    RETURN profileClassification;
END $$
DELIMITER ;

SELECT
	GetClientProfile(id),
    COUNT(*) AS qtde
FROM pessoas
GROUP BY 1;

-- SELECT DOS DADOS PRÉ-PROCESSADOS
SELECT 
	genero AS Gender,
    GetAge(YEAR(NOW()) - YEAR(nascimento)) AS Age,
    GetMaritalStatus(estado_civil) AS MaritalStatus,
    GetDependentPeople(
		(SELECT COUNT(pd.id)
		FROM pessoa_dependentes pd
		WHERE pd.idpessoa = pessoas.id)
	) AS Dependents,
    GetIncomeRange(
		(SELECT SUM(salario)
        FROM pessoa_empresas pe
        WHERE pe.idpessoa = pessoas.id)
	) AS Income,
    GetResidenceType(residencia) AS ResidenceType,
    GetVehicle(veiculo) AS Vehicle,
    GetClientProfile(id) AS ClientProfile
FROM pessoas;

-- CRIAÇÃO DE TABELA PARA ARMAZENAR BASE DE DADOS PRÉ-PROCESSADA
CREATE TABLE Pre_Processed_Data (
	Gender VARCHAR(10),
    Age VARCHAR(10),
    Marital_Status VARCHAR(10),
    Dependents VARCHAR(10),
    Income VARCHAR(10),
    Residence_Type VARCHAR(10),
    Vehicle VARCHAR(10),
    Client_Profile VARCHAR(10)
);

INSERT INTO Pre_Processed_Data
SELECT 
	genero AS Gender,
    GetAge(YEAR(NOW()) - YEAR(nascimento)) AS Age,
    GetMaritalStatus(estado_civil) AS MaritalStatus,
    GetDependentPeople(
		(SELECT COUNT(pd.id)
		FROM pessoa_dependentes pd
		WHERE pd.idpessoa = pessoas.id)
	) AS Dependents,
    GetIncomeRange(
		(SELECT SUM(salario)
        FROM pessoa_empresas pe
        WHERE pe.idpessoa = pessoas.id)
	) AS Income,
    GetResidenceType(residencia) AS ResidenceType,
    GetVehicle(veiculo) AS Vehicle,
    GetClientProfile(id) AS ClientProfile
FROM pessoas;

SELECT * FROM Pre_Processed_Data;