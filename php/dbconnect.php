<?php
$servername = "localhost";
$username = "delurif1_barterituser";
$password = "********";
$dbname = "delurif1_barteritdb";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>