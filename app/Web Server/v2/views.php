<?php
include 'classes/database.php';
$gid = $_POST["gid"];
$secid = $_POST["secid"];


if ($secid == $auth) {

// Create connection
$conn = new mysqli($server, $user, $pass, $dbase);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
$sql = "UPDATE glimps SET views = views +1 WHERE id = '".$gid."'";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
}
?>
