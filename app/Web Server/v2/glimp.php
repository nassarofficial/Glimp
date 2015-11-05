<?php
include 'classes/database.php';

$glimpid=$_POST["glimpid"];
$secid = $_POST["secid"];

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


$mysqli = new mysqli($server, $user, $pass, $dbase);

$prename = "id";

$rows = array();
if ($secid == $auth) {

if ($stmt = $mysqli->prepare("SELECT glimps.id,glimps.b_id, glimps.user_id as userid, (SELECT username FROM users where id = userid) as username, glimps.filename,glimps.time,glimps.stoptime, glimps.description, glimps.loc, glimps.locid, glimps.time, glimps.tplus, glimps.views, (SELECT COUNT( comments.id ) FROM  `comments` WHERE  `glimp_id`=".$glimpid.") AS COMMENT FROM glimps, users, comments where glimps.id=".$glimpid." GROUP BY glimps.id")) {



     /* bind parameters for markers */

     /* execute query */
     $stmt -> execute();

     $rows = fetch($stmt);
echo '{"glimp":' .json_encode($rows).'}';

}
else{
    //print error message
    //echo $mysqli->error;
	echo '{"error"}';
	
}


/* close connection */
$mysqli -> close();
}
?>