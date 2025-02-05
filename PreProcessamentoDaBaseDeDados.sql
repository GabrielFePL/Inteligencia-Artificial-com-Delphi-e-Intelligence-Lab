USE vendas;

SELECT 
	genero,
    GetAge(YEAR(NOW()) - YEAR(nascimento))
FROM pessoas;

SELECT * FROM pessoas;

SELECT DISTINCT(genero) FROM pessoas;

SELECT genero, COUNT(*) AS quantidade FROM pessoas GROUP BY genero;

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