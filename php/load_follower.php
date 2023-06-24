<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if(isset($_POST['userid']) && isset($_POST['traderid'])){
    $userid = $_POST['userid'];
    $traderid = $_POST['traderid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE user_id = '$userid' AND trader_id = '$traderid'";
} else if(isset($_POST['traderid'])){
    $traderid = $_POST['traderid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE trader_id = '$traderid'";
} else{
    $userid = $_POST['userid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE user_id = '$userid'";
}


$result = $conn->query($sqlloadfollows);
if ($result->num_rows > 0) {
    $row_count = mysqli_num_rows($result);
	
    $response = array('status' => 'success', 'follow' => $row_count);
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