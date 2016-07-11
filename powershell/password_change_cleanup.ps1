.".\config.ps1"
.".\library.ps1"

Try {
import-module ActiveDirectory
} Catch {
echo "Error Loading module: $_"
}

mysql -query "truncate table hashtable"
mysql -query "truncate table tempcooldown"
exit