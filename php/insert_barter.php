<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


if (isset($_POST['barter_userid'])) {
    $offer_id = $_POST['offer_id'];
    $barter_userid = $_POST['barter_userid'];
    $barter_itemname = $_POST['barter_itemname'];
    $barter_itemdesc = $_POST['barter_itemdesc'];
    $barter_itemqty = $_POST['barter_itemqty'];
    $barter_itemprice = $_POST['barter_itemprice'];
    $barter_itemlat = $_POST['barter_itemlat'];
    $barter_itemlong = $_POST['barter_itemlong'];
    $barter_itemstate = $_POST['barter_itemstate'];
    $barter_itemLocality = $_POST['barter_itemLocality'];
    $barter_imagecount = $_POST['barter_imagecount'];
    $item_id = $_POST['item_id'];

    $sqlinsert = "INSERT INTO `tbl_barteritems`(`offer_id`, `barteritem_itemid`, `barteritem_userid`, `barteritem_name`, `barteritem_desc`, `barteritem_qty`, `barteritem_price`, `barteritem_lat`, `barteritem_long`, `barteritem_state`, `barteritem_locality`, `barteritem_imagecount`) VALUES ('$offer_id', '$item_id','$barter_userid', '$barter_itemname', '$barter_itemdesc', '$barter_itemqty', '$barter_itemprice', '$barter_itemlat', '$barter_itemlong', '$barter_itemstate', '$barter_itemLocality', '$barter_imagecount')";
} else if (isset($_POST['barter_giveitemid'])) {
    $offer_id = $_POST['offer_id'];
    $barter_giveitemid = $_POST['barter_giveitemid'];
    $barter_takeitemid = $_POST['barter_takeitemid'];
    $barter_giveuserid = $_POST['barter_giveuserid'];
    $barter_takeuserid = $_POST['barter_takeuserid'];

    $sqlinsert = "INSERT INTO `tbl_barters` (`offer_id`,`barter_giveitemid`, `barter_takeitemid`, `barter_giveuserid`, `barter_takeuserid`) VALUES ('$offer_id', '$barter_giveitemid', '$barter_takeitemid', '$barter_giveuserid', '$barter_takeuserid')";
}


if ($conn->query($sqlinsert) === TRUE) {
    if (isset($_POST['barter_userid'])) {
        $sqldelete = "DELETE FROM tbl_items WHERE item_id = '$item_id'";

        if ($conn->query($sqldelete) === TRUE) {
            $sqldeleteoffer = "DELETE FROM tbl_offers WHERE offer_takeid = '$item_id' OR offer_giveid = '$item_id'";

            if ($conn->query($sqldeleteoffer) === TRUE) {
                $sqldeletefavorite = "DELETE FROM tbl_favorites WHERE item_id = '$item_id'";

                if ($conn->query($sqldeletefavorite) === TRUE) {
                    $response = array('status' => 'success', 'data' => null);
                    sendJsonResponse($response);
                }
            }
        }
    } else {
        $response = array('status' => 'success', 'data' => null);
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