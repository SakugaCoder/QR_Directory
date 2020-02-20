var item = null;
(function(){
	window.onload = function() {
        item = this.getNavQuery();
        if(item){
            console.log("Si tenemos item");
            console.log(item);
            document.querySelector("#it").innerHTML = item;
                        
            //Getting all sheets for this material
            
            let req_support = new XMLHttpRequest();
            let res_content = document.querySelector(".sheets");
            req_support.onload = function(){
                let response = JSON.parse(req_support.responseText);
                console.log(response);
                if(!response.error){
                    console.log("Vamos a imprimir");
                    for(sheet in response){
                        console.log(response[sheet].id);
                        row = "";
                        row += '<div class="sheet">\
                        <h2>Ficha No: <b>'+response[sheet].id+'</b></h2>\
                        <p>Fecha inicio: <b>'+response[sheet].fecha_inicio+'</b></p>\
                        <p>Fecha terminó: <b>'+response[sheet].fecha_termino+'</b></p>\
                        <p>Numero actividades: <b>'+response[sheet].n_activities+'</b></p><div class="activities">';
                        for(activity in response[sheet].activities){
                            estado = 1;
                            checked = "";
                            color = "crimson";
                            if(response[sheet].activities[activity].terminada == 1){
                                checked = "checked"
                                estado = 0;
                                color = "forestgreen";
                            }
                            row += '<div class="activity" style="background:'+color+'">\
                                    <p>ID: <b>'+response[sheet].activities[activity].id+'</b></p>\
                                    <p>Descripción: <b>'+response[sheet].activities[activity].descripcion+'</b></p>\
                                    <p>Fecha inicio: <b>'+response[sheet].activities[activity].fecha_inicio+'/b></p>\
                                    <p>Fecha terminó: <b>'+response[sheet].activities[activity].fecha_termino+'</b></p>\
                                    <p>Terminada <input type="checkbox" id="myCheck" onclick="cambiarEstado('+"'"+response[sheet].activities[activity].id+"'"+','+estado+') "'+checked+'></p>\
                                </div>'
                        }
                        row += '</div></div>';
                        res_content.innerHTML+= row;
                    }
                }

                else{
                    res_content.innerHTML = "<center>No existen registros :(</center>";
                }
            }

            req_support.open("GET","http://localhost/QR_Directory/QR_Directory_API/api.php?support_sheet=1&material="+item,true);
            req_support.send();
            
        }
	}
}());


function cambiarEstado(id,to){
    let fd_cs = new FormData();
    fd_cs.append("change_act_status",1);
    fd_cs.append("id",id);
    fd_cs.append("to",to);
    console.log("id: "+id+" to:"+to);
    let res_change_sta = new XMLHttpRequest();
    res_change_sta.onload = function(){
        console.log(res_change_sta.responseText);
        if(res_change_sta.responseText == "ok"){
            window.location.reload();
        }
    };

    res_change_sta.open("POST","http://localhost/QR_Directory/QR_Directory_API/api.php",true);
    res_change_sta.send(fd_cs);
}