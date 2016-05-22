<?php
$user = "script";
$pass = "password";
$host = "localhost";
try {

    # MySQL with PDO_MYSQL
    $DBH = new PDO("mysql:host=$host;", $user, $pass);
    #$DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT );
    $DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );
    #$DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
}
catch(PDOException $e) {
    echo $e->getMessage();
}
?>

