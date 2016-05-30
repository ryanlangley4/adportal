<?php
include "/includes/library.php";
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
	<div class="pageTitle"><strong>Ad Portal Password Setter</strong><br></div>
</div>

<?php

if(isset($_GET['hash'])) {
    $hash = $_GET['hash'];
    $query = $DBH->prepare('select * from hashtable WHERE hash LIKE :hash;');
    $query->bindParam(':hash', $hash);
    $query->execute();
    $obj = $query->fetchObject();
    $time_expire = $obj->time_expire;
    #deals with ackward clock roll over at 11pm & 12pm.. Maybe I'll think of a better way later
    if ((date('H') <= "$time_expire") || (date('H', strtotime('+2 hours')) == "$time_expire") || (date('H', strtotime('+1 hours')) == "$time_expire")) {
        echo "<div align=\"left\"><p>Basic Password compatability must be met or the process will need to be restarted<br>";
        echo "Passwords must not contain the user's entire samAccountName (Account Name) value or entire displayName (Full Name) value. Both checks are not case sensitive<br>";
        ?>
        Passwords must contain characters from three of the following five categories:<br />
        <ul>
        <li class="unordered">Uppercase characters of European languages (A through Z, with diacritic marks, Greek and Cyrillic characters)<br /><br /></li>
        <li class="unordered">Lowercase characters of European languages (a through z, sharp-s, with diacritic marks, Greek and Cyrillic characters)<br /><br /></li>
        <li class="unordered">Base 10 digits (0 through 9)<br /><br /></li>
        <li class="unordered">Nonalphanumeric characters: ~!@#$%^&amp;*_-+=`|\(){}[]:;"'&lt;&gt;,.?/<br /><br /></li>
        <li class="unordered">Any Unicode character that is categorized as an alphabetic character but is not uppercase or lowercase. This includes Unicode characters from Asian languages.<br /><br /></li></ul></li>
        </ul>
        <a href="https://technet.microsoft.com/en-us/library/cc786468(v=ws.10).aspx"><font color="blue">full requirements can be found here</font></a></p>
        </div>
        <?php
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