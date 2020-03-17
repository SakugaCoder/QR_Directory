DELIMITER $$
CREATE or REPLACE PROCEDURE almacenar_nuevas_actividades(IN Value longtext, IN nl varchar(100))
BEGIN
DECLARE front TEXT DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE TempValue TEXT DEFAULT NULL;
DECLARE id_lista_actividades INT DEFAULT 0;

INSERT INTO lista_actividades VALUES(NULL, nl);

SET @id_lista_actividades := (SELECT MAX(id) from lista_actividades WHERE nombre = nl);

iterator:
    LOOP 
    IF LENGTH(TRIM(Value)) = 0 OR Value IS NULL THEN
    LEAVE iterator;
    END IF;
    SET front = SUBSTRING_INDEX(Value,',',1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);
    INSERT INTO lista_actividades_detalle VALUES (NULL,@id_lista_actividades,TempValue);
    SET Value = INSERT(Value,1,frontlen + 1,'');
    END LOOP;
END$$


DELIMITER //
CREATE  or REPLACE  PROCEDURE test_splits(IN texto TEXT(200))
BEGIN

    DECLARE valor_parcial TEXT DEFAULT NULL;
    DECLARE valor_parcial_tamanio INT DEFAULT NULL;
    DECLARE valor_real TEXT DEFAULT NULL;
    WHILE LENGTH(TRIM(texto)) > 0 DO
        SET valor_parcial = SUBSTRING_INDEX(texto,",",1);
        SET valor_parcial_tamanio = LENGTH(valor_parcial);
        SET valor_real = TRIM(valor_parcial);
        INSERT INTO test_split VALUES (null,valor_real);
        SET texto = INSERT(texto, 1, valor_parcial_tamanio + 1,"");
    END WHILE;
    SELECT * FROM hojas_mantenimiento;
    
END//