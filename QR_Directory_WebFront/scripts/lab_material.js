preloader = null;
(function(){
    startSearch();
}());

function startSearch(){
    document.querySelector(".result-section").innerHTML = "";
    preloader = document.querySelector("#loader_container");
    preloader.style.display = "block";
    let id_lab= getNavQuery("laboratorio");
    console.log(id_lab);
    getItems(id_lab);;
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
            let bi = null;
            try{
                console.log("Background div id: "+'#'+real_id+"-image");
                let img = document.querySelector('#'+real_id+"-image");
                style = img.currentStyle || window.getComputedStyle(img, false);
                bi = style.backgroundImage.slice(4, -1).replace(/"/g, "");
            }


            catch (exception){
                console.log("Error no se pudo eliminar");
            }
                let alertImgHTML = null;
                if (bi == null){
                    console.log("El archivo a eliminar no tiene imagen");
                }

                else{
                    console.log("EL archivo si tiene imagen");
                    alertImgHTML = '<img src="'+bi+'" width="200px" height="180px"/>';
                }
                Swal.fire(
                    {
                        title: '<p>¿Seguro que deseas eliminar <b>'+id.split("_")[0]+'</b>?<p/>',
                        html: alertImgHTML,
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

        else{
            console.log("Vamos a ver el mantenimiento de la pieza");
            window.location.replace("mantenimiento.html?item="+id.split("_")[0]);
        }
    }

    else{
        window.location.replace("edit.html?item="+id.split("_")[0]);
    }
}


function getItems(lab){
    let params = "?laboratorio="+lab;

    QRDirectoryAPI(API_URL+API_NAME,params,"GET",null,responseGetItem);
}

function responseGetItem(data){        

    console.log("Respuesta recibida");
    console.log(JSON.parse(data));

    var items = JSON.parse(data);
    container = document.querySelector(".result-section");
    container.innerHTML = "";
    if(items.error){
        console.log(items.error);
        Swal.fire({
          icon: 'error',
          title: 'Lo siento!',
          text: items.error,
        });
    }
    else{
        for(item in items){
            id = items[item].id;
            cantidad = items[item].cantidad;
            ficha_tecnica = items[item].ficha_tecnica;
            habilitadas = items[item].habilitadas;
            img = items[item].img;
            laboratorio = items[item].laboratorio;
            marca = items[item].marca;
            modelo = items[item].modelo;
            no_pieza = items[item].no_pieza;
            nombre = items[item].nombre;
            tipo_material = items[item].tipo_material;
            showQueryResults(container,nombre,marca,modelo,id,img);
        }
    }

    preloader.style.display = "none";
    actions = document.querySelectorAll(".actions");
    console.log(actions);
    actions.forEach( (ele) => ele.style.display = "none")
}