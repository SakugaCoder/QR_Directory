<?php
	$host = "localhost";
	$user = "root";
	$pswd = "";
	$db = "materiales";
	$con = mysqli_connect($host,$user,$pswd,$db);
	if(!$con){
		echo "Error";
	}
?>