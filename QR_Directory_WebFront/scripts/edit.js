(function(){
	validateLogin("admin");
	window.onload = function() {
		args = location.search.substr(1);
		console.log("Args length:"+args.length);
		if(args.length > 0){
			console.log(args.substr(0,4));
			if(args.substr(0,4) == "item"){
				if(args.substr(5) != ""){
					console.log(args.substr(5));
					getItem(args.substr(5));
					//Inicializa la bandera "insert_modify" en modify
					document.querySelector("#insert_modify").value = "modify";
				}

				else{
					/*
					$('.dropify').dropify();
	            	$('.dropify-2').dropify();
					alert("No se ha especificado elemento");
					document.querySelector("#insert_modify").value = "insert";
					*/
					window.location.replace("dashboard.html");
				}
				
			}
		}

		else{
			console.log("Se va a crear un nuevo elemento");
			document.querySelector("#insert_modify").value = "insert";
			document.querySelector("#id").removeAttribute("disabled");
			$('.dropify').dropify({
			    tpl: {
			        wrap:            '<div class="dropify-wrapper"></div>',
			        loader:          '<div class="dropify-loader"></div>',
			        message:         '<div class="dropify-message"><span class="file-icon" /> <p>¡Arrastra la imagen aqui!</p></div>',
			        preview:         '<div class="dropify-preview"><span class="dropify-render"></span><div class="dropify-infos"><div class="dropify-infos-inner"><p class="dropify-infos-message">Arrastra y suelta o haz click para reemplazar.</p></div></div></div>',
			        filename:        '<p class="dropify-filename"><span class="file-icon"></span> <span class="dropify-filename-inner"></span></p>',
			        clearButton:     '<button type="button" class="dropify-clear">Remover</button>',
			        errorLine:       '<p class="dropify-error">{{ error }}</p>',
			        errorsContainer: '<div class="dropify-errors-container"><ul></ul></div>'
			    }
			});

			let dpf1 = $('.dropify-2').dropify({
			    tpl: {
			        wrap:            '<div class="dropify-wrapper"></div>',
			        loader:          '<div class="dropify-loader"></div>',
			        message:         '<div class="dropify-message"><span class="file-icon" /> <p>¡Arrastra la ficha técnica aqui!</p></div>',
			        preview:         '<div class="dropify-preview"><span class="dropify-render"></span><div class="dropify-infos"><div class="dropify-infos-inner"><p class="dropify-infos-message">Arrastra y suelta o haz click para reemplazar.</p></div></div></div>',
			        filename:        '<p class="dropify-filename"><span class="file-icon"></span> <span class="dropify-filename-inner"></span></p>',
			        clearButton:     '<button type="button" class="dropify-clear">Remover</button>',
			        errorLine:       '<p class="dropify-error">{{ error }}</p>',
			        errorsContainer: '<div class="dropify-errors-container"><ul></ul></div>'
			    }
			});
			dpf1.on('dropify.afterClear', function(event, element){
			    alert('File deleted');
			});
			dpf1.on('change', function(event, element){
			    if(document.querySelector("#ficha_tecnica").files[0]){
			    	console.log("There is a file in the input");
			    }
			});
		}
	}
}());

function validateForm(evt){
	evt.preventDefault();
	console.log("Validating form...");
	(evt.target.elements).forEach( (input) => {
		console.log(input);
	});
}


