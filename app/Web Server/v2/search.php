<?php
include 'classes/database.php';

header('Content-Type: application/json');

$term = $_GET["term"];
$scope = $_GET["scope"];

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

$prename = "id";
date_default_timezone_set('Africa/Cairo');

$rows = array();
$today = date("Y-m-d H:i:s");
$current = (string)$today;

  if ($scope == "users"){
  
  
	  if ($stmt = $mysqli->prepare("SELECT id,username,profile_pic FROM `users` WHERE `username` LIKE '%".$term."%'")) {
	  
		   /* bind parameters for markers */
	  
		   /* execute query */
		   $stmt -> execute();
	  
		   $rows = fetch($stmt);
	  }
	  else{
		  //print error message
		  echo $mysqli->error;
	  }
  
  } else if ($scope == "description") {
		  if ($stmt = $mysqli->prepare("SELECT id,description,loc,locid,filename FROM  `glimps` WHERE `description` LIKE '%".$term."%'")) {
	  
		   /* bind parameters for markers */
	  
		   /* execute query */
		   $stmt -> execute();
	  
		   $rows = fetch($stmt);
	  }
	  else{
		  //print error message
		  echo $mysqli->error;
	  }
  
  }
  
  if($rows)
  {
  echo '{"search":' .json_encode($rows).'}';
  }
  else
  {
  echo '{"search":' .json_encode("nothing").'}';
  }
  $mysqli -> close();

?>