<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['date'])) {
    $barterid = $_POST['barterid'];
    $sentBy = $_POST['sentBy'];
    $date = $_POST['date'];

    $date = date('Y-m-d H:i:s', strtotime($date) - 5);

    $sqlloadusers = "SELECT * FROM tbl_messages WHERE barter_id = '$barterid' AND message_sentBy = '$sentBy' AND message_date > '$date'";

} else {
    $barterid = $_POST['barterid'];

    // Construct sql query
    $sqlloadusers = "SELECT * FROM tbl_messages WHERE barter_id = '$barterid'";

}



$result = $conn->query($sqlloadusers);
if ($result->num_rows > 0) {
    $messages["messages"] = array();

    while ($row = $result->fetch_assoc()) {
        $messagelist = array();
        $messagelist['barterid'] = $row['barter_id'];
        $messagelist['text'] = $row['message_text'];
        $messagelist['date'] = $row['message_date'];
        $messagelist['sentBy'] = $row['message_sentBy'];
        $messagelist['sentTo'] = $row['message_sentTo'];
        array_push($messages["messages"], $messagelist);
    }
    $response = array('status' => 'success', 'data' => $messages);
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