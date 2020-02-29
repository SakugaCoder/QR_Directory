(function(){
    let material = getNavQuery();
    let boton_nuevo_mantenimiento = document.querySelector("#btnCrearCheckList");
    boton_nuevo_mantenimiento.setAttribute("href","new_support.html?item="+material);
}());