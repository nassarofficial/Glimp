<?php
/* --------------------------- */
/*  Author : Dipin Krishna     */
/*  Website: dipinkrishna.com  */
/* --------------------------- */
include 'classes/database.php';

header('Content-type: application/json');
$secid=$_POST["secid"];

if ($secid == $auth) {

if($_POST) {
	$username   = $_POST['username'];
	$password   = $_POST['password'];
	$c_password = $_POST['c_password'];
	$email = $_POST['email'];
	$phonenumber = $_POST['phonenumber'];

	if($_POST['username']) {
		if ( $password == $c_password ) {

			$mysqli = new mysqli($server, $user, $pass, $dbase);

			/* check connection */
			if (mysqli_connect_errno()) {
				error_log("Connect failed: " . mysqli_connect_error());
				echo '{"success":0,"error_message":"' . mysqli_connect_error() . '"}';
			} else {
				$stmt = $mysqli->prepare("INSERT INTO users (username, password, email, phonenumber) VALUES (?, ?, ?, ?)");

				$password = md5($password);
				$stmt->bind_param('sssi', $username, $password, $email,$phonenumber);

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
			echo '{"success":0,"error_message":"Passwords does not match."}';
		}
	} else {
		echo '{"success":0,"error_message":"Invalid Username."}';
	}
}else {
	echo '{"success":0,"error_message":"Invalid Data."}';
}
}
?>
