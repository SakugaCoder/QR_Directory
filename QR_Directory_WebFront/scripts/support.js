var item = null;
(function(){
	window.onload = function() {
        item = this.getNavQuery();
        if(item){
            console.log("Si tenemos item");
            console.log(item);
        }
	}
}());