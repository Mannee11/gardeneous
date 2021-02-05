<?php
include_once("dbconnect.php");
$email=$_POST['email'];
$name=$_POST['name'];
$image = $_POST['image'];
$topic = $_POST['topic'];
$tips = $_POST['tips'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/gardenimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0){
    $sqlregister = "INSERT INTO POST(EMAIL,NAME,IMAGE,TOPIC,TIPS) VALUES('$email','$name','$image','$topic','$tips')";

    if ($conn->query($sqlregister) === TRUE){
    echo "success";
    }else{
    echo "failed";
}
}else{
    echo "failed";
}

?>