<?php
error_reporting(0);
include_once ("dbconnect.php");
$sql = "SELECT * FROM GARDEN";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["garden"] = array();
    while ($row = $result->fetch_assoc())
    {
        $gardenlist = array();
        $gardenlist["image"] = $row["IMAGE"];
        $gardenlist["id"] = $row["ID"];
        $gardenlist["name"] = $row["NAME"];
        $gardenlist["price"] = $row["PRICE"];
        $gardenlist["quantity"] = $row["QUANTITY"];
        $gardenlist["rating"] = $row["RATING"];
        array_push($response["garden"], $gardenlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>