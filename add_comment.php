<?php
error_reporting(0);
include_once("dbconnect.php");


$plantname=$_POST['plantname'];
$plantid=$_POST['plantid'];
$plantimage=$_POST['plantimage'];
$email = $_POST['email'];
$name = $_POST['name'];
$review = $_POST['review'];
$rating = $_POST['rating'];


$sqlregister = "INSERT INTO REVIEW(PLANTNAME,PLANTID,PLANTIMAGE,EMAIL, NAME, REVIEW, RATING) VALUES('$plantname','$plantid','$plantimage','$email','$name','$review','$rating')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>