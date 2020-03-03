<?php
    if(isset($_POST['username']) && isset($_POST['pswd']));
    $username = $_POST['username'];
    $pswd = $_POST['pswd'];
    $response = new StdClass();
    if($username == "Diego" && $pswd == "1234"){
        $response->error = false;
    }

    else{
        $response->error = true;
    }

    echo json_encode($response);
?>