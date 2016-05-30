<?php
#DB info
$user = "script";
$pass = "password";
$host = "localhost";
$database = "adportal";

try {

    # MySQL with PDO_MYSQL
    $DBH = new PDO("mysql:host=$host;", $user, $pass);
    
    #$DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT );
    #$DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );
    $DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
    $DBH->query("use $database");
    
    
    }
catch(PDOException $e) {
    echo $e->getMessage();
}



function generateseed() {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+=';
    $charactersLength = strlen($characters);
    $seed_string = '';
    for ($i = 0; $i < 15; $i++) {
        $seed_string .= $characters[rand(0, $charactersLength - 1)];
    }
    return $seed_string;
}
?>

