<?php
	$host = "localhost";
	$user = "root";
	$pswd = "1234";
	$db = "materiales";
	$con = mysqli_connect($host,$user,$pswd,$db);
	if(!$con){
		echo "Error";
	}

	$con->query("SET NAMES 'utf8'");
?>