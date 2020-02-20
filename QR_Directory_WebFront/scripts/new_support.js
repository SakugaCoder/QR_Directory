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