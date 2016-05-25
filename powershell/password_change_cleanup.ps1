
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
mysql -query "truncate table hashtable"
exit