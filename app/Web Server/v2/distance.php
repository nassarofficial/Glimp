<?php
$b_id=$_GET["b_id"];

$lat1=$_GET["lat"];
$lon1=$_GET["lon"];

$server = 'localhost';
$user = 'root';
$pass = 'E663%156Z>z9d{$Ql395%2uH761oX9dP';
$dbase = 'glimp';

$mysqli = new mysqli($server, $user, $pass, $dbase);

$rows = array();
header('Content-Type: application/json');
function distance($lat1, $lon1, $lat2, $lon2, $unit) {

  $theta = $lon1 - $lon2;
  $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
  $dist = acos($dist);
  $dist = rad2deg($dist);
  $miles = $dist * 60 * 1.1515;
  $unit = strtoupper($unit);

  if ($unit == "K") {
    return ($miles * 1.609344);
  } else if ($unit == "N") {
      return ($miles * 0.8684);
    } else {
        return $miles;
      }
}

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


if ($stmt = $mysqli->prepare("SELECT A.longitude, A.latitude FROM `broadcast` as A where A.id = ?")) {

	$stmt->bind_param("s", $b_id);

     $stmt -> execute();

     $rows = fetch($stmt);

}
else{
    //print error message
    echo $mysqli->error;
}


/* close connection */


$mysqli -> close();
$rows[0]["distance"] = round(distance($lat1, $lon1, $rows[0]["latitude"], $rows[0]["longitude"], "K"),2) . " km";
echo '{"distance":' .json_encode($rows).'}';
//echo json_encode($rows);

?>