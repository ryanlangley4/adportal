Param(
  [string]$email,
  [string]$password
  )
  
$emailaddress = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($email))
$password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($password))
import-module ActiveDirectory
	$sam = get-aduser -filter "EmailAddress -eq '$emailaddress'" -prop emailaddress | select -expandproperty Samaccountname
		$SecPaswd= ConvertTo-SecureString -String $password -AsPlainText -Force
		try {
		unlock-Adaccount -identity "$sam"
		Set-Adaccountpassword -Reset -NewPassword $SecPaswd -identity $sam
		return "TRUE"
		} catch {
		return "FALSE"
		}