function getItem(item){
	var fd = new FormData();
    let XMLHttp = new XMLHttpRequest();
    XMLHttp.onreadystatechange = function() {
        console.log("State ready change");
        if(this.readyState == 4 && this.status == 200){
            console.log("Respuesta recibida");
            console.log(JSON.parse(this.responseText));
            var items = JSON.parse(this.responseText);
            let edit_form = document.querySelector("#edit-form");
            if(items.error){
                console.log(items.error);
                Swal.fire({
                  icon: 'error',
                  title: 'Lo siento!',
                  text: items.error,
                });
            }
            else{
                for(item in items){
                    let id = items[item].id;
                    let cantidad = items[item].cantidad;
                    let ficha_tecnica = items[item].ficha_tecnica;
                    let habilitadas = items[item].habilitadas;
                    let img = items[item].img;
                    let laboratorio = items[item].laboratorio;
                    let marca = items[item].marca;
                    let modelo = items[item].modelo;
                    let nombre = items[item].nombre;
                    let tipo_material = items[item].tipo_material;

                    edit_form.id.value = id;
                    edit_form.descripcion.value = nombre;
                    edit_form.marca.value = marca;
                    edit_form.modelo.value = modelo;
                    edit_form.n_piezas.value = cantidad;
                    edit_form.habilitadas.value = habilitadas;
					edit_form.id.value = id;

					console.log("Lab: "+laboratorio);
					console.log("Tipo material: "+tipo_material);

                    edit_form.laboratorio.selectedIndex = Number(laboratorio);
                    edit_form.tipo_material.selectedIndex = Number(tipo_material);

                    edit_form.item_image.setAttribute("data-default-file","http://localhost/QR_Directory/QR_Directory_API/"+img);
                    edit_form.ficha_tecnica.setAttribute("data-default-file","http://localhost/QR_Directory/QR_Directory_API/"+ficha_tecnica);
                    document.querySelector("#datasheet_prev").setAttribute("data","http://localhost/QR_Directory/QR_Directory_API/"+ficha_tecnica);
					$('.dropify').dropify({
					    tpl: {
					        wrap:            '<div class="dropify-wrapper"></div>',
					        loader:          '<div class="dropify-loader"></div>',
					        message:         '<div class="dropify-message"><span class="file-icon" /> <p>¡Arrastra la imagen aqui!</p></div>',
					        preview:         '<div class="dropify-preview"><span class="dropify-render"></span><div class="dropify-infos"><div class="dropify-infos-inner"><p class="dropify-infos-message">Arrastra y suelta o haz click para reemplazar.</p></div></div></div>',
					        filename:        '<p class="dropify-filename"><span class="file-icon"></span> <span class="dropify-filename-inner"></span></p>',
					        clearButton:     '<button type="button" class="dropify-clear">Remover</button>',
					        errorLine:       '<p class="dropify-error">{{ error }}</p>',
					        errorsContainer: '<div class="dropify-errors-container"><ul></ul></div>'
					    }
					});
					$('.dropify-2').dropify({
					    tpl: {
					        wrap:            '<div class="dropify-wrapper"></div>',
					        loader:          '<div class="dropify-loader"></div>',
					        message:         '<div class="dropify-message"><span class="file-icon" /> <p>¡Arrastra la ficha técnica aqui!</p></div>',
					        preview:         '<div class="dropify-preview"><span class="dropify-render"></span><div class="dropify-infos"><div class="dropify-infos-inner"><p class="dropify-infos-message">Arrastra y suelta o haz click para reemplazar.</p></div></div></div>',
					        filename:        '<p class="dropify-filename"><span class="file-icon"></span> <span class="dropify-filename-inner"></span></p>',
					        clearButton:     '<button type="button" class="dropify-clear">Remover</button>',
					        errorLine:       '<p class="dropify-error">{{ error }}</p>',
					        errorsContainer: '<div class="dropify-errors-container"><ul></ul></div>'
					    }
					});
                }
            }
        }
    };
    XMLHttp.open("GET","http://localhost/QR_Directory/QR_Directory_API/api.php?item="+item,true);
    XMLHttp.send();
}

function insertItem(evt){
	evt.preventDefault();
	let fd = new FormData();
	for(let i = 0; i < evt.target.elements.length; i++){
		if(evt.target.elements[i].name){
			let name,value;
			name = evt.target.elements[i].name;
			console.log("Name: "+evt.target.elements[i].name);
			console.log("Element type: "+evt.target.elements[i].type);
			if(evt.target.elements[i].type == "select-one"){
				console.log("Elemento es select:");
				console.log(evt.target.elements[i].selectedIndex);
				value = evt.target.elements[i].selectedIndex;
			}

			else if(evt.target.elements[i].type == "file"){
				console.log("El tipo es archivo");
				value = evt.target.elements[i].files[0];
			}

			else{
				console.log("value: "+evt.target.elements[i].value);
				value = evt.target.elements[i].value;
			}
			fd.append(name,value);
			console.log("\n");
		}
	}

	let xmlHttp = new XMLHttpRequest();
	console.log("Eviando peticion");
	xmlHttp.onreadystatechange = function(){
		console.log("Ready state changed");
		if(xmlHttp.status == 200 && xmlHttp.readyState == 4){
			console.log("Respuesta recibida");
			console.log(xmlHttp.responseText);
		}
	};

	xmlHttp.open("POST","http://localhost/QR_Directory/QR_Directory_API/api.php",true);

	xmlHttp.send(fd);
}