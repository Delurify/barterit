<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_id = $_POST['itemid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$barterto_electronicdevice = $_POST['electronicdevice'];
$barterto_vehicle = $_POST['vehicle'];
$barterto_furniture = $_POST['furniture'];
$barterto_bookstationery = $_POST['bookstationery'];
$barterto_homeappliance = $_POST['homeappliance'];
$barterto_fashioncosmetic = $_POST['fashioncosmetic'];
$barterto_videogameconsole = $_POST['videogameconsole'];
$barterto_forchildren = $_POST['forchildren'];
$barterto_musicalinstrument = $_POST['musicalinstrument'];
$barterto_sport = $_POST['sport'];
$barterto_foodnutrition = $_POST['foodnutrition'];
$barterto_other = $_POST['other'];

// converting 'true' or 'false' to 1 and 0
// This is for barterto columns
$barterto_electronicdevice = $barterto_electronicdevice === "true" ? "1" : "0";
$barterto_vehicle = $barterto_vehicle === "true" ? "1" : "0";
$barterto_furniture = $barterto_furniture === "true" ? "1" : "0";
$barterto_bookstationery = $barterto_bookstationery === "true" ? "1" : "0";
$barterto_homeappliance = $barterto_homeappliance === "true" ? "1" : "0";
$barterto_fashioncosmetic = $barterto_fashioncosmetic === "true" ? "1" : "0";
$barterto_videogameconsole = $barterto_videogameconsole === "true" ? "1" : "0";
$barterto_forchildren = $barterto_forchildren === "true" ? "1" : "0";
$barterto_musicalinstrument = $barterto_musicalinstrument === "true" ? "1" : "0";
$barterto_sport = $barterto_sport === "true" ? "1" : "0";
$barterto_foodnutrition = $barterto_foodnutrition === "true" ? "1" : "0";
$barterto_other = $barterto_other === "true" ? "1" : "0";


$sqlinsert = "UPDATE `tbl_items` SET `item_name` = '$item_name', `item_desc` = '$item_desc', `item_type` = '$item_type', `item_qty` = '$item_qty', `item_barterto_electronicdevice` = '$barterto_electronicdevice', `item_barterto_vehicle` = '$barterto_vehicle', `item_barterto_furniture` = '$barterto_furniture', `item_barterto_book&stationery` = '$barterto_bookstationery', `item_barterto_homeappliance` = '$barterto_homeappliance', `item_barterto_fashion&cosmetic` = '$barterto_fashioncosmetic', `item_barterto_videogame&console` = '$barterto_videogameconsole', `item_barterto_forchildren` = '$barterto_forchildren', `item_barterto_musicalinstrument` = '$barterto_musicalinstrument', `item_barterto_sport` = '$barterto_sport', `item_barterto_food&nutrition` = '$barterto_foodnutrition', `item_barterto_other` = '$barterto_other' WHERE `item_id` = '$item_id'";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>