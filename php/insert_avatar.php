<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die();
}

include_once("dbconnect.php");

$encoded_string = $_POST['image'];
$user_id = $_POST['user_id'];

$response = array('status' => 'success', 'data' => null);
$decoded_string = base64_decode($encoded_string);
$path = '../assets/avatars/' . $user_id  . '.png';
file_put_contents($path, $decoded_string);
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
header('Content-Type: application/json');
echo json_encode($sentArray);
}
?>