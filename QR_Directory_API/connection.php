<?php
	$external_host = "192.168.1.77";
	$local = "localhost";
	$host = $local;
	$user = "qruser";
	$pswd = "parasite20";
	$db = "materiales";
	$con = mysqli_connect($host,$user,$pswd,$db);
	if(!$con){
		echo "Error";
	}
	else{
		//echo "Todo bien";
	}

	$con->query("SET NAMES 'utf8'");
?>
