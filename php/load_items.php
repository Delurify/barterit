<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


if(isset($_POST['userid'])){
    $userid = $_POST['userid'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
}else if(isset($_POST['itemid'])){
    $itemid = $_POST['itemid'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_id = '$itemid'";
}else if(isset($_POST['favorite_userid'])){
    $userid = $_POST['favorite_userid'];
    $sqlloaditems = "SELECT * FROM `tbl_items` INNER JOIN `tbl_favorites` ON `tbl_favorites`.`item_id` = `tbl_items`.`item_id` WHERE `tbl_favorites`.`user_id` = '$userid'";
} else{
    $offset = $_POST['offset'];
    $limit = $_POST['limit'];
    $sqlloaditems = "SELECT * FROM `tbl_items` LIMIT $limit OFFSET $offset";
}

$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $items["items"] = array();
    $row_count = mysqli_num_rows($result);
	
while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_imagecount'] = $row['item_imagecount'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_qty'] = $row['item_qty'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_datereg'] = $row['item_datereg'];
        $itemlist['item_barterto'] = $row['item_barterto'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'posts' => $row_count);
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