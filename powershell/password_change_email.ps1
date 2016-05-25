$from = "helpdesk@company.com"
$pending_users = mysql_send -query "select * from hashtable"
$subject= "Password reset request"
$hashstring_url = "https://portal.tankedgenius.com/?hash=$hash"
$protected_group_list = "Domain Admins"


$mysql_user = 'script'
$mysql_password = '<password>'
$mysql_database = 'adportal'
$mysql_host = 'localhost'
$mysql_librarypath = ".\MySql.Data.dll"

Try {
import-module ActiveDirectory
} Catch {
echo "Error Loading module"
}

function mysql()
{
Param(
  [Parameter(
  Mandatory = $true,
  ParameterSetName = '',
  ValueFromPipeline = $true)]
  [string]$query
  )

$connection_string = "server=" + $mysql_host + ";port=3306;uid=" + $mysql_user + ";pwd=" + $mysql_password + ";database="+$mysql_database

Try {

  Add-Type -Path $mysql_librarypath
  $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
  $connection.ConnectionString = $connection_string
  $connection.Open()

  $sql_command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
  $connector_adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($sql_command)
  $dataset = New-Object System.Data.DataSet
  $recordcount = $dataAdapter.Fill($dataSet, "data")
  $dataset.Tables[0]
  }

Catch {
  #echo "ERROR : Unable to run query : $query `n$Error[0]"
  echo "ERROR : Unable to run query $query [truncated error]"
  sleep 1
 }

Finally {
  $Connection.Close()
  }
  
}

foreach($user in $pending_users) {
$hash = $user.hash
$id = $user.id
$email_to = $user.email

	if(get-aduser -filter "EmailAddress -eq '$email_to'" -prop emailaddress) {
	$sam = get-aduser -filter "EmailAddress -eq '$email_to'" -prop emailaddress | select -expandproperty Samaccountname
    $body = "Hello,<br>We have received a request to change your $company_name Active Directory password.<br>"
		if($user.notified -eq "FALSE") {
			foreach($protected_group in $protected_group_list) {
            if ((get-adgroupmember "$protected_group" | select -expandproperty Samaccountname | select-string $sam)) {
				$body += "However your account is part of a protected group. If you did not submit this request, you can disregard this message, or contact Helpdesk if you think this error is incorrect.<br><br>Thank you,<br>Helpdesk"
				} else {
				$body += "If you did not submit this request, you can disregard this message, or contact Helpdesk.<br>To change your password please <a href=$hashstring>click here</a><br>Thank you,<br>Helpdesk"
				}
            Send-MailMessage -from $from -To $email_to -Subject $subject -bodyashtml($body) -smtpServer "$smtp"
            }
        }
	} else {
		echo "User was not found in AD: $email_to" >> C:\scripts\email_logs.log
	}

mysql -query "UPDATE hashtable SET notified = 'TRUE' WHERE `id` = $id;"
}

exit