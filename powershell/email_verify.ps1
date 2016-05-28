Param(
  [string]$emailaddress
  )
if(get-aduser -filter "EmailAddress -eq '$emailaddress'" -prop emailaddress) {
return "True"
} else {
return "False"
}