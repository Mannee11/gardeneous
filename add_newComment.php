<?php
include_once("dbconnect.php");

$topic = $_POST['topic'];
$caption = $_POST['caption'];
$useremail = $_POST['useremail'];
$username = $_POST['username'];


$sqlregister = "INSERT INTO COMMENT(TOPIC,CAPTION,USEREMAIL,USERNAME) VALUES('$topic','$caption','$useremail','$username')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>