<?php
include 'classes/database.php';
$secid=$_POST["secid"];

$username=$_POST["username"];
$other=$_POST["friend"];

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



if ($stmt = $mysqli->prepare("SELECT users.id as userider, users.username,users.profile_pic as profilepic, glimps.user_id,
IFNULL((SELECT COUNT(*) FROM friends WHERE friends.uid=users.id group by friends.uid),0) AS friends, 
IFNULL((SELECT COUNT(*) FROM friends WHERE friends.fid=users.id group by friends.fid),0) AS followers,
IFNULL((SELECT COUNT(*) FROM glimps WHERE glimps.user_id=users.id group by glimps.user_id),0) AS glimpcount,
IFNULL((SELECT friends.id from friends WHERE friends.uid = users.id and friends.fid = (select users.id from users where users.username='".$other."')),'not found') as follow,
(select users.id from users where users.username='".$other."') as useriderer
FROM users
INNER JOIN glimps
ON users.id = glimps.user_id
Where users.username = '".$username."'
GROUP BY glimps.user_id")) {

     /* bind parameters for markers */

     /* execute query */
     $stmt -> execute();

     $rows = fetch($stmt);
	$mysqli -> close();

	echo '{"profile":' .json_encode($rows).'}';
//echo json_encode($rows);

}
else{
    //print error message
    echo $mysqli->error;
}


/* close connection */
}
?>