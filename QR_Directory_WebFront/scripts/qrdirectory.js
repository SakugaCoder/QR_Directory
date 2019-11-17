(function(){
    console.log("Logged value:");
    console.log(localStorage.getItem("logged"));
}());

function closeSession(){
    localStorage.setItem("logged",false);
    window.location.replace("login.html");
}

function logIng(form_data){
    var XMLHttp = new XMLHttpRequest();
    XMLHttp.onreadystatechange = function(){
                if(this.readyState == 4 && this.status == 200){
                    console.log("Respuesta recibida");
                    console.log(this.responseText);
                    if(this.responseText == "true"){
                        alert("Vas a ser redirigido");
                        localStorage.setItem("logged",true);
                        window.location.replace("dashboard.html");
                    }

                    else if(this.responseText == "false"){
                        localStorage.setItem("logged",false);
                    }

                    else{
                        document.querySelector(".error-container").innerHTML = "<p>Error. Usuario o contraseña incorrectos</p>";
                    }
                }
            };

            XMLHttp.open("POST","http://localhost/QR_Directory/QR_Directory_API/login.php",true);
            XMLHttp.send(form_data);
}

function getItems(search_value,lab,kind,preloader){
    var fd = new FormData();
    console.log("Search value: "+search_value);
    console.log("Lab: "+lab);
    console.log("Kind: "+kind);
    var XMLHttp = new XMLHttpRequest();
    XMLHttp.onreadystatechange = function() {
        console.log("State ready change");
        if(this.readyState == 4 && this.status == 200){
            console.log("Respuesta recibida");
            console.log(JSON.parse(this.responseText));
            var items = JSON.parse(this.responseText);
            container = document.querySelector(".result-section");
            container.innerHTML = "";
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
                    id = items[item].id;
                    cantidad = items[item].cantidad;
                    ficha_tecnica = items[item].ficha_tecnica;
                    habilitadas = items[item].habilitadas;
                    img = items[item].img;
                    laboratorio = items[item].laboratorio;
                    marca = items[item].marca;
                    modelo = items[item].modelo;
                    no_pieza = items[item].no_pieza;
                    nombre = items[item].nombre;
                    tipo_material = items[item].tipo_material;
                    showQueryResults(container,nombre,marca,modelo,id,img);
                }
            }

            preloader.style.display = "none";
        }
    };

    XMLHttp.open("GET","http://localhost/QR_Directory/QR_Directory_API/api.php?search_value="+search_value+"&lab="+lab+"&kind="+kind,true);
    XMLHttp.send();
}

function modifyItem(){

}

function validateLogin(area){
    var logged = localStorage.getItem("logged");

    if(area == "login"){
        console.log("Login verify");
        if(logged == "true"){
            alert("Ya estas logeado vas a ser redirigido");
            window.location.replace("dashboard.html");
        }

        else if(logged = "false"){
            console.log("No has iniciado sesion en login");
        }
    }

    else if(area == "admin"){
        console.log("Admin verify");
        if( logged == "false"){
            alert("No estas logeado vas a ser redirigido");
            window.location.replace("login.html");
        }

        else if( logged == "true"){
            console.log("Ya has iniciado sesion");
        }
    }

}

function showQueryResults(contaier,descripcion,marca,modelo,id,img){
    console.log("Showing results");
        contaier.innerHTML += "<div class='item-container' style='margin-top:30px'>\
                <div class='image' id='"+id+"-image'></div>\
                    <div class='item-data'>\
                        <div class='general-data'>\
                            <span><p class='description'>"+descripcion+"</p><p class='brand'>"+marca+"</p> <p class='model'>"+modelo+"</p></span>\
                        </div>\
                        <div class='actions'>\
                            <div class='edit-option'>\
                                <img src='./assets/icons8-edit-80.png' alt='Icono editar' width='20px' height='20px' id='"+id+"_modify' onclick='adminAction(event)'>\
                            </div>\
                            <div class='generate-qr-option'>\
                                <img src='./assets/icons8-qr-code-96.png' alt='Icono generar codigo qr' width='20px' height='20px' id='"+id+"_gqr' onclick='adminAction(event)'>\
                            </div>\
                            <div class='delete-option'>\
                                <img src='./assets/icons8-delete-80.png' alt='Icono borrar' width='20px' height='20px' id='"+id+"_delete' onclick='adminAction(event)'>\
                            </div>\
                        </div>\
                    </div>\
                </div>";
    var item_image = document.querySelector("#"+id+"-image");
    id = id.split("-")[0] + "-"+id.split("-")[2];
    console.log("new id"+id);   
    item_image.style.background = "url('http://localhost/QR_Directory/QR_Directory_API/"+img+"')";
    item_image.style.backgroundSize = "70% 70%";
    item_image.style.backgroundPosition = "center",
    item_image.style.backgroundRepeat = "no-repeat";
}