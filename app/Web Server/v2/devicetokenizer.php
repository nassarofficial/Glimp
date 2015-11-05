<?php
// define variables and set to empty values

include 'classes/database.php';

$secid = $_POST["secid"];
$user=$_POST['username'];
$devicetoken=$_POST['devicetoken'];
$OS=$_POST['OS'];



	// Create connection
	$conn = new mysqli($servername, $username, $password, $dbase);
	// Check connection
	
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	} 
	
if ($secid == $auth) {

	$findquery = "SELECT EXISTS(SELECT * FROM devices WHERE `devicetoken` =  '".$devicetoken."') as there";
	$result = mysqli_query($conn, $findquery);
	$row=mysqli_fetch_row($result);
	$conn->close();
	echo $row[0];
	if ($row[0] == 1){	
			$conn = new mysqli($servername, $username, $password, $dbase);
			if ($conn->connect_error) {
				die("Connection failed: " . $conn->connect_error);
			} 
			$sql = "UPDATE `devices` SET `user_id`=(SELECT id FROM users WHERE username = '".$user."'),`os`='".$OS."' WHERE `devicetoken`='".$devicetoken."'";
			if ($conn->query($sql) === TRUE) {
    			echo "Updated record created successfully";
			} else {
    			echo "Error: " . $sql . "<br>" . $conn->error;
			}

	} elseif ($row[0] == 0) {
			$conn = new mysqli($servername, $username, $password, $dbase);
			if ($conn->connect_error) {
				die("Connection failed: " . $conn->connect_error);
			} 

			$sql = "INSERT INTO devices(`user_id`, `devicetoken`,`OS`) VALUES((SELECT id FROM users WHERE username = '".$user."'),'".$devicetoken."','".$OS."')";
			if ($conn->query($sql) === TRUE) {
    			echo "New record created successfully";
			} else {
    			echo "Error: " . $sql . "<br>" . $conn->error;
			}
	}

}
?>
