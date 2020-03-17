
/*Creación de procedimiento para asignar ficha de mantenimiento con diferentes actividades*/


DELIMITER $$
CREATE or REPLACE PROCEDURE asignar_actividades(IN id_mat  VARCHAR(30), IN anio INT, IN la INT, IN lista_fechas TEXT(200)) 
BEGIN
  DECLARE id_hoja_mantenimiento INT;
  DECLARE id_lap INT;
  DECLARE total_actividaes INT  DEFAULT 0;
  DECLARE contador INT;
  DECLARE id_actividad_inicial INT;
  DECLARE id_actividad_final INT;

  DECLARE fecha_parcial TEXT;
  DECLARE fecha_parcial_tamanio INT;
  DECLARE fecha_final TEXT;


  INSERT INTO hojas_mantenimiento VALUES (null,id_mat,anio);
  SET @id_hoja_mantenimiento := (SELECT max(id) FROM hojas_mantenimiento WHERE id_material = id_mat);
  UPDATE material SET hoja_mantenimiento = @id_hoja_mantenimiento WHERE id = id_mat;

WHILE LENGTH(TRIM(lista_fechas)) > 0 DO
    SET fecha_parcial = SUBSTRING_INDEX(lista_fechas,",",1);
    SET fecha_parcial_tamanio = LENGTH(fecha_parcial);
    SET fecha_final = TRIM(fecha_parcial);
    INSERT INTO lista_actividades_programadas VALUES (NULL,fecha_final,"","","NINGUNO",@id_hoja_mantenimiento);
    SET @id_lap := (SELECT MAX(id) from lista_actividades_programadas where hoja_mantenimiento = @id_hoja_mantenimiento);
    SET @total_actividaes := (SELECT count(id) from lista_actividades_detalle WHERE lista_actividades = la);
    SET @id_actividad_inicial := (SELECT min(id) from lista_actividades_detalle WHERE lista_actividades = la);
    SET @id_actividad_final := (@id_actividad_inicial + @total_actividaes - 1);
    SET @contador := @id_actividad_inicial;

    
    WHILE @contador <= @id_actividad_final DO
      INSERT INTO lista_actividades_programadas_detalle VALUES(null,@id_lap,@contador,0);
      SET @contador = @contador + 1;
    END WHILE;

    SET lista_fechas = INSERT(lista_fechas,1,fecha_parcial_tamanio + 1, "");
  
  END WHILE;
  /*FIn creación actividades programadas*/

  SELECT @id_hoja_mantenimiento,@id_lap,@total_actividaes,@id_actividad_inicial,@id_actividad_final,@contador;
END$$

call asignar_actividades("1234-001-ABCD",2021,2,'2020-02-11,2020-03-11,2020-04-11,2020-05-11');