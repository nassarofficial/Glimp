<?php
include 'classes/database.php';
$secid=$_POST["secid"];

$username=$_POST["username"];

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



if ($secid == $auth) {


$prename = "id";

$rows = array();

if ($stmt = $mysqli->prepare("SELECT (SELECT users.id FROM `users` WHERE `username`='".$username."') AS userider, (SELECT profile_pic from users WHERE id = userider) as profilepic,(SELECT location from users WHERE id = userider) as location, (SELECT username from users WHERE id = userider) as username, (SELECT COUNT( glimps.id ) FROM `glimps` WHERE `user_id`=userider) AS glimpcount, (SELECT COUNT( friends.id ) FROM `friends` WHERE `uid`=userider) AS friends, (SELECT COUNT( friends.id ) FROM `friends` WHERE `fid`=userider) AS followers FROM glimps, users where glimps.user_id=(SELECT users.id FROM `users` WHERE `username`='".$username."') GROUP BY glimps.user_id")) {



     /* bind parameters for markers SELECT users.id,(SELECT users.id FROM `users` WHERE `username`='".$username."') AS userider, (SELECT profile_pic from users WHERE id = userider) as profilepic,(SELECT location from users WHERE id = userider) as location, (SELECT username from users WHERE id = userider) as username, (SELECT COUNT( glimps.id ) FROM `glimps` WHERE `user_id`=userider) AS glimpcount, (SELECT COUNT( friends.id ) FROM `friends` WHERE `uid`=userider) AS friends, (SELECT COUNT( friends.id ) FROM `friends` WHERE `fid`=userider) AS followers FROM glimps, users where glimps.user_id=(SELECT users.id FROM `users` WHERE `username`='".$username."') GROUP BY glimps.user_id  */

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

echo '{"profile":' .json_encode($rows).'}';
//echo json_encode($rows);
}
?>