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
		&& isset($_POST['no_pieza']) && isset($_POST['laboratorio'])
		&& isset($_POST['tipo_material']) ){
			if($_POST['laboratorio'] == "0"){
				echo "Error no llenaste laboratorio";
			}

			else if($_POST['tipo_material'] == "0"){
				echo "Error no llenaste material";
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
					"Echo felizidades llenaste todos los campos";
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
								$sql = "UPDATE material set ficha_tecnica = ? WHERE id = ?";
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
							$sql = "UPDATE material SET descripcion = ?, marca = ?, modelo = ?, cantidad = ?, habilitadas = ?, no_pieza = ?,  tipo_material = ?, laboratorio = ? WHERE id = ?";
							$stm = $con->prepare($sql);
							$stm->bind_param("sssiiiiis",$_POST['descripcion'],$_POST['marca'], $_POST['modelo'],$_POST['n_piezas'], $_POST['habilitadas'],$_POST['no_pieza'], $_POST['tipo_material'], $_POST['laboratorio'], $_POST['id']);
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
							$sql = "INSERT INTO  material  (id ,  descripcion ,  marca ,  modelo ,  cantidad ,  habilitadas ,  no_pieza ,  img ,  ficha_tecnica ,  tipo_material ,  laboratorio ) VALUES ( ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)";
							$stm = $con->prepare($sql);
							//echo "SQL: ".$_POST['id'].$_POST['descripcion'].$_POST['marca'].$_POST['modelo'].intval($_POST['n_piezas']).intval($_POST['habilitadas']).intval($_POST['no_pieza']).$img_url.$datasheet_url.intval($_POST['tipo_material']).intval($_POST['laboratorio']);
							$stm->bind_param("ssssiiissii",$_POST['id'],$_POST['descripcion'],$_POST['marca'], $_POST['modelo'],$_POST['n_piezas'], $_POST['habilitadas'],$_POST['no_pieza'],$image_url,$datasheet_url, $_POST['laboratorio'], $_POST['tipo_material']);
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
						}
						
						
					}
				}

				else{
					echo "No llenaste todos los campos";
				}
			}
		}

		else{
			echo "Error. No estan definidas algunas variables";
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
		/*
		$connection = $con;
		$item = $_GET['item'];
		$sql = "SELECT * from material WHERE id=?";
		$stm = $connection->prepare($sql);
		$stm->bind_param("s",$_GET['item']);
		$stm->execute();
		$res = $stm->get_result();
		$main_obj = new StdClass();
		$counter = 0;
		while($row = $res->fetch_assoc()){
			$item_title = "item_".$counter;
			$obj = new stdClass();
			$obj->nombre = $row['descripcion'];
			$obj->marca = $row['marca'];
			$obj->modelo = $row['modelo'];
			$obj->cantidad = $row['cantidad'];
			$obj->habilitadas = $row['habilitadas'];
			$obj->no_pieza = $row['no_pieza'];
			$obj->img = $row['img'];
			$obj->ficha_tecnica = $row['ficha_tecnica'];
			$obj->tipo_material = $row['tipo_material'];
			$obj->laboratorio = $row['laboratorio'];
			$main_obj->$item_title = $obj;
			$counter += 1;
			//echo $json_obj;
		}
		*/
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

	else{
		//echo "Wrong request";
		$obj = new StdClass();
		$obj->message = "error. Request is wrong!";
		echo json_encode($obj);
	}
?>