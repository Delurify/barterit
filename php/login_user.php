<?php
// If $_POST is not set, sends json response with status of failed and data of null
// Then terminate the script execution
// 感觉是看有没有data过来这个file，没有的话就不用做东西了
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// fetch 拿来的$_POST file然后assign email 和 password
// 不过password是encrypted的
$email = $_POST['email'];
$pass = sha1($_POST['user_password']);

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
$sqllogin = "SELECT * FROM `tbl_users` WHERE user_email = '$email' AND user_password =++ '$pass'";
$result = $conn->query($sqllogin);

if($result -> num_rows > 0){
    while($row = $result->fetch_assoc()){
        $usearray = array();
        $usearray['id'] = $row['user_id'];
        $userarray['email'] = $row['user_email'];
		$userarray['name'] = $row['user_name'];
		$userarray['phone'] = $row['user_phone'];
		$userarray['password'] = $_POST['user_password'];
		$userarray['otp'] = $row['user_otp'];
		$userarray['datereg'] = $row['user_datereg'];
		$response = array('status' => 'success', 'data' => $userarray);
		sendJsonResponse($response);
    }
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