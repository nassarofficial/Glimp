<?php
include 'classes/database.php';
$secid=$_POST["secid"];
$loc=$_POST["hashtag"];

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

$mysqli = new mysqli($server, $user, $pass, $dbase);
$prename = "id";
$rows = array();
if ($secid == $auth) {

	  if ($stmt = $mysqli->prepare("select id,filename,loc,locid,time from `glimps` where `description` LIKE '%#".$loc."%' order by id DESC")) {
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
	  
	  echo '{"hashtag":' .json_encode($rows).'}';
//echo json_encode($rows);
}
?>