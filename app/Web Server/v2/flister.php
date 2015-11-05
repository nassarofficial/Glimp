<?php
header('Content-Type: application/json');
include 'classes/database.php';
$secid=$_POST["secid"];
$userid = $_POST["username"];
$type = $_POST["type"];

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

if ($type == 1){
	$typer = 'uid';
} else {
	$typer = 'fid';
}

if ($stmt = $mysqli->prepare("SELECT users.id, users.username, users.profile_pic
FROM users
INNER JOIN friends
ON users.id=friends.id where friends.$typer=(SELECT id FROM users WHERE username = '".$userid."')
ORDER BY users.username;")) {

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

if (count($rows) == 0) {
echo '{"none"}';

} else {
echo '{"list":' .json_encode($rows).'}';
}
}
?>