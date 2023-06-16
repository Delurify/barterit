<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$image_string = $_POST['imagelist'];
$item_imagecount = $_POST['imagecount'];
$item_lat = $_POST['lat'];
$item_long = $_POST['long'];
$item_state = $_POST['state'];
$item_locality = $_POST['locality'];
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


$sqlinsert = "INSERT INTO `tbl_items`(`user_id`, `item_name`, `item_desc`, `item_type`, `item_imagecount`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_barterto_electronicdevice`, `item_barterto_vehicle`, `item_barterto_furniture`, `item_barterto_book&stationery`, `item_barterto_homeappliance`, `item_barterto_fashion&cosmetic`, `item_barterto_videogame&console`, `item_barterto_forchildren`, `item_barterto_musicalinstrument`, `item_barterto_sport`, `item_barterto_food&nutrition`, `item_barterto_other`) VALUES ('$user_id','$item_name ','$item_desc','$item_type', '$item_imagecount','$item_qty', '$item_lat', '$item_long', '$item_state', '$item_locality', '$barterto_electronicdevice', '$barterto_vehicle', '$barterto_furniture', '$barterto_bookstationery', '$barterto_homeappliance', '$barterto_fashioncosmetic', '$barterto_videogameconsole', '$barterto_forchildren', '$barterto_musicalinstrument', '$barterto_sport', '$barterto_foodnutrition', '$barterto_other')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);

	// remove unecessary characters from the string
	$image_string = str_replace(array("[", "]", " "), "", $image_string);

	// seperate the elements in string and assign them into array
	$image_list = explode(",",$image_string);

	// decode and save each image into the server
	$int = 1;
	foreach($image_list as $key){
		$decoded_string = base64_decode($key);
		$path = '../assets/items/'.$filename.'-'.$int.'.png';
		file_put_contents($path, $decoded_string);
		$int++;
	}
	
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