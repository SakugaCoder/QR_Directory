item = null;
let form_actividades = document.querySelector(".actividades");
(function(){

}());


function agregarActividad(evt){
    evt.preventDefault();
    console.log("Agregando actividad");
    let new_activity = document.createElement("INPUT");
    new_activity.setAttribute("type","text");
    new_activity.setAttribute("class","activity");
    new_activity.setAttribute("placeholder","Descripción actividad");
    //' <input type="text" name="act-0" id="act-0" placeholder="Descripción actividad"><br>';
    form_actividades.appendChild(new_activity);
}

function crearListaActividades(evt){
    evt.preventDefault();
    let nombre_lista = document.querySelector("#nombre-lista").value;
    let actividades = document.querySelectorAll(".activity");
    let array_lista_actividades = new Array();
    actividades.forEach( (elemento) => array_lista_actividades.push(elemento.value));
    let lista_actividades = array_lista_actividades.join(",");
    console.log("Nombre lista actividades: "+nombre_lista+"\nLista actividades: "+lista_actividades);
    if(lista_actividades.length > 0 && nombre_lista.length > 0){
        let fd = new FormData();
        fd.append("lista_actividades",lista_actividades);
        fd.append("nombre_lista_actividades",nombre_lista);
        QRDirectoryAPI(API_URL+API_NAME,null,"POST",fd,respuestaCrearListaActividades);
    }
}

function respuestaCrearListaActividades(respuesta){
    if(respuesta.error == false){
        alert("Lista creada");
    }

    else{
        alert("Error al crear lista");
    }
}

function regresar(){
    window.location.replace("dashboard.html");
}