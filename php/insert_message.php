<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$barterid = $_POST['barterid'];
$text = $_POST['text'];
$date = $_POST['date'];
$sentBy = $_POST['sentBy'];
$sentTo = $_POST['sentTo'];

$sqlinsert = "INSERT INTO `tbl_messages`(`barter_id`, `message_text`, `message_date`, `message_sentBy`, `message_sentTo`) VALUES ('$barterid','$text', '$date', '$sentBy', '$sentTo')";

if ($conn->query($sqlinsert) === TRUE) {
    if (isset($_POST['barter_userid'])) {
    }
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>