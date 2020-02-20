<?php
	require_once("connection.php");


	function insertItem($post_data){
		if($post_data['insert_modify'] == 'insert'){
			//insert file image

			//Files properties
			/*
			$_FILES['item_image']['name'];
			$_FILES['item_image']['tmp_name'];
			$_FILES['item_image']['size'];
			$_FILES['item_image']['name'];
			*/

			/*
			$filename = $_FILES['item_image']['name'];
			$sql = "INSERT INTO material ('id', 'descripcion', 'marca', 'modelo', 'cantidad', 'habilitadas', 'no_pieza', 'tipo_material', 'laboratorio') VALUES (?,?,?,?,?,?,?,?,?);"
			//return $filename;

			*/
		}

		else if($post_data['insert_modify'] == 'modify'){
			return "MODIFICAR";
		}
	}

	function getItems($stm){
		$stm->execute(); 
		$res = $stm->get_result();
		$main_obj = new StdClass();
		$counter = 0;
		while($row = $res->fetch_assoc()){
			$item_title = "item_".$counter;
			$obj = new stdClass();
			$obj->id = $row['id'];
			$obj->nombre = $row['descripcion'];
			$obj->marca = $row['marca'];
			$obj->modelo = $row['modelo'];
			$obj->cantidad = $row['cantidad'];
			$obj->habilitadas = $row['habilitadas'];
			$obj->img = $row['img'];
			$obj->ficha_tecnica = $row['ruta_manual'];
			$obj->tipo_material = $row['tipo_material'];
			$obj->laboratorio = $row['laboratorio'];
			$main_obj->$item_title = $obj;
			$counter += 1;
			//echo $json_obj;
		}
		if($counter == 0){
			$main_obj->error = "no existen resultados";
			return $main_obj;
		}

		else{
			return $main_obj;
		}
	}

	function checkItemId($stm){
		$stm->execute();
		$res = $stm->get_result();
		$n_results = 0;
		while($row = $res->fetch_assoc()){
			$n_results += 1;
		}

		return $n_results;
	}
?>