.".\config.ps1"
.".\include.ps1"


if($needs_email_creds) {

$password = get-content C:\scripts\cred.txt | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $username,$password
}

$pending_users = mysql -query "select * from hashtable"

foreach($user in $pending_users) {
$hash = $user.hash
$id = $user.id
$email_to = $user.email

	if(get-aduser -filter "EmailAddress -eq '$email_to'" -prop emailaddress) {
	$sam = get-aduser -filter "EmailAddress -eq '$email_to'" -prop emailaddress | select -expandproperty Samaccountname
    $hashstring = $hashstring_url + $hash
    $body = "Hello,<br>We have received a request to change your $company_name Active Directory password.<br>"
		if($user.notified -eq "FALSE") {
        $protected = $TRUE
			foreach($protected_group in $protected_group_list) {
            
                if ((get-adgroupmember "$protected_group" | select -expandproperty Samaccountname | select-string $sam)) {
                $protected = $TRUE
                } else {
                $protected = $FALSE
                }
            }
            
            if($protected) {
            $body += "However your account is part of a protected group. If you did not submit this request, you can disregard this message, or contact Helpdesk if you think this error is incorrect.<br><br>Thank you,<br>Helpdesk"
            } else {
            $body += "If you did not submit this request, you can disregard this message, or contact Helpdesk.<br>To change your password please <a href=""$hashstring"">click here</a><br>Thank you,<br>Helpdesk"
            }
            
            echo "To $email_to FROM: $from $subject $body"
            
            if($needs_email_creds) {
            Send-MailMessage -from $from -To $email_to -Subject $subject -bodyashtml($body) -smtpServer "$smtp" -port "$smtp_port" -credential $credentials -UseSsl
            } else {
            Send-MailMessage -from $from -To $email_to -Subject $subject -bodyashtml($body) -smtpServer "$smtp" -port "$smtp_port"
            }
        mysql -query "UPDATE hashtable SET notified = 'TRUE' WHERE `id` = $id;"
        }
    } else {
	echo "User was not found in AD: $email_to"
	}
}
