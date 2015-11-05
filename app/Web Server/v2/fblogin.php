<?php

include 'classes/database.php';
function getMeRandomPwd($length){
    $a = str_split("abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXY0123456789"); 
    shuffle($a);
    return substr( implode($a), 0, $length );
}
$newpass1 = getMeRandomPwd(8);
$newpass = md5($newpass1);
$secid = $_POST["secid"];



$phonenumber=000;
if ($secid == $auth) {
$connection = mysql_connect($server, $user, $pass);
if (!$connection){
	die("Database Connection Failed" . mysql_error());
}
$select_db = mysql_select_db($dbase);
if (!$select_db){
	die("Database Selection Failed" . mysql_error());
}

if (isset($_POST['id'])){
	
	$id=$_POST['id'];

	$query="SELECT `username`,`fbid` FROM `users` WHERE `fbid` =".$id;

	$fbpic="https://graph.facebook.com/".$id."/picture?type=large&width=256&height=256";

	$result = mysql_query($query);
	if(mysql_num_rows($result) == 0) {
		$registerquery="INSERT INTO users (profile_pic, password, email, phonenumber, fbid) VALUES ('$fbpic','$newpass','$id','$phonenumber','$id')";

		$st=mysql_query($registerquery);
		header('Content-Type: application/json');
		echo '{"registered"}'; 

	} else {
		header('Content-Type: application/json');
		//echo '{"success":';
		echo '{"success":'.mysql_result($result, 0);
	}

} else {
		header('Content-Type: application/json');
		echo '{"failure"}'; 

}
	}

?>