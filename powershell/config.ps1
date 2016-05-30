#Technical config:
#configure credential file for email password
#read-host -assecurestring | convertfrom-securestring | out-file C:\scripts\cred.txt

#email credentials
$needs_email_creds = $true
$creds_path = ".\cred.txt"
$username = "username"

#URL for user to follow
#Https site is recomended.
$hashstring_url = "http://portal.test.local/portal/?hash="

#SMTP server to use
$smtp = "smtp.gmail.com"
$smtp_port = "587"

#Mysql Server and User info
$mysql_user = 'script'
$mysql_password = 'password'
$mysql_database = 'adportal'
$mysql_host = 'localhost'
$mysql_librarypath = ".\MySql.Data.dll"

#Active Directory value to search for the alternative email address in:
$filter_object = "EmailAddress"

#Email Customization:
$from = "helpdesk@example.com"
$subject= 'Password reset request'
$company_name = "Company"

#EmailAbuse
#This adjusts how many spammed messages are needed before the email is put on cool down and the user can not use the system for a while
$cooldown_period_hours = 1
$threshold = 5
$alert_email = "Helpdesk@company.com"

#Groups that can not have password changed
$protected_group_list = ("Domain Admins")

#Limitation by OU or group:
$limit_by_ou = $FALSE
$Ou_allowed_list = ("OU=ONBOARDING,DC=TEST,DC=LOCAL")
$limit_by_group = $FALSE
$Group_allowed_list = ("OnBoarding_Group")


#Where logs should be stored.
$log_path = ".\logs.txt"
