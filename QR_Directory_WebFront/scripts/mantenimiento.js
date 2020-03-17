let material = null;
let status_material = null;
(function(){
    validateLogin();
    material = getNavQuery("item");
    let boton_nuevo_mantenimiento = document.querySelector("#btnCrearCheckList");
    boton_nuevo_mantenimiento.setAttribute("href","new_support.html?item="+material);
    if(material != null){
        desplegarHojaMantenimiento(material);
        document.querySelector("#nombre_material").textContent = item;
    }
}());

function desplegarHojaMantenimiento(material){
    desplegarImgMaterial(material);
    desplegarEstadoMaterial(material);
    let params = "?hoja_mantenimiento=true&id_material="+material;
    console.log(params);
    QRDirectoryAPI(API_URL+API_NAME,params,"GET",null,respuestaDesplegarHojaMantenimiento);
}

function respuestaDesplegarHojaMantenimiento(respuesta){
    if(respuesta.hoja_mantenimiento > 0){
        console.log(respuesta);
        let contenedor_actividades = document.querySelector(".actividades-mantenimiento");
        contenedor_actividades.innerHTML = "";
        respuesta.Registros.forEach( function(registro){
            let fecha = registro.fecha;
            let realizo = registro.realizo;
            let revizo = registro.revizo;
            let comentarios = registro.comentarios;
            let actividades_html = "";
            let id_la = registro.id_lista_actividades_programadas;
            registro.actividades.forEach( function(actividad){
                let estado_actual = actividad.terminada;
                let nuevo_estado = estado_actual == 1 ? 0 : 1;
                let checked = null;
                if (estado_actual == 1){
                    checked = 'checked'
                }
                else{
                    checked =  ' ';
                }
                let actividad_html = '<tr>\
                <td>'+actividad.nombre_actividad+'</td>\
                <td><input id="checkbox-'+actividad.id_actividad+'" type="checkbox" onclick="cambioEstadoActividad('+actividad.id_actividad+','+nuevo_estado+');" '+checked+'></td>\
            </tr>';

                actividades_html += actividad_html;
            });

            let nueva_actividad = '<div class="actividad-mantenimiento">\
            <h1>Revizión dia <b>'+fecha+'</b></h1>\
            <label for="fecha_actividad-'+id_la+'">Fecha de lista</label>\
            <input name="fecha_actividad-'+id_la+'" id="fecha_actividad-'+id_la+'" type="text" disabled value="'+fecha+'">\
            <label for="revizo-'+id_la+'">Revizo</label>\
            <input name="revizo-'+id_la+'" id="revizo-'+id_la+'" type="text"  value="'+revizo+'">\
            <label for="realizo-'+id_la+'">Realizo</label>\
            <input name="realizo-'+id_la+'" id="realizo-'+id_la+'" type="text"  value="'+realizo+'">\
            <label for="comentarios-'+id_la+'">Comentarios</label>\
            <input name="comentarios-'+id_la+'" id="comentarios-'+id_la+'" type="text"  value="'+comentarios+'">\
            <h2>Actividades</h2>\
            <table>\
                <thead>\
                    <tr>\
                        <td>Nombre actividad</td>\
                        <td>Terminada</td>\
                    </tr>\
                </thead>\
                <tbody>\
                    '+actividades_html+'\
                </tbody>\
            </table>\
            <a href="javascript:void();" class="btnGuardarDatos" onclick="guardarDatosLista(event,'+id_la+');">Guardar datos</a>\
        </div>';
            contenedor_actividades.innerHTML += nueva_actividad;
        })
    }

    else{
        console.log("No cuenta con hoja de mantenimiento");
    }
}

function cambioEstadoActividad(id_actividad, nuevo_estado){
    let fd = new FormData();
    console.log(id_actividad+" => "+nuevo_estado);
    fd.append("id_actividad",id_actividad);
    fd.append("nuevo_estado_actividad",nuevo_estado);
    QRDirectoryAPI(API_URL+API_NAME,null,"POST",fd,function(response){
        console.log(response);
        if(response.error == false){
            alert("Estado cambiado con exito!");
            nn_estado = nuevo_estado == 1 ? 0 : 1;
            document.querySelector("#checkbox-"+id_actividad).setAttribute("onclick","cambioEstadoActividad("+id_actividad+","+nn_estado+")");
        }
    
        else{
            alert("Error al cambiar de estado");
            desplegarHojaMantenimiento(material);
        }
    });
}

function guardarDatosLista(evt,id_lista_actividades_programadas){
    evt.preventDefault();
    let fd = new FormData();
    fd.append("id_lista_actividades_programadas",id_lista_actividades_programadas);
    fd.append("quien_realizo",document.querySelector("#realizo-"+id_lista_actividades_programadas).value);
    fd.append("quien_revizo",document.querySelector("#revizo-"+id_lista_actividades_programadas).value);
    fd.append("comentarios",document.querySelector("#comentarios-"+id_lista_actividades_programadas).value);
    QRDirectoryAPI(API_URL+API_NAME,null,"POST",fd,respuestaGuardarDatosLista);
    //console.log(document.querySelector("#fecha_actividad-"+id_lista_actividades_programadas).value);
}

function respuestaGuardarDatosLista(response){
    console.log(response);
    if(response.error == false){
        alert("Lista actualizada");
        desplegarHojaMantenimiento(material);
    }

    else{
        alert("Error al actualizar datos");
        desplegarHojaMantenimiento(material);
    }
}

function desplegarEstadoMaterial(item){
    let params = "?img_material=true&id_material="+item;
    QRDirectoryAPI(API_URL+API_NAME,params,"GET",null,respuestaDesplegarEstadoMaterial);
    
}

function respuestaDesplegarEstadoMaterial(response){
    if(response.error == false && response.img != null){
        status_material = response.estado;
        establecerEstadoActual();
    }
}

function establecerEstadoActual(){
    nuevo_estado = status_material == 1 ? 0 : 1;
    status_material == 1 ? document.querySelector("#estadoMaterial").setAttribute("checked",true) : null;
    document.querySelector("#estadoMaterial").setAttribute("onchange","cambiarEstadoMaterial('"+material+"',"+nuevo_estado+")");
    
}

function cambiarEstadoMaterial(id_material,nuevo_estado){
    fd = new FormData();
    fd.append("cambiar_estado_material",true);
    fd.append("id_material",id_material);
    fd.append("nuevo_estado",nuevo_estado);
    QRDirectoryAPI(API_URL+API_NAME,null,"POST",fd,respuestaCambiarEstadoMaterial);
}

function respuestaCambiarEstadoMaterial(response){
    if(!response.error){
        alert("Estado cambiado");
        window.location.reload();
    }

    else{
        alert("Error al cambiar estado");
    }
}
