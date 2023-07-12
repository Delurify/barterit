<?php
//error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];
$credit = $_GET['credit'];

$data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true") {
    $paidstatus = "Success";
} else {
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'S-Wk7kvpEh0uoUO0Bql_8OXA');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success") { //payment success
        $sqlinsert = "INSERT INTO `tbl_payments` (`user_id`, `payment_receiptid`,`payment_amount`) VALUES ('$userid', '$receiptid', '$amount')";
        if ($conn->query($sqlinsert) === TRUE) {
            $sqlupdate = "UPDATE `tbl_users` SET `user_credit` = (user_credit + $credit) WHERE user_id = '$userid'";
            $conn->query($sqlupdate);
        }
    }

    echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class='w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid Amount</td><td>RM$amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-green'>$paidstatus</td></tr>
        </table><br>
        
        </body>
        </html>";
} else {
    echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Receipt</h4></center>
        <table class='w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Paid</td><td>RM $amount</td></tr>
        <tr><td>Paid Status</td><td class='w3-text-red'>$paidstatus</td></tr>
        </table><br>
        
        </body>
        </html>";
}


?>