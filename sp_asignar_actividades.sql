
/*Creación de procedimiento para asignar ficha de mantenimiento con diferentes actividades*/


DELIMITER $$
CREATE or REPLACE PROCEDURE asignar_actividades(IN id_mat  VARCHAR(30), IN fecha DATE, IN la  INT) 
BEGIN
  DECLARE id_hoja_mantenimiento INT;
  DECLARE id_lap INT;
  DECLARE total_actividaes INT  DEFAULT 0;
  DECLARE contador INT;
  DECLARE id_actividad_inicial INT;
  DECLARE id_actividad_final INT;

  SET @id_hoja_mantenimiento := (select id from hojas_mantenimiento where hojas_mantenimiento.anio = (SELECT max(anio) FROM hojas_mantenimiento WHERE id_material = id_mat));
  INSERT INTO lista_actividades_programadas VALUES (NULL,fecha,"diego","jaime","NINGUNO",@id_hoja_mantenimiento);
  SET @id_lap := (SELECT MAX(id) from lista_actividades_programadas where hoja_mantenimiento = @id_hoja_mantenimiento);
  SET @total_actividaes := (SELECT count(id) from lista_actividades_detalle WHERE lista_actividades = la);
  SET @id_actividad_inicial := (SELECT min(id) from lista_actividades_detalle WHERE lista_actividades = la);
  SET @id_actividad_final := (@id_actividad_inicial + @total_actividaes - 1);
  SET @contador := @id_actividad_inicial;

  
  WHILE @contador <= @id_actividad_final DO
    INSERT INTO lista_actividades_programadas_detalle VALUES(null,@id_lap,@contador,0);
    SET @contador = @contador + 1;
  END WHILE;
  

  SELECT @id_hoja_mantenimiento,@id_lap,@total_actividaes,@id_actividad_inicial,@id_actividad_final,@contador;
END$$

call asignar_actividades("1234-001-ABCD",'2020-02-11',1);
