<?php
// If $_POST is not set, sends json response with status of failed and data of null
// Then terminate the script execution
// 感觉是看有没有data过来这个file，没有的话就不用做东西了
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
$userid = $_POST['userid'];
$sqllogin = "SELECT * FROM `tbl_users` WHERE user_id = '$userid'";


$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $userarray = array();
        $userarray['id'] = $row['user_id'];
        $userarray['name'] = $row['user_name'];
        $userarray['phone'] = $row['user_phone'];
        $userarray['hasavatar'] = $row['user_hasavatar'];
        $userarray['email'] = $row['user_email'];
        $userarray['password'] = "na";
        $userarray['otp'] = "na";
        $userarray['datereg'] = $row['user_datereg'];
        $userarray["credit"] = $row["user_credit"];

        $response = array('status' => 'success', 'data' => $userarray);
        sendJsonResponse($response);
    }
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