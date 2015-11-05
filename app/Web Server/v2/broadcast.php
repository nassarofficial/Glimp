<?php
$lat=$_POST["lat"];
$long=$_POST["long"];
$user_id=$_POST["user_id"];
$secid = $_POST["secid"];


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
	  
	  if (!$result)
		  echo 'Message not delivered' . PHP_EOL;
	  else
		  echo 'Message successfully delivered' . PHP_EOL;
	  
	  // Close the connection to the server
	  fclose($fp);
}

header('Content-Type: application/json');

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



if($secid == $auth) {

$rows = array();


if ($stmt = $mysqli->prepare("SELECT 
    a.id as b_id,
	a.user_id,
	a.latitude,
	a.longitude,
	a.message,
	a.timestamp,/* TableA.nameA */
    b.id,
	b.username,
	b.profile_pic,
	c.devicetoken,
	c.user_id,
	d.username as user,
	d.id as ider
FROM broadcast a 
    INNER JOIN users b on b.id = a.user_id
    INNER JOIN users d on d.username = ?
	INNER JOIN devices c on c.user_id = d.id

WHERE (POW((a.latitude-?)*111.12, 2) + POW((a.longitude - ?)*111.12, 2)) <= 100 and a.user_id != ?")) {

     /* bind parameters for markers */

     /* execute query */
	$stmt->bind_param("ssss",$user_id, $lat, $long,$user_id);

     $stmt -> execute();

     $rows = fetch($stmt);
	$num_rows = count($rows);
	print_r($rows);


for ($x = 0; $x < $num_rows; $x++) {


	$stmt2 = $mysqli->prepare("SELECT `type`, `user_id`, `f_id`, `b_id` FROM `notifications` WHERE `type`=3 and `user_id`= ? and `f_id`= ? and `b_id` = ?");
	$stmt2->bind_param("sss", $rows[$x]["id"],$rows[$x]["ider"],$rows[$x]["b_id"]);
	$stmt2 -> execute();
	$rows3 = fetch($stmt2);

	if (empty($rows3)){

		$stmt = $mysqli->prepare("INSERT IGNORE INTO notifications(`type`,`user_id`, `f_id`, `b_id`) VALUES(3,?,?,?)");
		$stmt->bind_param("sss",$rows[$x]["id"], $rows[$x]["ider"],$rows[$x]["b_id"]);
	    $stmt -> execute();
		$message = $rows[$x]["username"]." wants to know what's going around near you!";
    	aps($rows[$x]["devicetoken"],$message);

	} else {
		echo "nothing";

	}

}

}
else{
    //print error message
    echo $mysqli->error;
}


/* close connection */


$mysqli -> close();

//echo '{"broadcast":' .json_encode($rows).'}';
//echo json_encode($rows);
}
?>