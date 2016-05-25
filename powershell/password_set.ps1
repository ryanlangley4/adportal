Param(
  [string]$emailaddress,
  [string]$password
  )
import-module ActiveDirectory
	$sam = get-aduser -filter "EmailAddress -eq '$emailaddress'" -prop emailaddress | select -expandproperty Samaccountname
		$SecPaswd= ConvertTo-SecureString -String $password -AsPlainText -Force
		Set-Adaccountpassword -Reset -NewPassword $SecPaswd -identity $sam
		unlock-Adaccount -identity "$sam"
		return "TRUE"