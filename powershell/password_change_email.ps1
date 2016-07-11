.".\config.ps1"
.".\library.ps1"

#define cool down time for this whole run.
[int] $cooldown_period = get-date -UFormat %H
[array] $user_in_cool_down = $NULL
if($needs_email_creds) {

$password = get-content $creds_path | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $username,$password
}

$pending_users = mysql -query "select * from hashtable WHERE notified = 'FALSE'"
[array]$email_count = $NULL
foreach($user in $pending_users) {
$hash = $user.hash
$id = $user.id
$email_to = $user.email


$date = get-date -format s
$log = $NULL	
	if($sam = get-aduser -filter "$filter_object -eq '$email_to'" -prop $filter_object | select -expandproperty Samaccountname) {
    $email_count += "$email_to"
	$Allow_Email_Send = $True
    $hashstring = $hashstring_url + $hash
    $body = "Hello,<br>We have received a request to change your $company_name Active Directory password.<br> If you did not submit this request, you can disregard this message, or contact Helpdesk.<br>To change your password please <a href=""$hashstring"">click here</a><br>Thank you,<br>Helpdesk"
            
			
		foreach($protected_group in $protected_group_list) {
            if (($(get-adgroupmember "$protected_group" | select -expandproperty Samaccountname) -contains "$sam")) {
            $Allow_Email_Send = $False
			echo "$date,$email_to ($sam) was not sent because user is in a protected group" >> $log_path
            } 
        }
            
		if($limit_by_ou) {
		$ou_sam_allowed = $NULL
			foreach($ou in $Ou_allowed_list) {
			$ou_sam_allowed += get-aduser -filter * -searchbase $ou | select -expandproperty Samaccountname
			}	
			if(-not($ou_sam_allowed -contains "$sam")) {
			$Allow_Email_Send = $False
			echo "$date,$email_to ($sam) was not sent because user is not in the correct OU" >> $log_path
			}
		}
			
		if($limit_by_group) {
		$group_sam_allow = $NULL
			foreach($group in $group_allowed_list) {
			$group_sam_allow += get-adgroupmember "$group" | select -expandproperty Samaccountname
			}
			if (-not ($(get-adgroupmember "$group" | select -expandproperty Samaccountname) -contains "$sam")) {
			$Allow_Email_Send = $False
			echo "$date,$email_to ($sam) was not sent because user is missing from  an allowed group" >> $log_path
			}	 
		}

		if($Allow_Email_Send) {
			if($($email_count | group | Where-object {$_.Name | select-string $email_to}).count -le 1) {
               if($needs_email_creds) {
                Send-MailMessage -from $from -To $email_to -Subject $subject -bodyashtml($body) -smtpServer "$smtp" -port "$smtp_port" -credential $credentials -UseSsl
                } else {
                Send-MailMessage -from $from -To $email_to -Subject $subject -bodyashtml($body) -smtpServer "$smtp" -port "$smtp_port"
                }
                mysql -query "UPDATE hashtable SET notified = 'TRUE' WHERE `id` = $id;"
            } elseif($($email_count | group | Where-object {$_.Name | select-string $email_to}).count -ge $cooldown_threshold) {
            
            #put account on cool down something odd is happening and multiple emails are queueing.
			if(-not ($user_in_cool_down -contains $email_to)) {
				if($alert_on_cooldown_block) {
            
					if($needs_email_creds) {
					Send-MailMessage -from $from -To $alert_email -Subject $cooldown_subject -bodyashtml($cooldown_body) -smtpServer "$smtp" -port "$smtp_port" -credential $credentials -UseSsl
					} else {
					Send-MailMessage -from $from -To $alert_email -Subject $cooldown_subject -bodyashtml($cooldown_body) -smtpServer "$smtp" -port "$smtp_port"
					}
					echo "$body" >> $log_path 
				}
			echo "$hash, $cooldown_period, $email_to"
            mysql -query "UPDATE hashtable SET notified = 'COOLDOWN' WHERE `id` = $id;"
            mysql -query "INSERT INTO tempcooldown (cooldown_expire, emailaddress) VALUES ( ""$cooldown_period"", ""$email_to"")"
            $user_in_cool_down += "$email_to"
			} 
            } else {
            echo "$email_to ($sam) had multiple emails queued. This was bellow the cooldown threshhold of $cooldown_threshold so the account was not locked." >> $log_path
            mysql -query "UPDATE hashtable SET notified = 'FAIL' WHERE `id` = $id;"
            }
		
		echo "$date,$email_to ($sam) was sent a hash." >> $log_path
		} else {
		mysql -query "UPDATE hashtable SET notified = 'FAIL' WHERE `id` = $id;"
		}

	}  else {
	echo "$date,$email_to was not found in AD" >> $log_path
	mysql -query "UPDATE hashtable SET notified = 'FAIL' WHERE `id` = $id;"
	}
}

