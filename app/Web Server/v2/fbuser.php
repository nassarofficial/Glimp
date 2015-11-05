<?php
header('Content-Type: application/json');
include 'classes/database.php';

$secid = $_POST["secid"];
$username=$_POST['username'];
$fbid=$_POST['fbid'];


if ($secid == $auth) {
$connection = mysql_connect($server, $user, $pass);
if (!$connection){
	die("Database Connection Failed" . mysql_error());
}
$select_db = mysql_select_db($dbase);
if (!$select_db){
	die("Database Selection Failed" . mysql_error());
}

$line = rtrim($username);

$checkerq="SELECT `username` FROM `users` WHERE `username` ='$username'";
$checker=mysql_query($checkerq);


	if(mysql_num_rows($checker)>0){
	// Username Exists
		header('Content-Type: application/json');
		echo '{"exists"}'; 

	} else {
	// Username is fine, continue....
	
		$registerq="UPDATE `users` SET`username`='$username' WHERE `fbid` =".$fbid;
		$register=mysql_query($registerq);
		echo '{"registered"}'; 

	}
}


?>