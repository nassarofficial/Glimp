<?php
include 'classes/database.php';

header('Content-Type:application/json');

$target_dir = "profile_pics/";
$files = scandir($target_dir, 1);
$newest_file = $files[0];
$target_dir = $target_dir . preg_replace_callback('/(?<=_)\d+(?=\.)/',
                           function ($m) { return ++$m[0]; },
                           $newest_file);

$userid= $_POST['username'];
$secid= $_POST['secid'];

if ($secid == $auth) {

// Create connection
$conn = new mysqli($server, $user, $pass, $dbase);


$sql = "UPDATE `users` SET `profile_pic`='http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/".$target_dir."' WHERE `username` = '".$userid."'";
//

$conn->query($sql);

move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_dir);
}

?>
