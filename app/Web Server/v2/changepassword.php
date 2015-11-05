<?php
include 'classes/database.php';
$secid=$_POST["secid"];
$username=$_POST["userid"];
$newpassword=$_POST["newpassword"];

$newpass = md5($newpassword);
header('Content-Type: application/json');


if ($secid == $auth) {

  $mysqli = new mysqli($server, $user, $pass, $dbase);
  $prename = "id";
  $rows = array();
  
  if ($stmt = $mysqli->prepare("UPDATE `users` SET `password`='".$newpass."' WHERE username='".$username)) {
  
	   /* bind parameters for markers */
  
	   /* execute query */
	   $stmt -> execute();
  
  }
  else{
	  //print error message
  echo '{"error"}';
  }
  
  
  /* close connection */
  $mysqli -> close();
  
  echo '{"success"}';
  //echo json_encode($rows);
}
?>