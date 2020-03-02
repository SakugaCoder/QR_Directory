API_URL = "http://localhost/QR_Directory/QR_Directory_API/";
API_NAME = "api.php";
LOGIN_NAME = "login.php";

(function(){
    //console.log("Logged value:");
    //console.log(localStorage.getItem("logged"));
}());

function QRDirectoryAPI(url, params = null, method, _data, callback){

    let XMLHttp = new XMLHttpRequest();
    XMLHttp.onreadystatechange = function(){
        if(XMLHttp.status == 200 && XMLHttp.readyState == 4){
            callback(JSON.parse(XMLHttp.responseText));
        }
    };

    params != null ? XMLHttp.open(method,url + params, true) : XMLHttp.open(method,url,true);
    _data != null ? XMLHttp.send(_data) : XMLHttp.send();
}

function closeSession(){
    localStorage.setItem("logged",false);
    window.location.replace("login.html");
}

function logIn(fd){
    QRDirectoryAPI(API_URL + LOGIN_NAME , null, "POST", fd, responseLogIn);
}

function responseLogIn(response){
    if(response == "true"){
        alert("Vas a ser redirigido");
        localStorage.setItem("logged",true);
        window.location.replace("dashboard.html");
    }

    else if(response == "false"){
        localStorage.setItem("logged",false);
    }

    else{
        document.querySelector(".error-container").innerHTML = "<p>Error. Usuario o contraseña incorrectos</p>";
    }
}


function showQueryResults(contaier,descripcion,marca,modelo,id,img){
    //console.log("Showing results");
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
                        <div class='support-option'>\
                            <img src='./assets/icons8-data-sheet-40.png' alt='Icono mantenimiento' width='20px' height='20px' id='"+id+"_support' onclick='adminAction(event)'>\
                        </div>\
                    </div>\
                </div>\
            </div>";           
    
    let item_image = null;
    try{
        let item_image = document.querySelector("#"+id+"-image");
        id = id.split("-")[0] + "-"+id.split("-")[2];
        //console.log("new id"+id);   
        item_image.style.background = "url('http://localhost/QR_Directory/QR_Directory_API/"+img+"')";
        item_image.style.backgroundSize = "70% 70%";
        item_image.style.backgroundPosition = "center",
        item_image.style.backgroundRepeat = "no-repeat";
    }

    catch(exception){
        //console.log("Error loading image");
    }
}

function deleteItem(item){
    //console.log("Borrando archivo");
    let fd = new FormData();
    fd.append("item",item);
    QRDirectoryAPI(API_URL + API_NAME,null,"DELETE",fd,responseDeleteItem);
}

function responseDeleteItem(response){
    //console.log("respuesta recibida");
    //console.log(response);
    let res = JSON.parse(response);
    if(res.error){
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: res.error,
          });
    }
    else{


        Swal.fire({
            icon: 'success',
            title: 'Acción completada correctamente',
            text: res.message,
            footer: res.item_deleted
          }).then( (accepted) => {
              if(accepted){
                document.querySelector(".search-bar img").click()
              }
          });
    }
}

function getNavQuery(param="item"){
    args = location.search.substr(1);
    //console.log("Args length:"+args.length);
    //console.log("Longitud del parametro: "+param.length);
    if(args.length > 0){
        console.log(args.substr(0,param.length));
        if(args.substr(0,param.length) == param){
            if( (args.substr(param.length)).split("=")[1] != ""){
                item = args.substr(param.length)
                item = item.split("=")[1];
                console.log(item);
                //displaySupportSheets(item);
                return item;
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
        return null;
    }
}

function validateLogin(area){
    var logged = localStorage.getItem("logged");
    if(logged){
        if(area == "login"){
            //console.log("Login verify");
            if(logged == "true"){
                alert("Ya estas logeado vas a ser redirigido");
                window.location.replace("dashboard.html");
            }
    
            else if(logged = "false"){
                console.log("No has iniciado sesion en login");
            }
        }
    
        else if(area == "admin"){
            //console.log("Admin verify");
            if( logged == "false"){
                alert("No estas logeado vas a ser redirigido");
                window.location.replace("login.html");
            }
    
            else if( logged == "true"){
                console.log("Ya has iniciado sesion");
            }
        }
    }
    else if(area == "admin"){
        alert("Lo siento no has hecho nada :(");
        window.location.replace("login.html");
    }
}