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
$image = $_POST['image'];
$item_lat = $_POST['lat'];
$item_long = $_POST['long'];
$item_state = $_POST['state'];
$item_locality = $_POST['locality'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`, `item_name`, `item_desc`, `item_type`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$user_id','$item_name ','$item_desc','$item_type','$item_qty', '$item_lat', '$item_long', '$item_state', '$item_locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../assets/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);
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