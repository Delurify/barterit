<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$barterid = $_POST['barterid'];

// Construct sql query
$sqlloadusers = "SELECT * FROM tbl_messages WHERE barter_id = '$barterid'";


$result = $conn->query($sqlloadusers);
if ($result->num_rows > 0) {
    $messages["messages"] = array();
    $row_count = mysqli_num_rows($result);

    while ($row = $result->fetch_assoc()) {
        $messagelist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_type'] = $row['item_type'];
        array_push($items["items"], $itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'posts' => $row_count);
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