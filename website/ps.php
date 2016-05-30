<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<?php
include "/includes/library.php";

echo "here";
if(isset($_GET["id"]) && isset($_GET["emailaddress"]) && isset($_GET["password"])) { 
echo "here";
$email_get = $_GET['emailaddress'];
$password_get = $_GET['password'];
$query = $DBH->prepare('select * from hashtable WHERE id EQUAL :id');
$query->bindParam(':id', $_GET['id'], PDO::PARAM_STR);
$query->execute();
$obj = $query->fetchObject();
$email = $obj->email;
$id = $obj->id;
$notified $obj->notified;

if(($notified == "TRUE") && ($email_get == $email)) {
    #deals with ackward clock roll over at 11pm & 12pm.. Maybe I'll think of a better way later
    if ((date('H') <= "$time_expire") || (date('H', strtotime('+2 hours')) == "$time_expire") || (date('H', strtotime('+1 hours')) == "$time_expire")) {

    // Execute the PowerShell script, passing the parameters:
    #$query = shell_exec("powershell -command $psScriptPath -email '$email' -password '$password' < NUL");
    #echo $query;
    echo "win";
    die();
    } else {
    echo "Fail";
    echo FALSE:
    die();
    }
} else {
    echo "Fail";
echo FALSE:
die(); 
}
} else {
    echo "Fail";
echo FALSE;    
die();
}
?>