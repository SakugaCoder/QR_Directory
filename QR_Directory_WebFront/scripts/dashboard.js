(function(){
    validateLogin("admin");

    document.querySelectorAll(".actions img").forEach( (item) => {
        item.addEventListener('click',evtList);
    });
    /*
    var btn_search = document.querySelector(".search-bar img");
    btn_search.addEventListener("click", startSearch());
    */
}());

function startSearch(evt){
    evt.preventDefault();
    let search_value = document.querySelector("#search_value");
    let lab = document.querySelector("#lab");
    let kind = document.querySelector("#kind");
    console.log("Search value: "+search_value.value);
    console.log("Lab: ",lab.options[lab.selectedIndex].innerHTML);
    console.log("kind: "+kind.options[kind.selectedIndex].innerHTML);
    let preloader = document.querySelector("#loader_container");
    preloader.style.display = "block";
    getItems(search_value.value,lab.selectedIndex,kind.selectedIndex,preloader);
}

function pe(evt){
    console.log("hola");
    evt.preventDefault();
}

function adminAction(evt){
    var id = evt.target.id;
    let real_id = id.split('_')[0];
    var option = id.split('_')[1];
    console.log(id);
    console.log(option);
    if(option != "modify"){

        if(option === "delete"){
            let img_name = (id.split("_")[0]).split("-")[0] + "-" + (id.split("_")[0]).split("-")[2];
            console.log("Background div id: "+'#'+real_id+"-image");
            let img = document.querySelector('#'+real_id+"-image");
            style = img.currentStyle || window.getComputedStyle(img, false);
            let bi = style.backgroundImage.slice(4, -1).replace(/"/g, "");
            Swal.fire(
                {
                    title: '<p>¿Seguro que deseas eliminar <b>'+id.split("_")[0]+'</b>?<p/>',
                    html: '<img src="'+bi+'" width="200px" height="180px"/>',
                    showCancelButton: true,
                    confirmButtonText: 'Cancelar',
                    cancelButtonText: 'Si, eliminar',
                    cancelButtonColor: '#d33',
                    confirmButtonColor: '#3085d6'
                }
            ).then( (accepted) => {
                if(!accepted.value){
                    deleteItem(id.split("_")[0]);
                    console.log("Item deleted");
                }
                else{
                    console.log("no deleted");
                }
            });
        }

        else if(option == "gqr"){
            Swal.fire(
                {
                    title: '<p>Deseas descargar el codigo QR<p/>',
                    html: '<div id="qrcode"></div>',
                    showCancelButton: true,
                    confirmButtonText: 'Descargar',
                    cancelButtonText: 'Cancelar',
                    cancelButtonColor: '#d33',
                    confirmButtonColor: '#3085d6'
                }
            ).then( (download) => {
                if(download.value){
                    var canvas = document.querySelector("#qrcode canvas");
                    //var img    = canvas.toDataURL("image/png",'image/octet-stream');
                    //document.write(img);
                    let img_name = id.split("_")[0];
                    ReImg.fromCanvas(canvas).downloadPng(img_name+"_QR_Code.png");
                    console.log("Descargando archivo");
                }

                else{
                    console.log("Cerrando ventana");
                }
            });
            document.querySelector(".swal2-title").style.fontFamily = "Open Sans";
            document.querySelector(".swal2-confirm").style.fontFamily = "Open Sans";
            document.querySelector(".swal2-cancel").style.fontFamily = "Open Sans";
            $('#qrcode').qrcode({width: 150, height: 150, text: id.split('_')[0]});
        }
    }

    else{
        window.location.replace("edit.html?item="+id.split("_")[0]);
    }
}