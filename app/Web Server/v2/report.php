<?php
header('Content-Type:application/json');
include 'classes/database.php';
$secid=$_POST["secid"];
$glimpid= $_POST['glimpid'];
$reportid= $_POST['reportid'];
$desc= $_POST['description'];

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
$rows = array();

$mysqli = new mysqli($server, $user, $pass, $dbase);

	if ($stmt = $mysqli->prepare("INSERT INTO `report`(`desc`, `reporttype`, `glimpid`) VALUES (?,?,?)")) {
		 /* bind parameters for markers */
		 /* execute query */
		$stmt->bind_param("sss",$desc,$reportid,$glimpid);
		$stmt -> execute();
	
	
	}
	else{
		//print error message
		echo $mysqli->error;
	}
	
	
	/* close connection */
	
	
	$mysqli -> close();
	echo '{"status" : "OK"}';
//echo json_encode("status" : "OK");
}
?>