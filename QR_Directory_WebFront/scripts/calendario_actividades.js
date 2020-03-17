var item;
var calendario;
(function(){
    item = getNavQuery();
    if(item != null){
        desplegarHojaMantenimiento(item);
        desplegarImgMaterial(item);
        document.querySelector("#nombre_material").textContent = item;
    }
}());

function desplegarHojaMantenimiento(material){
    let params = "?hoja_mantenimiento=true&id_material="+material;
    console.log(params);
    QRDirectoryAPI(API_URL+API_NAME,params,"GET",null,respuestaDesplegarHojaMantenimiento);
}

function respuestaDesplegarHojaMantenimiento(respuesta){
    if(respuesta.hoja_mantenimiento > 0){
        console.log(respuesta);
        let actividades = [];
        respuesta.Registros.forEach( function(registro){
            let fecha = registro.fecha;
            let realizo = registro.realizo;
            let revizo = registro.revizo;
            let comentarios = registro.comentarios;
            let id_la = registro.id_lista_actividades_programadas;
            registro.actividades.forEach( function(actividad){
                let nombre_actividad = actividad.nombre_actividad;
                let estado_actual = actividad.terminada;
                let color = estado_actual == 1 ? "#2ea42e" : "#cd3939";
                actividades.push({
                    title: nombre_actividad,
                    start: fecha,
                    color: color
                });
            });

        });
        cal = document.getElementById('calendario');
    
        calendario = new FullCalendar.Calendar(cal, {
            locale: "es",
            plugins: [ 'interaction', 'dayGrid', 'timeGrid' ],
            header: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            defaultDate: moment().toDate(),
            navLinks: true, // can click day/week names to navigate views
            selectable: true,
            selectMirror: true,
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            events: actividades,
            
        });
        
        calendario.render();
        console.log(moment().toDate());
    }

    else{
        console.log("No cuenta con hoja de mantenimiento");
    }
}