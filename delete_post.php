<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$topic = $_POST['topic'];

    $sqlpost ="SELECT * FROM POST WHERE EMAIL = '$email'";
    $postresult = $conn->query($sqlpost);
    if ($postresult->num_rows > 0)
    {
    while ($row = $postresult->fetch_assoc())
    {
        $sqldelete = "DELETE FROM POST WHERE EMAIL = '$email' AND TOPIC='$topic'";
        $conn->query($sqldelete);
    
    }
    }
    $sqldeletecomment = "DELETE FROM COMMENT WHERE TOPIC = '$topic'";
        $conn->query($sqldeletecomment);
?>