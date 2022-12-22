Import-Module ActiveDirectory

# Get the current date and time
$now = Get-Date

# Get the date and time 3 days ago
$threeDaysAgo = $now.AddDays(-3)

# Get the Active Directory audited events from the security event log since 3 days ago
$events = Get-WinEvent -FilterXml "
  <QueryList>
    <Query Id='0' Path='Security'>
      <Select Path='Security'>*[System[(EventID=4738 or EventID=4739) and TimeCreated[timediff(@SystemTime) &lt;= 2592000000]]]</Select>
    </Query>
  </QueryList>" -MaxEvents 10000

# Loop through the events and display the event date and time, the object that was changed, and the change type
foreach ($event in $events) {
  $object = $event.Properties[1].Value
  $changeType = $event.Properties[2].Value
  Write-Output "Object changed at $($event.TimeCreated): $object ($changeType)"
}