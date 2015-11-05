<?php
// define variables and set to empty values
include 'classes/database.php';
$secid=$_POST["secid"];
$user = $_POST["uid"];

if ($secid == $auth) {

// Create connection
$conn = new mysqli($server, $user, $pass, $dbase);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
$sql = "DELETE FROM `friends` WHERE id=".$user;


if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
}
?>
