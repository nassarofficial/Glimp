<?php
header('Content-Type: application/json');

include 'classes/database.php';

$secid = $_POST["secid"];

$fbid=$_POST['fbid'];
$email=$_POST['email'];


if ($secid == $auth) {
$connection = mysql_connect($server, $user, $pass);
if (!$connection){
	die("Database Connection Failed" . mysql_error());
}
$select_db = mysql_select_db($dbase);
if (!$select_db){
	die("Database Selection Failed" . mysql_error());
}

$checkerq="DELETE FROM `users` WHERE `username` = ''";
$checker=mysql_query($checkerq);  
}

?>