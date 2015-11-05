<?php

include 'classes/database.php';

$username=$_POST["username"];
$secid = $_POST["secid"];

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

$rows = array();


$mysqli = new mysqli($server, $user, $pass, $dbase);

$prename = "id";

$rows = array();
date_default_timezone_set('Africa/Cairo');

$rows = array();
$today = date("Y-m-d H:i:s");
$current = (string)$today;
if ($secid == $auth) {
  
	  if ($stmt = $mysqli->prepare("SELECT glimps.*,users.profile_pic,users.username from glimps, users where glimps.user_id = users.id and stoptime > '".$current."' and glimps.user_id IN (SELECT fid FROM friends WHERE uid=(SELECT id from users where username='".$username."'))")) {
	  
		   /* bind parameters for markers */
	  
		   /* execute query */
		   $stmt -> execute();
	  
		   $rows = fetch($stmt);
	  
		  if (count($rows) != 0){
			  echo '{"glimps":' .json_encode($rows).'}';
		  }
		  else{
			  echo '{"glimps":' .json_encode($rows).'}';
	  
		  }
	  }
	  else{
		  //print error message
		  echo $mysqli->error;
	  }
	  
	  
	  /* close connection */
	  $mysqli -> close();
}

?>