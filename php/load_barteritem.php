<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['barterIdList'])) {
    $barterIdList = $_POST['barterIdList'];

    // Remove the square brackets at the beginning and end of the string
    $barterIdList = trim($barterIdList, "[]");

    // Seperate each elements of the string into array
    $barterIdArray = explode(", ", $barterIdList);

    // Now, construct a dynamic IN conditions to add '' for each itemId
    $conditions = array();
    foreach ($barterIdArray as $barterId) {
        $condition = "'" . $barterId . "'";

        array_push($conditions, $condition);
    }

    // Combining the OR conditions using implode()
    $conditionString = implode(", ", $conditions);

    // Construct sql query
    $sqlloaditems = "SELECT * FROM tbl_barteritems WHERE barteritem_itemid IN (" . $conditionString . ")";
} else {
    $itemid = $_POST['itemid'];

    // Construct sql query
    $sqlloaditems = "SELECT * FROM tbl_barteritems WHERE barteritem_itemid = '$itemid'";
}


$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $barteritems["barteritems"] = array();
    $row_count = mysqli_num_rows($result);

    while ($row = $result->fetch_assoc()) {
        $barteritemarray = array();
        $barteritemarray['offerid'] = $row['offer_id'];
        $barteritemarray['itemid'] = $row['barteritem_itemid'];
        $barteritemarray['userid'] = $row['barteritem_userid'];
        $barteritemarray['name'] = $row['barteritem_name'];
        $barteritemarray['desc'] = $row['barteritem_desc'];
        $barteritemarray['date'] = $row['barteritem_date'];
        $barteritemarray['qty'] = $row['barterdetail_qty'];
        $barteritemarray['price'] = $row['barteritem_price'];
        $barteritemarray['lat'] = $row['barteritem_lat'];
        $barteritemarray['long'] = $row['barteritem_long'];
        $barteritemarray['state'] = $row['barteritem_state'];
        $barteritemarray['locality'] = $row['barteritem_locality'];
        $barteritemarray['imagecount'] = $row['barteritem_imagecount'];

        array_push($barteritems["barteritems"], $barteritemarray);
    }
    $response = array('status' => 'success', 'data' => $barteritems, 'posts' => $row_count);
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