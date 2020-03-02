item = null;
(function(){
	window.onload = function() {
        item = this.getNavQuery();
        if(item){
            console.log("Si tenemos item");
            console.log(item);
            document.querySelector("#item_value").innerHTML = item;
            desplegarListasDeActividades();
        }
        else{
            window.location.replace("dashboard.html");
        }
	}
}());


function desplegarListasDeActividades(){
    let params="?lista_actividades=true";
    QRDirectoryAPI(API_URL+ API_NAME,params,"GET",null,respuestaDesplegarListasDeActividades);
}

function respuestaDesplegarListasDeActividades(response){
    console.log(response);
    if(response.error == false){
        let activity_list_container = document.querySelector(".activity-lists");
        response.Registros.forEach( function(lista){
            let nombre_lista = lista.nombre_lista;
            let actividades = "";
            let id_lista = lista.id;
            
            lista.actividades.forEach( function(actividad){
                actividades += "<li>"+actividad+"</li>";
            });

            let lista_html = '<div class="activity-list">\
            <input type="radio" name="as" id="al-'+id_lista+'">\
            <label for="al-'+id_lista+'">\
                <div class="activity-content al-'+id_lista+'">\
                    <h2 class="activity-list-name">'+nombre_lista+'</h2>\
                    <ul class="activities">\
                    '+actividades+'\
                    </ul>\
                </div>\
            </label>\
        </div>';

            activity_list_container.innerHTML += lista_html;
        });
    }

    else{
        alert("Error al desplegar listas");
    }
}
function createSchedule(evt){
    evt.preventDefault();
    console.log("Creando shedule");
    window.location.replace("new_checklist.html?item="+item);
}

function regresar(evt){
    evt.preventDefault();
    window.location.replace("mantenimiento.html?item="+item);
} 