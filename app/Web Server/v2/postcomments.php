<?php
function aps($deviceToken,$message){
	  $passphrase = 'hsl94J9wpxT';

	  $ctx = stream_context_create();
	  stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
	  stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
	  
	  // Open a connection to the APNS server
	  $fp = stream_socket_client(
		  'ssl://gateway.sandbox.push.apple.com:2195', $err,
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
	  
	//  if (!$result)
	//	  echo 'Message not delivered' . PHP_EOL;
	//  else
	//	  echo 'Message successfully delivered' . PHP_EOL;
	  
	  // Close the connection to the server
	  fclose($fp);
}
 

function fetch($result)
{    
    $array = array();

    if($result instanceof mysqli_stmt)
    {
        $result->store_result();

        $variables = array();
        $data = array();
        $meta = $result->result_metadata();

        while($field = $meta->fetch_field())
            $variables[] = &$data[$field->name]; // pass by reference

        call_user_func_array(array($result, 'bind_result'), $variables);

        $i=0;
        while($result->fetch())
        {
            $array[$i] = array();
            foreach($data as $k=>$v)
                $array[$i][$k] = $v;
            $i++;

            // don't know why, but when I tried $array[] = $data, I got the same one result in all rows
        }
    }
    elseif($result instanceof mysqli_result)
    {
        while($row = $result->fetch_assoc())
            $array[] = $row;
    }

    return $array;
}

header('Content-type: application/json');
include 'classes/database.php';
$secid=$_POST["secid"];
if ($secid == $auth) {

if($_POST) {
	date_default_timezone_set('Africa/Cairo');

	$username= $_POST['userid'];
	$userid = 0;
	$glimpid = $_POST['glimpid'];
	$g_userid = 0;
	$g_username = "";
	$devicetoken = 0;
	$comment= $_POST['comment'];

	$mysqli = new mysqli($server, $user, $pass, $dbase);

	/* check connection */
	if (mysqli_connect_errno()) {
		error_log("Connect failed: " . mysqli_connect_error());
		echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
	} else {
			//echo $username;
		if ($stmtIder = $mysqli->prepare("SELECT id FROM users WHERE username = ?")) {
			$stmtIder->bind_param("s", $username);
			$stmtIder->execute();
   			$stmtIder->bind_result($userid);
    		$stmtIder->fetch();
			//echo $userid;
			$stmtIder->close();
			
			$stmtIder = $mysqli->prepare("INSERT INTO comments(`user_id`, `glimp_id`, `comment`) VALUES(?,?,?)");
			$stmtIder->bind_param("sis", $userid,$glimpid,$comment);
			$stmtIder->execute();
			$stmtIder->close();
			
			$stmtIder = $mysqli->prepare("SELECT users.id,users.username,devices.devicetoken FROM glimps INNER JOIN users ON glimps.user_id=users.id INNER JOIN devices ON devices.user_id=users.id WHERE glimps.id = ?");
			$stmtIder->bind_param("s",$glimpid);
			$stmtIder->execute();
    		$stmtIder->bind_result($g_userid,$g_username,$devicetoken);
    		$stmtIder->fetch();

			$stmtIder->close();

			echo "  g user:   ";
			echo $g_userid;
			echo "u user:    ";
			echo $userid;
			if ($g_userid != $userid){
				
				$stmtIder = $mysqli->prepare("INSERT INTO notifications(`type`,`user_id`, `f_id`, `g_id`)  VALUES(2,?,?,?)");
				$stmtIder->bind_param("sis", $g_userid,$userid,$glimpid);
				$stmtIder->execute();
				$stmtIder->close();
				
				$message = $username." has commented on your glimp!";
				echo "       ";
				echo $devicetoken;
				aps($devicetoken,$message);
				
				
				

			}
							$mentions = array();
				preg_match_all("/(@\w+)/", $comment, $matches);
				foreach ($matches[0] as $mentiontag)
					array_push($mentions, ltrim ($mentiontag, '@'));
					print_r($mentions);

							if (count($mentions) >= 1) {
					
					echo "test";
					$friendsSQL = "SELECT users.username, users.id, devices.devicetoken FROM users INNER JOIN friends ON friends.fid=users.id INNER JOIN devices ON devices.user_id=users.id WHERE friends.uid = (SELECT id from users where username='".$g_username."')";
				
					
					$mysqli->query($friendsSQL);
					$result = $mysqli->query($friendsSQL);
					
					$friends = array();
					$devicetoken = array();
					$ids = array();
				
					if ($result->num_rows > 0) {
						while($rows = $result->fetch_assoc()) {
							array_push($friends, $rows["username"]);
							array_push($ids, $rows["id"]);
				
							array_push($devicetoken, $rows["devicetoken"]);
						}
							foreach ($mentions as &$value) {
					
						for ($x = 0; $x <= count($friends)-1; $x++) {
							if ($value == $friends[$x]){
								$message = $username." has mentioned you on a comment.";
								aps($devicetoken[$x],$message);
								$sql1 = "INSERT INTO notifications(`type`,`user_id`, `f_id`,`g_id`) VALUES('5',(SELECT id from users where username='".$userid."'), '".$ids[$x]."','".$glimpid."')";
								$mysqli->query($sql1);
							}
						} 
					
						}
					}
				
				
				}
		}

		/* close connection */
		$mysqli->close();
		
		echo '{"success":1}';
	}
}else {

	echo '{"success":0,"error_message":"Invalid Data."}';
}

}

?>
