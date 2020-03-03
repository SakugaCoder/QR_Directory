<?php 
	require_once('connection.php'); 
	require_once('DBFunctions.php');
	header("Content-Type: application/json");
	
	//Si se va a insertar o modificar
	if(isset($_POST['insert_modify'])){
		$uploads_dir = "assets/";
		$images_dir = "images/";
		$datasheet_dir = "datasheets/";
		$image_url = null;
		$datasheet_url = null;
		$item_full_id = $_POST['id'];
		$item_partial_id = (explode("-",$item_full_id))[0] . "-" . (explode("-",$item_full_id))[2];

		$image_exists = false;
		$datasheet_exists = false;

		$response = new StdClass();
		
		//Check for image available
		if(isset($_FILES['item_image'])){
			if($_FILES['item_image']['size'] > 0){
				//Validate image extension
				$image_name = $_FILES['item_image']['name'];
				$image_extension = (explode(".",$image_name))[sizeof(explode(".",$image_name)) - 1];

				if(file_exists($uploads_dir.$images_dir.$image_name)){
					echo "El archivo ya existe";
					$image_exist = true;
					$image_url = $uploads_dir.$images_dir.$image_name;
				}

				else if($image_extension == "jpg" || $image_extension == "png" || $image_extension == "jpeg"){
					$image_tmp_url = $_FILES['item_image']['tmp_name'];
					$image_target = $uploads_dir.$images_dir.$image_name;
					if( move_uploaded_file($image_tmp_url,$image_target) ){
						echo $image_target;
						echo "Archivo subido correctamente";
						$image_url = $image_target;
					}

					else{
						echo "Error al subir la imagen";
					}
				}

				else{
					echo "Error. Elige una imagen por favor";
				}
			}
		}

		if(isset($_FILES['ficha_tecnica'])){
			if($_FILES['ficha_tecnica']['size'] > 0){
				//Validate image extension
				$datasheet_name = $_FILES['ficha_tecnica']['name'];
				$datasheet_extension = (explode(".",$datasheet_name))[sizeof(explode(".",$datasheet_name)) - 1];
				if(file_exists($uploads_dir.$datasheet_dir.$datasheet_name)){
					echo "El archivo ya existe";
					$datasheet_exists = true;
					$datasheet_url = $uploads_dir.$datasheet_dir.$datasheet_name;
				}
				else if($datasheet_extension == "doc" || $datasheet_extension == "docx" || $datasheet_extension == "pdf"){
					$datasheet_tmp_url = $_FILES['ficha_tecnica']['tmp_name'];
					$datasheet_target = $uploads_dir.$datasheet_dir.$datasheet_name;
					if( move_uploaded_file($datasheet_tmp_url,$datasheet_target) ){
						echo $datasheet_target;
						echo "Archivo subido correctamente";
						$datasheet_url = $datasheet_target;
					}

					else{
						echo "Error al subir la ficha tecnica";
					}
				}

				else{
					echo "Error. Elige uno de los siguientes formatos: pdf, doc, docx";
				}
			}
		}


		if(isset($_POST['id']) && isset($_POST['descripcion'])
		&& isset($_POST['marca']) && isset($_POST['modelo'])
		&& isset($_POST['n_piezas']) && isset($_POST['habilitadas']) 
		&& isset($_POST['laboratorio']) && isset($_POST['tipo_material']) ){
			if($_POST['laboratorio'] == "0"){
				echo "Error no llenaste laboratorio";
				$response->error = "Error no llenaste laboratorio";
				echo json_encode($response);
			}

			else if($_POST['tipo_material'] == "0"){
				echo "Error no llenaste material";
				$response->error = "Error no llenaste laboratorio";
				echo json_encode($response);
			}

			else{

				$all_values_filled = true;
				foreach($_POST as $clave => $valor){
					if(strlen($valor) == 0){
						$all_values_filled = false;
						echo "LLena ".$clave." por favor";
					}
				}

				if($all_values_filled){
					echo "felicidadez llenaste todos los campos";
					echo "Has llenado todo incluyendo lab y kind";
					$option = $_POST['insert_modify'];
					$sql = "SELECT * from material where id = ?";
					$stm = $con->prepare($sql);
					$stm->bind_param("s",$_POST['id']);
					$coincidence_number = checkItemId($stm);
					if($option == "modify"){
						if($coincidence_number == 1){

							//Modify image url if is necesary
							if($image_url != null){
								echo "La img url es: ".$image_url."la id es: ".$_POST['id'];
								$sql = "UPDATE material set img = ? WHERE id = ?";
								$stm = $con->prepare($sql);
								$stm->bind_param("ss",$image_url,$_POST['id']);
								$stm->execute();
								if($stm){
									echo "Imagen actualizada";
								}

								else{
									echo "Error actualizando imagen";
								}
							}
							//Modify datasheet if is necesary
							if($datasheet_url != null){
								echo "La datasheet url es: ".$datasheet_url."la id es: ".$_POST['id'];
								$sql = "UPDATE material set ruta_manual = ? WHERE id = ?";
								$stm = $con->prepare($sql);
								$stm->bind_param("ss",$datasheet_url,$_POST['id']);
								$stm->execute();
								if($stm){
									echo "Datasheet actualizada";
								}

								else{
									echo "Error actualizando datasheet";
								}

							}
							
							echo "Modificando elementos";
							$sql = "UPDATE material SET descripcion = ?, marca = ?, modelo = ?, cantidad = ?, habilitadas = ?,  tipo_material = ?, laboratorio = ? WHERE id = ?";
							$stm = $con->prepare($sql);
							$stm->bind_param("sssiiiis",$_POST['descripcion'],$_POST['marca'], $_POST['modelo'],$_POST['n_piezas'], $_POST['habilitadas'], $_POST['tipo_material'], $_POST['laboratorio'], $_POST['id']);
							$stm->execute();
							if($stm){
								echo "Edición exitosa";
							}

							else{
								echo "Error al actualizar datos";
							}
							
						}

						else{
							echo "No existe el elemento que quieres modificar";
						}

					}
					else if($option == "insert"){
						echo "Insertando elementos";
						if($coincidence_number == 0){
							$sql = "INSERT INTO  material  (id ,  descripcion ,  marca ,  modelo ,  cantidad ,  habilitadas,  img ,  ruta_manual ,  tipo_material ,  laboratorio, hoja_mantenimiento ) VALUES ( ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)";
							$stm = $con->prepare($sql);
							$hoja_mantenimiento = null;
							//echo "SQL: ".$_POST['id'].$_POST['descripcion'].$_POST['marca'].$_POST['modelo'].intval($_POST['n_piezas']).intval($_POST['habilitadas']).$img_url.$datasheet_url.intval($_POST['tipo_material']).intval($_POST['laboratorio']);
							$stm->bind_param("ssssiissiii",$_POST['id'],$_POST['descripcion'],$_POST['marca'], $_POST['modelo'],$_POST['n_piezas'], $_POST['habilitadas'],$image_url,$datasheet_url, $_POST['tipo_material'],  $_POST['laboratorio'],$hoja_mantenimiento);
							$stm->execute();
							if($stm){
								echo "Insertado correctamente";
							}

							else{
								echo "Error insertando elemento";
							}
						}

						else{
							echo "Error. La id del material ya existe";
							$response->error =" Error. El material ya existe";
							echo json_encode($response);
						}
						
						
					}
				}

				else{
					echo "No llenaste todos los campos";
					$response->error = "Error. No llenaste todos los campos";
					echo json_encode($response);
				}
			}
		}

		else{
			echo "Error. No estan definidas algunas variables";
			$response->error = "Error. No estan definidas algunas variables";
			echo json_encode($response);
		}

		/*
		$filename = $_FILES;
		$obj = new StdClass();
		$obj ->message = insertItem($_POST);
		echo json_encode($obj);
		*/
		
	}

	else if(isset($_GET['item'])){
		$item = $_GET['item'];
		$sql = "SELECT * from material WHERE id=?";
		$stm = $con->prepare($sql);
		$stm->bind_param("s",$_GET['item']);
		echo json_encode(getItems($stm));
	}

	else if(isset($_GET['search_value']) && isset($_GET['lab']) && isset($_GET['kind'])){
		
		if(strlen($_GET['search_value']) > 0){
			//echo "There are some values in the search";

			//Lab and kind has changes
			if($_GET['lab'] != "0" && $_GET['kind'] != "0"){
				//echo "All has changes";
				$lab = intval($_GET['lab']);
				$kind = intval($_GET['kind']);
				$search_value = $_GET['search_value'];
				$sv = "%".$search_value."%";
				$sql = "SELECT * from material WHERE laboratorio = ? and tipo_material = ? and descripcion LIKE ? ";
				$stm = $con->prepare($sql);
				$stm->bind_param("iis",$lab,$kind,$sv);
				echo json_encode(getItems($stm));
			}


			//Lab or kind has changes
			else if($_GET['lab'] != "0" || $_GET['kind'] != "0"){
				//Lab has chagnes
				if($_GET['lab'] != "0"){
					//echo "Search and lab has changes";
					$lab = intval($_GET['lab']);
					$search_value = $_GET['search_value'];
					$sv = "%".$search_value."%";
					$sql = "SELECT * from material WHERE laboratorio = ? and descripcion LIKE ? ";
					$stm = $con->prepare($sql);
					$stm->bind_param("is",$lab,$sv);
					echo json_encode(getItems($stm));
				}
				
				//Kind has changes
				else{
					//echo "Search and kind has changes";
					$kind = intval($_GET['kind']);
					$search_value = $_GET['search_value'];
					$sv = "%".$search_value."%";
					$sql = "SELECT * from material WHERE tipo_material = ? and descripcion LIKE ? ";
					$stm = $con->prepare($sql);
					$stm->bind_param("is",$kind,$sv);
					echo json_encode(getItems($stm));
				}
			}

			//No changes on lab and kind
			else{
				//echo "Only search has changes";
				$search_value = $_GET['search_value'];
				$sv = "%".$search_value."%";
				$sql = "SELECT * from material WHERE descripcion LIKE ? ";
				$stm = $con->prepare($sql);
				$stm->bind_param("s",$sv);
				echo json_encode(getItems($stm));
			}
		}

		//No value on search_value
		else{
			//Lab and kind has changes
			if($_GET['lab'] != "0" && $_GET['kind'] != "0"){
				//echo "Only lab and kind has changes";
				$lab = intval($_GET['lab']);
				$kind = intval($_GET['kind']);
				$sql = "SELECT * from material WHERE laboratorio = ? and tipo_material = ?";
				$stm = $con->prepare($sql);
				$stm->bind_param("ii",$lab,$kind);
				echo json_encode(getItems($stm));
			}


			//Lab or kind has changes
			else if($_GET['lab'] != "0" || $_GET['kind'] != "0"){
				//Lab has chagnes
				if($_GET['lab'] != "0"){
					//echo "Only lab has changes";
					$lab = intval($_GET['lab']);
					$sql = "SELECT * from material WHERE laboratorio = ?";
					$stm = $con->prepare($sql);
					$stm->bind_param("i",$lab);
					echo json_encode(getItems($stm));
				}
				
				//Kind has changes
				else{
					//echo "Only kind has changes";
					$kind = intval($_GET['kind']);
					$sql = "SELECT * from material WHERE tipo_material = ?";
					$stm = $con->prepare($sql);
					$stm->bind_param("i",$kind);
					echo json_encode(getItems($stm));
				}
			}

			//No changes on lab and kind
			else{
				$obj = new stdClass();
				$obj->error = "No se envio ningun dato";
				echo json_encode($obj);
			}
		}
		/*
		$search_value = $_GET['search_value'];
        $lab = $_GET['lab'];
        $kind = $_GET['kind'];
        $res = new stdClass();
        $res->lab = $lab;
        $res->search_value = $search_value;
        $res->kind = $kind;
        $res_json = json_encode($res);
		echo $res_json;
		*/
	}
	
	else if( $_SERVER['REQUEST_METHOD'] == "DELETE"){
		$file = parse_str(file_get_contents("php://input"),$post_vars);
		//print_r($post_vars);
		$item = null;
		foreach($post_vars as $key => $value){
			$lines = explode("\r",explode("\n",$value)[2]);
			$item = $lines[0];
			//echo $item;
			//echo $lines[2];
		}
		if($item != null){
			$sql = "DELETE FROM material WHERE id = ?";
			$stm = $con->prepare($sql);
			$stm->bind_param("s",$item);
			$stm->execute();
			$obj = new StdClass();
			if($stm){
				$obj->message = "Elemento borrado";
				$obj->item_deleted = $item;
				echo json_encode($obj);
			}

			else{
				$obj->error = "Error al borrar elemento";
				echo json_encode($obj);
			}
		}
	}

	else if(isset($_POST['new_support_sheet'])){
		$start_date = $_POST['fecha_inicio'];
		$end_date = $_POST['fecha_termino'];
		$item = $_POST['material'];
		$active = 1;

		$sql = "INSERT INTO hojas_mantenimiento (material, fecha_inicio, fecha_termino, activa) VALUES ( ?, ?, ?, ?)";
		$stm = $con->prepare($sql);
		$stm->bind_param("sssi",$item,$start_date,$end_date,$active);
		$stm->execute();
		if($stm){
			$sql = "SELECT max(id) as ID FROM hojas_mantenimiento";
			$stm->prepare($sql);
			$stm->execute();
			$res = $stm->get_result();
			$row = $res->fetch_assoc();
			echo $row['ID'];
		}

		else{
			echo "error";
		}
	}

	else if(isset($_POST['new_activity'])){
		$description = $_POST['descripcion'];
		$start_date = $_POST['fecha_inicio'];
		$end_date = $_POST['fecha_termino'];
		$finished = 0;
		$support_sheet = $_POST['hoja_mantenimiento'];

		$sql = "INSERT INTO actividades_mantenimiento (descripcion, fecha_inicio, fecha_termino, terminada, hoja_mantenimiento) VALUES ( ?, ?, ?, ?, ?)";
		$stm = $con->prepare($sql);
		$stm->bind_param("sssii",$description,$start_date,$end_date,$finished,$support_sheet);
		$stm->execute();
		if($stm){
			echo "ok";
		}

		else{
			echo "error";
		}
	}

	else if(isset($_GET['support_sheet']) && isset($_GET['material'])){
		$obj = new StdClass();
		$item = $_GET['material'];
		$sql = "SELECT * from hojas_mantenimiento WHERE material = ?";
		$stm = $con->prepare($sql);
		$stm->bind_param("s",$item);
		$stm->execute();
		$res = $stm->get_result();
		$n_res = 0;
		while( $row = $res->fetch_assoc()){
			$item_name = "sheet_".$n_res;
			$sheet = new StdCLass();
			$sheet->id = $row['id'];
			$sheet->fecha_inicio = $row['fecha_inicio'];
			$sheet->fecha_termino = $row['fecha_termino'];
			$sheet->activa = $row['activa'];

			$sql2 = "SELECT * FROM actividades_mantenimiento WHERE hoja_mantenimiento = ?";
			$stm2 = $con->prepare($sql2);
			$stm2->bind_param("i",$sheet->id);
			$stm2->execute();
			$res2 = $stm2->get_result();
			$n_res2 = 0;

			$activities = new StdClass();
			while($row2 = $res2->fetch_assoc()){
				$act_name = "activity_".$n_res2;
				$activity = new StdCLass();
				$activity->id = $row2['id'];
				$activity->descripcion = $row2['descripcion'];
				$activity->fecha_inicio = $row2['fecha_inicio'];
				$activity->fecha_termino = $row2['fecha_termino'];
				$activity->terminada = $row2['terminada'];
				$activities->$act_name = $activity;
				$n_res2 = $n_res2 + 1;
			}

			if($n_res2 > 0){
				$sheet->activities = $activities;
			}
			$sheet->n_activities = $n_res2;

			$n_res = $n_res + 1;
			$obj->$item_name = $sheet;
		}

		if($n_res > 0){
			echo json_encode($obj);
		}

		else{
			$obj = new StdClass();
			$obj->error = "No hay sheets para mostrar";
			echo json_encode($obj);
		}
	}


	else if(isset($_POST['change_act_status'])){
		$id = $_POST['id'];
		$status = $_POST['to'];
		$sql = "UPDATE actividades_mantenimiento SET terminada = ? WHERE id = ?";
		$stm = $con->prepare($sql);
		$stm->bind_param("ii",$status,$id);
		$stm->execute();
		if($stm){
			echo "ok";
		}

		else{
			echo "error";
		}
	}

	//Metodo para crear nueva lista de
	else if(isset($_POST['lista_actividades']) && isset($_POST['nombre_lista_actividades']) ){
		$lista_actividades = $_POST['lista_actividades'];
		$nombre_lista_actividades = $_POST['nombre_lista_actividades'];
		$sql = "CALL almacenar_nuevas_actividades(?, ?);";
		$stm = $con->prepare($sql);
		$stm->bind_param("ss",$lista_actividades,$nombre_lista_actividades);
		$stm->execute();
		$res = $stm->get_result();

		$response = new StdClass();
		if($stm){
			
			$response ->error = false; 
		}

		else{
			$response ->error = true; 
		}

		echo json_encode($response);
	}

	//Metodo para crear nueva hoja mantenimiento
	else if (isset($_POST['anio']) && isset($_POST['id_material']) && isset($_POST['id_lista_actividades']) && isset($_POST['lista_fechas']) ){
		$anio = $_POST['anio'];
		$id_material = $_POST['id_material'];
		$id_lista_actividades = $_POST['id_lista_actividades'];
		$lista_fechas = $_POST['lista_fechas'];
		//call asignar_actividades("1234-001-ABCD",2021,2,'2020-02-11,2020-03-11,2020-04-11,2020-05-11');
		$sql = "CALL asignar_actividades(? , ?, ?, ?)";
		$stm = $con->prepare($sql);
		$stm->bind_param("siis",$id_material,$anio,$id_lista_actividades,$lista_fechas);
		$stm->execute();
		$res = $stm->get_result();
		
		
		$response = new StdClass();
		if($stm){
			$response->error = false; 
		}

		else{
			$response->error = true; 
		}

		echo json_encode($response);
	}


	//Metodo para desplegar las listas de actividades existentes
	else if( isset($_GET['lista_actividades'])){
		$sql = "SELECT * FROM lista_actividades";
		$stm = $con->prepare($sql);
		$stm->execute();
		$res = $stm->get_result();

		$response = new StdClass();
		$array_registros = [];

		while($lista_actividades = $res->fetch_assoc()){
			$list = new StdClass();
			$la_id = $lista_actividades['id'];
			$list-> id = $lista_actividades['id'];
			$list-> nombre_lista = $lista_actividades['nombre'];
			$sql2 = "SELECT * FROM lista_actividades_detalle WHERE lista_actividades = ? ";
			$stm2 = $con->prepare($sql2);
			$stm2->bind_param("i",$la_id);
			$stm2->execute();
			$res2 = $stm2->get_result();
			$list_id = "list_".$lista_actividades['id'];
			
			$activity_list = [];
			while($lista_actividades_detalle = $res2->fetch_assoc()){
				//echo $lista_actividades_detalle["actividad"];
				array_push($activity_list,$lista_actividades_detalle['actividad']);
			}

			array_push($array_registros,$list);
			$list-> actividades = $activity_list;
		}
		$response->Registros = $array_registros;

		if(sizeof(get_object_vars($response)) > 0){
			$response->error = false;
			$response->tieneRegistros = true;
		}

		else{
			$response->error = true;
			$response->tieneRegistros = false;
		}

		echo json_encode($response);

	}

	//Obtener id hoja mentenimiento si existe 

	else if(isset($_GET['hoja_mantenimiento']) && isset($_GET['id_material'])){
		$id_material = $_GET['id_material'];
		$sql = "SELECT hoja_mantenimiento FROM material WHERE id = ? ;";
		$stm = $con->prepare($sql);
		$stm->bind_param("s",$id_material);
		$stm->execute();
		$response = new StdClass();
		$array_listas_actividades_programadas =[];
		if($stm){
			$res = $stm->get_result();
			$resultado = $res->fetch_assoc();
			$id_hoja_mantenimiento = $resultado['hoja_mantenimiento'];
			$response -> hoja_mantenimiento = $id_hoja_mantenimiento;
			//Obtener activides programadas si existen
			if($id_hoja_mantenimiento != null){

				$sql2 = "SELECT * FROM lista_actividades_programadas WHERE hoja_mantenimiento = ? ;";
				$stm2 = $con->prepare($sql2);
				$stm2->bind_param("i",$id_hoja_mantenimiento);
				$stm2->execute();
				$res2 = $stm2->get_result();
				if($res2){
					
					while($hoja_actividades_programada = $res2->fetch_assoc()){
						$actividad_programada_detalle = new StdClass();
						$id_hoja_actividades_programadas =  $hoja_actividades_programada['id'];
						$actividad_programada_detalle -> id_lista_actividades_programadas = $hoja_actividades_programada['id'];
						$actividad_programada_detalle -> fecha = $hoja_actividades_programada['fecha'];
						$actividad_programada_detalle -> realizo = $hoja_actividades_programada['realizo'];
						$actividad_programada_detalle -> revizo = $hoja_actividades_programada['revizo'];
						$actividad_programada_detalle -> comentarios = $hoja_actividades_programada['comentarios'];
						$sql3 = "SELECT * FROM lista_actividades_programadas_detalle WHERE lista_actividades_programadas = ? ;";
						$stm3 = $con->prepare($sql3);
						$stm3->bind_param("i",$id_hoja_actividades_programadas);
						$stm3->execute();
						$res3 = $stm3->get_result();
						if($res3){
							$array_actividades_detalle = [];
							while($activiadad_programada = $res3->fetch_assoc()){
								$ap = new StdClass();
								$ap -> id_actividad = $activiadad_programada['id'];
								$ap -> actividad_detalle = $activiadad_programada['actividad_detalle'];
								$id_actividad_detalle = $activiadad_programada['actividad_detalle'];
								$sql4 = "SELECT actividad FROM lista_actividades_detalle WHERE id = ?; ";
								$stm4 = $con->prepare($sql4);
								$stm4->bind_param("i",$id_actividad_detalle);
								$stm4->execute();
								$res4 = $stm4->get_result();
								$nombre_actividad = ($res4->fetch_assoc())['actividad']; 
								$ap -> nombre_actividad = $nombre_actividad;
								$ap -> terminada = $activiadad_programada['terminada'];
								array_push($array_actividades_detalle,$ap);
							}
							$actividad_programada_detalle -> actividades = $array_actividades_detalle;
							array_push($array_listas_actividades_programadas,$actividad_programada_detalle);
						}
						
					}
					$response -> Registros = $array_listas_actividades_programadas;
				}
			}

			else{
				$response->Error = true;
			}
		}
		echo json_encode($response);
	}


	//Metodo para actualizar el estado de una actividad programada
	else if( isset($_POST['id_actividad']) && isset($_POST['nuevo_estado_actividad'])){
		$response = new StdClass();
		$id_actividad = $_POST['id_actividad'];
		$nuevo_estado_actividad = $_POST['nuevo_estado_actividad'];

		$sql = "UPDATE lista_actividades_programadas_detalle set terminada = ? WHERE id = ?;";
		$stm = $con->prepare($sql);
		$stm->bind_param("ii",$nuevo_estado_actividad,$id_actividad);
		$stm->execute();
		$res = $stm->get_result();
		if($stm){
			$response->error = false;
		}

		else{
			$response->error = true;
		}
		echo json_encode($response);
	}

	//Metodo para actualizar quién revizo, quién realizo, y los comentarios
	else if( isset($_POST['id_lista_actividades_programadas']) && isset($_POST['quien_realizo']) && isset($_POST['quien_revizo'])  && isset($_POST['comentarios']) ){
		$id_lista_actividades_programadas = $_POST['id_lista_actividades_programadas'];
		$quien_realizo = $_POST['quien_realizo'];
		$quien_reviso = $_POST['quien_revizo'];
		$comentarios = $_POST['comentarios'];

		$sql = "UPDATE lista_actividades_programadas SET realizo = ? ,revizo = ?, comentarios = ? WHERE id = ?";
		$stm = $con->prepare($sql);
		$stm->bind_param("sssi",$quien_realizo,$quien_reviso,$comentarios,$id_lista_actividades_programadas);
		$stm->execute();

		$response = new StdClass();
		if($stm){
			$response->error=false;
		}

		else{
			$response->error->true;
		}

		echo json_encode($response);
	}

	else if( isset($_GET['laboratorio'])){
		$id_lab = $_GET['laboratorio'];
		$sql = "SELECT * FROM material WHERE laboratorio = ? AND tipo_material = 3";
		$stm = $con->prepare($sql);
		$stm->bind_param("i",$id_lab);
		echo json_encode(getItems($stm));
	}

	else{
		//echo "Wrong request";
		$obj = new StdClass();
		$obj->error = "error. Request is wrong!";
		//echo json_encode($obj);
	}
?>