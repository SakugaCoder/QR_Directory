<?php
    if(isset($_POST['username']) && isset($_POST['pswd']));
    $username = $_POST['username'];
    $pswd = $_POST['pswd'];
    if($username == "Diego" && $pswd == "1234"){
        echo "true";
    }

    else{
        echo "error";
    }
?>