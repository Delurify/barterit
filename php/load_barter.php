<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");



$userid = $_POST['userid'];
$sqlloadusers = "SELECT * FROM `tbl_barters` WHERE barter_giveuserid  = '$userid' OR barter_takeuserid = '$userid'";


$result = $conn->query($sqlloadusers);
if ($result->num_rows > 0) {
    $barters["barters"] = array();
    $row_count = mysqli_num_rows($result);

    while ($row = $result->fetch_assoc()) {
        $barterarray = array();
        $barterarray['barterid'] = $row['barter_id'];
        $barterarray['offerid'] = $row['offer_id'];
        $barterarray['giveitemid'] = $row['barter_giveitemid'];
        $barterarray['takeitemid'] = $row['barter_takeitemid'];
        $barterarray['giveuserid'] = $row['barter_giveuserid'];
        $barterarray['takeuserid'] = $row['barter_takeuserid'];

        array_push($barters["barters"], $barterarray);
    }
    $response = array('status' => 'success', 'data' => $barters, 'posts' => $row_count);
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