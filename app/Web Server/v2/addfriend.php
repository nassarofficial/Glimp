<?php
include 'classes/database.php';
$secid=$_POST["secid"];
function aps($deviceToken,$message){
	  $passphrase = 'hsl94J9wpxT';

	  $ctx = stream_context_create();
	  stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
	  stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
	  
	  // Open a connection to the APNS server
	  $fp = stream_socket_client(
		  'ssl://gateway.push.apple.com:2195', $err,
		  $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
	  
	  if (!$fp)
		  exit("Failed to connect: $err $errstr" . PHP_EOL);
	  
	  echo 'Connected to APNS' . PHP_EOL;
	  
	  // Create the payload body
	  $body['aps'] = array(
		  'alert' => $message,
		  'sound' => 'default'
		  );
	  
	  // Encode the payload as JSON
	  $payload = json_encode($body);
	  
	  // Build the binary notification
	  $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;
	  
	  // Send it to the server
	  $result = fwrite($fp, $msg, strlen($msg));
	  
	  if (!$result)
		  echo 'Message not delivered' . PHP_EOL;
	  else
		  echo 'Message successfully delivered' . PHP_EOL;
	  
	  // Close the connection to the server
	  fclose($fp);
}
//$d0evieToken = '16a0cebc8237dfbf6f5413e0fa16303bf4f45292d2b66409f234dc715a851c72';
//$deviceToken = '4edc0a394dadc6963147125b84b4cac9a0262b9efb0125c82d354a8aab1a57a2';
//$message = 'erere';


  $user = $_POST["user"];
  $friend = $_POST["friend"];
  
if ($secid == $auth) {

// Create connection
$conn = new mysqli($server, $user, $pass, $dbase);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
$sql = "INSERT INTO friends(`uid`, `fid`)
   VALUES('".$user."', '".$friend."')";

$sql1 = "INSERT INTO notifications(`type`,`user_id`, `f_id`)
   VALUES('1','".$user."', '".$friend."')";

$sql2 = "select username as friend ,devicetoken, (select username from users where id=".$user.") as user from users,devices where users.id =".$friend." and devices.user_id =".$friend;


if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}
if ($conn->query($sql1) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

	$result = mysqli_query($conn, $sql2);
	$row=mysqli_fetch_row($result);

$conn->close();

$message = $row[2]." is now following you.";
aps($row[1],$message);
}
?>
