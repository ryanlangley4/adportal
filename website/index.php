<?php
include "/includes/db_pdo.php";
?>
<html>
<head>
<title>Set account Password</title>
<link href="/style/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body link='#FFFFFF' vlink='#FFFFFF'>      
<div id="pageWrap" align="center">

    <div id="header">
    <div class="logo"><img src="/style/images/logo.gif" width="158" height="54" alt="Logo"><bR><span style ="font-family: Arial, Helvetica, sans-serif;	font-size: 14px; color:#000000;"></span></div>
	<div class="pageTitle"><strong>Password setter</strong><br></div>
</div>

<?php
if(isset($_GET['hash'])) {
    $hash = $_GET['hash'];
    $query = $DBH->prepare('select * from hashtable WHERE hash LIKE :hash;');
    $query->bindParam(':hash', $hash, PDO::PARAM_STR);
    $query->execute();
    $obj = $query->fetchObject();
    $time_expire = $obj->time_expire;
        
    if(date("h") <= "$time_expire") {
        echo "<center><p>Please enter your new password:<br></p>";
        echo "<form name=\"hashgenerate\" action=\"hashgen.php\" method=\"post\">";
		echo "<input type=\"password\" name=\"password\" style=\"width: 300px;\">";
		echo "<input type=\"hidden\" name=\"hash\" value=\"$hash\">";
		echo "<input type=\"submit\" value=\"submit\">";
		echo "</form></center>";
		die();
    } else {
        echo "I'm sorry your hash key has expired.";
        echo "Please <a href=\"/index.php\"  style=\"color:blue\">try again<br><br><br><br><br><br><br>";
        die();
    }
} else {
    echo "<center><p>Please enter your email address to receive a link containing your one time hash<br></p>";
    echo "<form name=\"hashgenerate\" action=\"hashgen.php\" method=\"post\">";
    echo "<input type=\"text\" name=\"email\" style=\"width: 300px;\" placeholder=\"user@example.com\">";
	echo "<input type=\"submit\" value=\"submit\">";
	echo "</form></center>";
}
?>
<div id="footer">  <div><span style ="font-family: Arial, Helvetica, sans-serif;	font-size: 14px; color:#000000;">
</body>
</html>