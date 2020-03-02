item = null;
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

function createSchedule(evt){
    evt.preventDefault();
    console.log("Creando shedule");
    window.location.replace("new_checklist.html?item="+item);
}

function regresar(evt){
    evt.preventDefault();
    window.location.replace("mantenimiento.html?item="+item);
}