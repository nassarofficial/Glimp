<?php
header('Content-Type:application/json');
include 'classes/database.php';
$secid=$_POST["secid"];

$userid= $_POST['username'];
$query= $_POST['query'];

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

$rows = array();
if ($secid == $auth) {


if ($stmt = $mysqli->prepare("SELECT a.id,a.fid,b.profile_pic,b.username,a.uid, b.id
		FROM friends a 
			INNER JOIN users b on b.id = a.fid
			INNER JOIN users c on c.id = a.uid
		WHERE c.username= ? and b.username LIKE ?")) {
     /* bind parameters for markers */
     /* execute query */
	$likeString = $query . '%';

	$stmt->bind_param("ss",$userid,$likeString);
    $stmt -> execute();
	$rows = fetch($stmt);


}
else{
    //print error message
    echo $mysqli->error;
}


/* close connection */


$mysqli -> close();
echo '{"predictions":' .json_encode($rows).',"status" : "OK"}';
//echo json_encode($rows);
}
?>