<?php
/* --------------------------- */
/*  Author : Dipin Krishna     */
/*  Website: dipinkrishna.com  */
/* --------------------------- */
include 'classes/database.php';
$secid = $_POST["secid"];


header('Content-type: application/json');
if($_POST && $secid == $auth) {
	$username   = $_POST['username'];
	$lat   = floatval($_POST['lat']);
	$long = floatval($_POST['long']);
	//$message = $_POST['message'];
	$message = "What's Happening Here Right Now?";
	if($_POST['username']) {

			/* check connection */
			if (mysqli_connect_errno()) {
				error_log("Connect failed: " . mysqli_connect_error());
				echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
			} else {
				$stmt = $mysqli->prepare("INSERT INTO broadcast (user_id, latitude, longitude, message) VALUES ((SELECT id from users where username=?), ?, ?, ?)");

				$stmt->bind_param('sdds', $username, $lat, $long,$message);

				/* execute prepared statement */
				$stmt->execute();

				if ($stmt->error) {error_log("Error: " . $stmt->error); }
				
				$success = $stmt->affected_rows;

				/* close statement and connection */
				$stmt->close();

				/* close connection */
				$mysqli->close();
				error_log("Success: $success");

				if ($success > 0) {
					error_log("User '$username' created.");
					echo '{"success":1}';
				} else {
					echo '{"success":0,"error_message":"Username Exist."}';
				}
			}
	} else {
		echo '{"success":0,"error_message":"Invalid Username."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
?>
