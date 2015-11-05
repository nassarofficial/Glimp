<?php
include 'classes/database.php';
$secid=$_POST["secid"];
$email=$_POST['email'];

function getMeRandomPwd($length){
    $a = str_split("abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXY0123456789"); 
    shuffle($a);
    return substr( implode($a), 0, $length );
}

$newpass1 = getMeRandomPwd(8);
$newpass = md5($newpass1);


if ($secid == $auth) {
	  $connection = mysql_connect($server, $user, $pass);
	  if (!$connection){
		  die("Database Connection Failed" . mysql_error());
	  }
	  $select_db = mysql_select_db($dbase);
	  if (!$select_db){
		  die("Database Selection Failed" . mysql_error());
	  }
	  
	  $email=mysql_real_escape_string($email);
	  $status = "OK";
	  $msg="";
	  //error_reporting(E_ERROR | E_PARSE | E_CORE_ERROR);
	  // You can supress the error message by un commenting the above line
	  if (!stristr($email,"@") OR !stristr($email,".")) {
	  $msg="Your email address is not correct<BR>"; 
	  $status= "NOTOK";}
	  
	  if($status=="OK"){ // validation passed now we will check the tables
	  $query="SELECT email,username,id,password FROM users WHERE users.email = '$email'";
	  $query1="UPDATE `users` SET `password`='$newpass' WHERE `email` = '$email'";
	  
	  $st=mysql_query($query);
	  $recs=mysql_num_rows($st);
	  $row=mysql_fetch_object($st);
	  $em=$row->email;// email is stored to a variable
	  
	  if ($recs == 0) { // No records returned, so no email address in our table
	  echo '{"none"}'; 
	  exit;}
	  
	  // formating the mail posting
	  // headers here 
	  $headers="";
	  $headers4="no-reply@glimp-now.com"; // Change this address within quotes to your address
	  $headers.="Reply-to: $headers4\n";
	  $headers .= "From: $headers4\n"; 
	  $headers .= "Errors-to: $headers4\n"; 
	  //$headers = "Content-Type: text/html; charset=iso-8859-1\n".$headers;// for html mail 
	  
	  // mail funciton will return true if it is successful
	  if(mail("$em","Glimp | Your new password","This is in response to your request for login details, you can change the password from within the app settings. \n \nLogin ID: $row->username \n 
	  Password: $newpass1 \n\n \n \n - Glimp","$headers"))
	  {
	  $st=mysql_query($query1);
	  header('Content-Type: application/json');
	  echo '{"success"}'; 
	  }
	  
	  else{// there is a system problem in sending mail
	  header('Content-Type: application/json');
	  echo '{"error"}'; 
	  }
	  } 
	  
	  else {// Validation failed so show the error message
	  }
}

?>