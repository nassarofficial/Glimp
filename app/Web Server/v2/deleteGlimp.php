<?php
include 'classes/database.php';
$secid=$_POST["secid"];
$g_id=$_POST["g_id"];


$mysqli = new mysqli($server, $user, $pass, $dbase);

$rows = array();
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

if ($stmt = $mysqli->prepare("DELETE FROM `glimps` WHERE `id` = ?")) {
	
	$stmt->bind_param("s", $g_id);
    $stmt -> execute();
	$stmt1 = $mysqli->prepare("DELETE FROM `notifications` WHERE `g_id`= ?");
	$stmt1->bind_param("s", $g_id);
    $stmt1 -> execute();

	echo '{"deleted"}';
}
else{
    //print error message'
	echo '{"error"}';

    echo $mysqli->error;
}


/* close connection */


$mysqli -> close();
}
?>