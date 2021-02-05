<?php
$servername ="localhost";
$username   ="sopmycom_gardeneousadmin";
$password   = "gttkbgqe71nd";
$dbname     = "sopmycom_gardeneous";

$conn = new mysqli($servername,$username , $password,$dbname);
if ($conn->connect_error){
    die ("Connection failed:".$conn->connect_error);
}

?>