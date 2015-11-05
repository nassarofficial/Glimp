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

include 'classes/database.php';
$secid=$_POST["secid"];

if ($secid == $auth) {

if($_POST) {
	$target_dir = "uploads/";
	$files = scandir($target_dir, 1);
	$newest_file = $files[0];
	$target_dir = $target_dir . preg_replace_callback('/(?<=_)\d+(?=\.)/',
							   function ($m) { return ++$m[0]; },
							   $newest_file);
	date_default_timezone_set('Etc/GMT-0');

$today = date("Y-m-d H:m:s");
$current = $today;
$datetime = new DateTime($current);
$datetime->add(new DateInterval('P1D'));
$stoptime = $datetime->format('Y-m-d H:m:s');
$lastId = 0;
	$userid= $_POST['username'];
	$lat= $_POST['latitude'];
	$long= $_POST['longitude'];
	$loc= $_POST['loc'];
	$locid= $_POST['locid'];
	$desc= $_POST['desc'];
	$b_id= intval($_POST['b_id']);

	$db_name     = 'glimp';
	$db_user     = 'root';
	$db_password = 'E663%156Z>z9d{$Ql395%2uH761oX9dP';
	$server_url  = 'localhost';

	$mysqli = new mysqli('localhost', $db_user, $db_password, $db_name);

	/* check connection */
	if (mysqli_connect_errno()) {
		error_log("Connect failed: " . mysqli_connect_error());
		echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
	} else {
		if ($stmt = $mysqli->prepare("INSERT INTO `glimps`(`user_id`, `latitude`, `longitude`, `filename`, `description`, `loc`, `locid`,`stoptime`,`b_id`) VALUES ((SELECT id from users where username='".$userid."'),'".$lat."','".$long."','".$target_dir."','".$desc."','".$loc."','".$locid."','".$stoptime."','".$b_id."')")) {

			/* execute query */
			$stmt->execute();
			$lastId = $mysqli->insert_id;

			/* fetch value */
			$stmt->fetch();

			/* close statement */
			$stmt->close();
			echo $b_id;
			
				if ($b_id != 0){
					echo "exists bid";
			$stmt2 = $mysqli->prepare("SELECT 
			a.id as b_id,
    		b.id as g_id,
			b.id as user_id,
			c.devicetoken,
			d.id as f_id
			FROM broadcast a 
				INNER JOIN users b on b.id = a.user_id
				INNER JOIN devices c on c.user_id = a.user_id
				INNER JOIN users d on d.username =d.username
			WHERE d.username=? and a.id = ?");

			$stmt2->bind_param("ss", $userid,$b_id);
			$stmt2 -> execute();
			$rows2 = fetch($stmt2);
			$num_rows = count($rows2);

			for ($x = 0; $x < $num_rows; $x++) {
			
				if (empty($rows2)){
					echo "nothing";
				} else {
					$stmt = $mysqli->prepare("INSERT INTO notifications(`type`,`user_id`, `f_id`, `g_id`, `b_id`) VALUES(4,?,?,?,?)");
					$stmt->bind_param("sss",$rows2[$x]["user_id"], $rows2[$x]["f_id"],$mysqli->insert_id,$b_id);
					$stmt -> execute();
					$message = $rows[$x]["username"]." glimped back to your request!";
					aps($rows[$x]["devicetoken"],$message);
				}
			
			}

	} else {
		echo "nothing";
}
	

move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_dir);
$ret=exec("ffmpeg -i /var/www/html/".$target_dir." -ss 00:00:01.000 -vframes 1 -an -s 400x400 /var/www/html/thumbnail/".$target_dir.".png");


$mentions = array();
preg_match_all("/(@\w+)/", $desc, $matches);
foreach ($matches[0] as $mentiontag)
	array_push($mentions, ltrim ($mentiontag, '@'));


if (count($mentions) >= 1) {
	$friendsSQL = "SELECT users.username, users.id, devices.devicetoken FROM users INNER JOIN friends ON friends.fid=users.id INNER JOIN devices ON devices.user_id=users.id WHERE friends.uid = (SELECT id from users where username='".$userid."')";

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
				$message = $friends[$x]." has just tagged you in this glimp.";
				aps($devicetoken[$x],$message);
				$sql1 = "INSERT INTO notifications(`type`,`user_id`, `f_id`,`g_id`) VALUES('4',(SELECT id from users where username='".$userid."'), '".$ids[$x]."','".$lastId."')";
				$mysqli->query($sql1);
			}
		} 
	
		}
	}


}






		}

		/* close connection */
	echo '{"success"}';
	}
}else {
header('Content-type: application/json');

	echo '{"success":0,"error_message":"Invalid Data."}';
}
}


?>
