var item = null;

var calendario = null;
var revizion_counter = 0;

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
            <input type="radio" name="as" class="lista" id="al-'+id_lista+'">\
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


document.addEventListener('DOMContentLoaded', function() {
  var cal = document.getElementById('calendario');

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
    select: function(arg) {
    console.log(arg);
      revizion_counter++;
      var title = "Revizión #"+revizion_counter;
      if (title) {
        calendario.addEvent({
          title: title,
          start: arg.start,
          end: arg.end,
          allDay: arg.allDay
        })
      }
      calendario.unselect()
    },
    editable: true,
    eventLimit: true, // allow "more" link when too many events
    
  });

  calendario.render();
  console.log(moment().toDate());
});

function crearCheckList(eve){
    eve.preventDefault();
    let fechas_actividades = [];
    let id_lista = null;
    let anio = moment().year();
    calendario.getEvents().forEach( function(evento) {
        let inicio = (evento.start).toJSON();
        let titulo = evento.title;
        let fecha = (inicio.split("T")) [0];
        let anio = (fecha.split("-"))[0];
        let mes = (fecha.split("-"))[1];
        let dia = (fecha.split("-"))[2];
        if(fechas_actividades.indexOf(fecha) == -1){
            fechas_actividades.push(fecha);
        }
    });

    
    let listas = document.querySelectorAll(".lista");
    listas.forEach( function(lista){
        if(lista.checked == true){
            id_lista = ((lista.getAttribute("id")).split("-"))[1];
        }
    });


    if(fechas_actividades.lenght == 0 || id_lista == null){
        alert("Error. Faltan elementos para crear la lista");
    }

    else{
        let fd = new FormData();
        fd.append("anio",anio);
        fd.append("id_material",item);
        fd.append("id_lista_actividades",id_lista);
        fd.append("lista_fechas",fechas_actividades.join(","));
        console.log(fd);
        QRDirectoryAPI(API_URL+API_NAME,null,"POST",fd,respuestaCrearCheckList);
    }

    
    console.log(fechas_actividades);
    console.log("ID lista: "+id_lista);

}

function respuestaCrearCheckList(response){
    if(response.error == false){
        alert("Lista Creada");
        regresar(event);
    }

    else{
        alert("Error al crear lista");
    }
}
function borrarActividades(){
    calendario.removeAllEvents();
}