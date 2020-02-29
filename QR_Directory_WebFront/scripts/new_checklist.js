item = null;
let form_actividades = document.querySelector(".actividades");
(function(){
	window.onload = function() {
        item = this.getNavQuery();
        if(item){
            console.log("Si tenemos item");
            console.log(item);
            document.querySelector("#item_value").innerHTML = item;
        }
        else{
            window.location.replace("dashboard.html");
        }
	}
}());


function agregarActividad(evt){
    evt.preventDefault();
    console.log("Agregando actividad");
    let new_activity = ' <input type="text" name="act-0" id="act-0" placeholder="Descripción actividad"><br>';
    form_actividades.innerHTML += new_activity;
}