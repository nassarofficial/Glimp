<?php
include 'classes/database.php';
$secid=$_POST["secid"];
$username=$_POST["userid"];

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

if ($secid == $auth) {

  $mysqli = new mysqli($server, $user, $pass, $dbase);
  $prename = "id";
  $rows = array();
  
  if ($stmt = $mysqli->prepare("SELECT id,description,loc,time,locid FROM glimps where user_id='".$username."' ORDER BY id DESC")) {
  
	   /* bind parameters for markers */
  
	   /* execute query */
	   $stmt -> execute();
  
	   $rows = fetch($stmt);
  }
  else{
	  //print error message
	  echo $mysqli->error;
  }
  
  
  /* close connection */
  $mysqli -> close();
  
  echo '{"glimps":' .json_encode($rows).'}';
  //echo json_encode($rows);
}
?>