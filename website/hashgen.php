<?php
include "/includes/db_pdo.php";

if(isset($_POST['email'])) {
	$email = $_POST['email'];
	if(filter_var($email, FILTER_VALIDATE_EMAIL)) {
	
			$seed = rand(0, 1000);
			$seed = $seed+$email+mktime();
			$time_expire = date("h");
			$time_expire += "2";
			$hash = hash('ripemd160', "$seed");
			$query = $DBH->prepare('INSERT INTO hashtable (hash, time_expire, email) VALUES ( :hash, :time_expire, :email);');
			$query->bindvalue(':hash',"$hash");
			$query->bindvalue(':time_expire',"$time_expire");
			$query->bindvalue(':email',"$email");
			$query->execute();
			echo "Thank you.<br> An email with a 1 time hash code will be sent to <b>$email</b>.<br>If you <b>do not</b> get the email in 10 minutes or have any questions/concerns please contact you admin";
			die();
		
		
	} else {
		echo "I am sorry I don't recognize <b>$email</b> as a valid email address.";
		echo "Please <a href=\"index.php\">try again<br></a>, or contact your administrator";
	die();
	}
} elseif(isset($_POST['password'])  && (isset($_POST['hash']))) {
	$hash = $_POST['hash'];
	$password = $_POST['password'];
	$query = $DBH->prepare('select * from hashtable WHERE hash LIKE :hash;');
	$query->bindParam(':hash', $hash, PDO::PARAM_STR);
	$query->execute();
	$obj = $query->fetchObject();
	$email = $obj->email;
	$id = $obj->id;
	if($id != "") {
		#$query = $DBH->prepare('delete from pass_setter.hashtable WHERE id LIKE :id;');
		#$query->bindParam(':id', $id, PDO::PARAM_STR);
		#$query->execute();
		echo "You will recieve an email shortly confirming your password change.";
		die();
	} else {
		echo "The hash has expired.<br>";
		echo "Please <a href=\"index.php\">try again</a>, or contact your administrator";
		die();
	}
} else {
	echo "Error, I am not sure what you are attempting to do.<br>";
	echo "Please <a href=\"index.php\">try again</a>, or contact your administrator";
	die();
}

?>