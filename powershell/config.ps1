#Technical config:
#configure credential file
#read-host -assecurestring | convertfrom-securestring | out-file C:\scripts\cred.txt
$needs_email_creds = $true
$username = "ryan.langley4@gmail.com"

#URL for user to follow
$hashstring_url = "https://portal.test.local/portal/?hash="

#SMTP script to use
$smtp = "smtp.gmail.com"
$smtp_port = "587"

#Mysql Server and Userer info
$mysql_user = 'script'
$mysql_password = 'password'
$mysql_database = 'adportal'
$mysql_host = 'localhost'
$mysql_librarypath = ".\MySql.Data.dll"


#Email Customization:
$from = "ryan.langley4@gmail.com"
$subject= 'Password reset request'
$company_name = "Company"
#Groups that can not have password changed
$protected_group_list = ("Domain Admins")


