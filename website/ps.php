<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<?php
include "/includes/library.php";
include "/includes/configs.php";

if(isset($_GET["id"]) && isset($_GET["email"]) && isset($_GET["password"])) { 

$email_get = $_GET['email'];
$password_get = $_GET['password'];
$query = $DBH->prepare('select * from hashtable WHERE id = :id');
$query->bindParam(':id', $_GET['id'], PDO::PARAM_STR);
$query->execute();
$obj = $query->fetchObject();
$email = $obj->email;
$id = $obj->id;
$notified = $obj->notified;
$time_expire = $obj->time_expire;
if(($notified == "TRUE") && ($email_get == $email)) {
    #deals with ackward clock roll over at 11pm & 12am.. Maybe I'll think of a better way later
    if ((date('H') <= "$time_expire") || (date('H', strtotime('+2 hours')) == "$time_expire") || (date('H', strtotime('+1 hours')) == "$time_expire")) {
	$email = base64_encode ($email);
	$password = base64_encode ($password_get);
    // Execute the PowerShell script, passing the parameters:
    $query = shell_exec("powershell -command $script_path -email $email -password $password");
	echo "$query";
	die();
    } else {
	echo "FALSE";
    die();
    }
} else {
echo "FALSE";
die(); 
}
} else {
echo "FALSE";
die();
}
?>