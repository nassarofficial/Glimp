<?php
header('Content-Type: application/json');
include 'classes/database.php';
$secid=$_POST["secid"];
$userid = $_POST["userid"];

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

date_default_timezone_set('Africa/Cairo');

$rows = array();
$today = date("Y-m-d H:i:s");
$current = (string)$today;
//if ($stmt = $mysqli->prepare("SELECT * FROM glimps")) {
//
if ($stmt = $mysqli->prepare("SELECT notifications.id,notifications.type,notifications.f_id,notifications.g_id,notifications.b_id,notifications.timestamp,users.username,users.profile_pic FROM `notifications` 
INNER JOIN users ON notifications.user_id=users.id where notifications.f_id = (select id from users where username='".$userid."') order by notifications.id desc limit 0,15")) {

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
} else {
echo '{"notifications":' .json_encode($rows).'}';
}
//echo json_encode($rows);
}
?>