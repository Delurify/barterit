<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$userid = $_POST['userid'];
$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $items["items"] = array();
	
while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_imagecount'] = $row['item_imagecount'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_qty'] = $row['item_qty'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_datereg'] = $row['item_datereg'];
        $itemlist['item_barterto_electronicdevice'] = $row['item_barterto_electronicdevice'];
        $itemlist['item_barterto_vehicle'] = $row['item_barterto_vehicle'];
        $itemlist['item_barterto_furniture'] = $row['item_barterto_furniture'];
        $itemlist['item_barterto_book&stationery'] = $row['item_barterto_book&stationery'];
        $itemlist['item_barterto_homeappliance'] = $row['item_barterto_homeappliance'];
        $itemlist['item_barterto_fashion&cosmetic'] = $row['item_barterto_fashion&cosmetic'];
        $itemlist['item_barterto_videogame&console'] = $row['item_barterto_videogame&console'];
        $itemlist['item_barterto_forchildren'] = $row['item_barterto_forchildren'];
        $itemlist['item_barterto_musicalinstrument'] = $row['item_barterto_musicalinstrument'];
        $itemlist['item_barterto_sport'] = $row['item_barterto_sport'];
        $itemlist['item_barterto_food&nutrition'] = $row['item_barterto_food&nutrition'];
        $itemlist['item_barterto_other'] = $row['item_barterto_other'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items);
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