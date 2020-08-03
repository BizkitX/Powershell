#Requires -version 2.0

# ***************************************************************************
# 
# File:      SCCM.psm1
#
# Version:   1.5
# 
# Author:    Michael Niehaus 
# 
# Purpose:   Provides a set of PowerShell advanced functions (cmdlets) to
#            interact with System Center Configuration Manager 2007.
#
#            This requires PowerShell 2.0.
#
# Usage:     Place this module into the proper PowerShell module folder.  By default
#            that would be one of these paths:
#              $home\Documents\WindowsPowerShell\Modules\SCCM\SCCM.psm1
#              $pshome\Modules\SCCM\SCCM.psm1
#            Once the file has been placed in one of these locations, then it can
#            be loaded simply by using the command:
#              import-module SCCM
#
#            After it has been imported, the indivual functions below can be
#            used.  For details on the parameters each one takes, you can
#            use "get-help", e.g. "get-help New-SCCMConnection".  Note that
#            there is no detailed help provided on the cmdlets.  Feel free to
#            add your own...
#
# Notes:     In this version, the Connect-SCCMServer cmdlet was renamed
#            to New-SCCMConnection, and Prune-SCCMDrivers was renamed to
#            Repair-SCCMDrivers to eliminate warnings that would occur
#            when using non-standard verbs.
#
# ------------- DISCLAIMER -------------------------------------------------
# This script code is provided as is with no guarantee or waranty concerning
# the usability or impact on systems and may be used, distributed, and
# modified in any way provided the parties agree and acknowledge the 
# Microsoft or Microsoft Partners have neither accountabilty or 
# responsibility for results produced by use of this script.
#
# Microsoft will not provide any support through any means.
# ------------- DISCLAIMER -------------------------------------------------
#
# ***************************************************************************

function New-SCCMConnection {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $serverName,
        [Parameter(Position=2)] $siteCode
    )


    # Clear the results from any previous execution

    Clear-Variable -name sccmServer -errorAction SilentlyContinue
    Clear-Variable -name sccmNamespace -errorAction SilentlyContinue
    Clear-Variable -name sccmSiteCode -errorAction SilentlyContinue
    Clear-Variable -name sccmConnection -errorAction SilentlyContinue


    # If the $serverName is not specified, use "."

    if ($serverName -eq $null -or $serverName -eq "")
    {
        $serverName = "."
    }


    # Get the pointer to the provider for the site code

    if ($siteCode -eq $null -or $siteCode -eq "")
    {
        Write-Verbose "Getting provider location for default site on server $serverName"
        $providerLocation = get-wmiobject -query "select * from SMS_ProviderLocation where ProviderForLocalSite = true" -namespace "root\sms" -computername $serverName -errorAction Stop
    }
    else
    {
        Write-Verbose "Getting provider location for site $siteName on server $serverName"
        $providerLocation = get-wmiobject -query "select * from SMS_ProviderLocation where SiteCode = '$siteCode'" -namespace "root\sms" -computername $serverName -errorAction Stop
    }


    # Split up the namespace path

    $parts = $providerLocation.NamespacePath -split "\\", 4
    Write-Verbose "Provider is located on $($providerLocation.Machine) in namespace $($parts[3])"
    $global:sccmServer = $providerLocation.Machine
    $global:sccmNamespace = $parts[3]
    $global:sccmSiteCode = $providerLocation.SiteCode


     # Make sure we can get a connection

    $global:sccmConnection = [wmi]"${providerLocation.NamespacePath}"
    Write-Verbose "Successfully connected to the specified provider"
}

function Get-SCCMObject {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $class, 
        [Parameter(Position=2)] $filter
    )

    if ($filter -eq $null -or $filter -eq "")
    {
        get-wmiobject -class $class -computername $sccmServer -namespace $sccmNamespace
    }
    else
    {
        get-wmiobject -query "select * from $class where $filter" -computername $sccmServer -namespace $sccmNamespace
    }
}

function Get-SCCMPackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_Package $filter
}

function Get-SCCMCollection {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_Collection $filter
}

function Get-SCCMAdvertisement {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_Advertisement $filter
}

function Get-SCCMDriver {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_Driver $filter
}

function Get-SCCMDriverPackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_DriverPackage $filter
}

function Get-SCCMTaskSequence {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_TaskSequence $filter
}

function Get-SCCMTaskSequencePackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_TaskSequencePackage $filter
}

function Get-SCCMSite {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_Site $filter
}

function Get-SCCMImagePackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_ImagePackage $filter
}

function Get-SCCMOperatingSystemInstallPackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_OperatingSystemInstallPackage $filter
}

function Get-SCCMBootImagePackage {

    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_BootImagePackage $filter
}

function Get-SCCMSiteDefinition {

    # Refresh the site control file

    Invoke-WmiMethod -path SMS_SiteControlFile -name RefreshSCF -argumentList $sccmSiteCode -computername $sccmServer -namespace $sccmNamespace


    # Get the site definition object for this site

    $siteDef = get-wmiobject -query "select * from SMS_SCI_SiteDefinition where SiteCode = '$sccmSiteCode' and FileType = 2" -computername $sccmServer -namespace $sccmNamespace


    # Return the Props list
    $siteDef | foreach-object { $_.Props }
}

function Get-SCCMIsR2 {

    $result = Get-SCCMSiteDefinition | ? {$_.PropertyName -eq "IsR2CapableRTM"}
    if (-not $result)
    {
        $false
    }
    elseif ($result.Value = 31)
    {
        $true
    }
    else
    {
        $false
    }
}

function Get-SCCMComputer
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $filter
    )

    Get-SCCMObject SMS_R_System $filter
}

function New-SCCMCollection
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $name, 
        [Parameter(Position=2)] $comment,
        [Parameter(Position=3)] [ValidateRange(0, 59)] [int] $refreshMinutes,
        [Parameter(Position=4)] [ValidateRange(0, 23)] [int] $refreshHours,
        [Parameter(Position=5)] [ValidateRange(0, 31)] [int] $refreshDays,
        [Parameter(Position=6)] $parentCollectionID
    )

    # Build the parameters for creating the collection
    $arguments = @{Name = $name; Comment = $comment; OwnedByThisSite = $true}
    $newColl = set-wmiinstance -class SMS_Collection -arguments $arguments -computername $sccmServer -namespace $sccmNamespace
    
    # Hack - for some reason without this we don't get the CollectionID value
    $hack = $newColl.PSBase | select * | out-null
    
    # It's really hard to set the refresh schedule via set-wmiinstance, so we'll set it later if necessary
    if ($refreshMinutes -gt 0 -or $refreshHours -gt 0 -or $refreshDays -gt 0)
    {
        # Create the recur interval object
        $intervalClass = [wmiclass]"\\$sccmServer\$($sccmNamespace):SMS_ST_RecurInterval"
        $interval = $intervalClass.CreateInstance()
        if ($refreshMinutes -gt 0)
        {
            $interval.MinuteSpan = $refreshMinutes
        }
        if ($refreshHours -gt 0)
        {
            $interval.HourSpan = $refreshHours
        }
        if ($refreshDays -gt 0)
        {
            $interval.DaySpan = $refreshDays
        }
        
        #  Set the refresh schedule
        $newColl.RefreshSchedule = $interval
        $newColl.RefreshType=2
        $path = $newColl.Put()
    }    
    
    # Build the parameters for the collection to subcollection link
    $subArguments = @{SubCollectionID = $newColl.CollectionID}
    if ($parentCollectionID -eq $null)
    {
        $subArguments += @{ParentCollectionID = "COLLROOT"}
    }
    else
    {
        $subArguments += @{ParentCollectionID = $parentCollectionID}
    }
    
    # Add the link
    $newRelation = set-wmiinstance -class SMS_CollectToSubCollect -arguments $subArguments -computername $sccmServer -namespace $sccmNamespace
    
    # Return the collection
    $newColl
}

function Add-SCCMCollectionRule
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(ValueFromPipelineByPropertyName=$true)] $collectionID,
        [Parameter(ValueFromPipeline=$true)] [String[]] $name,
        [Parameter()] $queryExpression,
        [Parameter()] $queryRuleName
    )
    
    Process
    {
    
        # Get the specified collection (to make sure we have the lazy properties)
    
        $coll = [wmi]"\\$sccmServer\$($sccmNamespace):SMS_Collection.CollectionID='$collectionID'"
    
        # Build the new rule
        if ($queryExpression -ne $null)
        {
            # Create a query rule
            $ruleClass = [wmiclass]"\\$sccmServer\$($sccmNamespace):SMS_CollectionRuleQuery"
            $newRule = $ruleClass.CreateInstance()
            $newRule.RuleName = $queryRuleName
            $newRule.QueryExpression = $queryExpression
            
            $null = $coll.AddMembershipRule($newRule)
        }
        else
        {
            $ruleClass = [wmiclass]"\\$sccmServer\$($sccmNamespace):SMS_CollectionRuleDirect"

            # Find each computer
            foreach ($n in $name)
            {
                foreach ($computer in get-SCCMComputer -filter "Name = '$n'")
                {
                    # See if the computer is already a member
                    $found = $false
                    if ($coll.CollectionRules -ne $null)
                    {
                        foreach ($member in $coll.CollectionRules)
                        {
                            if ($member.ResourceID -eq $computer.ResourceID)
                            {
                                $found = $true
                            }
                        }
                    }
                
                    if (-not $found)
                    {
                        Write-Verbose "Adding new rule for computer $n"
                        $newRule = $ruleClass.CreateInstance()
                        $newRule.RuleName = $n
                        $newRule.ResourceClassName = "SMS_R_System"
                        $newRule.ResourceID = $computer.ResourceID
            
                        $null = $coll.AddMembershipRule($newRule)
                    }
                    else
                    {
                        Write-Verbose "Computer $n is already in the collection"
                    }
                }
            }
        }
    }
}

function Import-SCCMComputer
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(ValueFromPipeline=$true)] $name,
        [Parameter(ValueFromPipeline=$true)] $macAddress,
        [Parameter(ValueFromPipeline=$true)] $uuid
    )
    
    Process
    {    
        # Build the argument list: AdminPassword, FQDN, IsAMTMachine, MAC Address, MEBx password, NetBIOS name, overwrite, SMBIOS UUID
        $arguments = @($null, $null, $false, $macAddress, $null, $name, $true, $uuid)

        # Invoke the method
        $result = Invoke-WmiMethod -path SMS_Site -name ImportMachineEntry -argumentList $arguments -computername $sccmServer -namespace $sccmNamespace

        # Retrieve and return the imported computer
        Get-SCCMComputer -filter "ResourceID = '$($result.ResourceID)'"
    }
}

function Get-SCCMDriverCategory
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $categoryName
    )

    # Build the appropriate filter to return all categories or just one specified by name
    $filter = "CategoryTypeName = 'DriverCategories'"
    if ($categoryName -eq "" -or $categoryName -eq $null)
    {
        Write-Debug "Retriving all categories"
    }
    else
    {
        $filter += " and LocalizedCategoryInstanceName = '" + $categoryName + "'"
    }

    # Retrieve the matching list
    Get-SCCMObject SMS_CategoryInstance -filter $filter
}

function New-SCCMDriverCategory
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $categoryName
    )

    # Create a SMS_Category_LocalizedProperties instance
    $localizedClass = [wmiclass]"\\$sccmServer\$($sccmNamespace):SMS_Category_LocalizedProperties"

    # Populate the localized settings to be used with the new driver instance
    $localizedSetting = $localizedClass.psbase.CreateInstance()
    $localizedSetting.LocaleID =  1033 
    $localizedSetting.CategoryInstanceName = $categoryName
    [System.Management.ManagementObject[]] $localizedSettings += $localizedSetting

    # Create the unique ID
    $categoryGuid = [System.Guid]::NewGuid().ToString()
    $uniqueID = "DriverCategories:$categoryGuid"

    # Build the parameters for creating the collection
    $arguments = @{CategoryInstance_UniqueID = $uniqueID; LocalizedInformation = $localizedSettings; SourceSite = $sccmSiteCode; CategoryTypeName = 'DriverCategories'}

    # Create the new instance
    set-wmiinstance -class SMS_CategoryInstance -arguments $arguments -computername $sccmServer -namespace $sccmNamespace
}

function New-SCCMDriverPackage
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $name, 
        [Parameter(Position=2)] $description,
        [Parameter(Position=3)] $sourcePath
    )

    # Build the parameters for creating the collection
    $arguments = @{Name = $name; Description = $description; PkgSourceFlag = 2; PkgSourcePath = $sourcePath}
    $newPackage = set-wmiinstance -class SMS_DriverPackage -arguments $arguments -computername $sccmServer -namespace $sccmNamespace
    
    # Hack - for some reason without this we don't get the PackageID value
    $hack = $newPackage.PSBase | select * | out-null
    
    # Return the package
    $newPackage
}

function Add-SCCMDriverPackageContent
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1)] $package,
        [Parameter(Position=2, ValueFromPipeline=$true)] $driver
    )

    Process
    {
        # Get the list of content IDs
        $idlist = @()
        $ci = $driver.CI_ID
        $ids = Get-SCCMObject -class SMS_CIToContent -filter "CI_ID = '$ci'"
        if ($ids -eq $null)
        {
            Write-Warning "Warning: Driver not found in SMS_CIToContent"
        }
        foreach ($id in $ids)
        {
            $idlist += $id.ContentID
        }

        # Build a list of content source paths (one entry in the array)
        $sources = @($driver.ContentSourcePath)

        # Invoke the method
        try
        {
            $package.AddDriverContent($idlist, $sources, $false)
        }
        catch [System.Management.Automation.MethodInvocationException]
        {
            $e = $_.Exception.GetBaseException()
            if ($e.ErrorInformation.ErrorCode -eq 1078462229)
            {
                Write-Verbose "Driver is already in the driver package (possibly because there are multiple INFs in the same folder or the driver already was added from a different location): $($e.ErrorInformation.Description)"
            }
        }
    }

}

function Import-SCCMDriver
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1, ValueFromPipelineByPropertyName=$true)][Alias("FullName","Path")] $infFile,
        [Parameter()] $categoryName,
        [Parameter()] $packageID
    )

    Process
    {
        # Split the path
        $driverINF = split-path $infFile -leaf 
        $driverPath = split-path $infFile

        # Get the category if specified
        if ($categoryName -eq "" -or $categoryName -eq $null)
        {
            Write-Verbose "No driver category specified"
        }
        else
        {
            $driverCategory = Get-SCCMDriverCategory -categoryName $categoryName
            if ($driverCategory -eq $null)
            {
                $driverCategory = New-SCCMDriverCategory $categoryName
                Write-Verbose "Created new driver category $categoryName"
            }
            $categoryID = $driverCategory.CategoryInstance_UniqueID
        }

        # Create the class objects needed
        $driverClass = [WmiClass]("\\$sccmServer\$($sccmNamespace):SMS_Driver")
        $localizedClass = [WmiClass]("\\$sccmServer\$($sccmNamespace):SMS_CI_LocalizedProperties")

        # Call the CreateFromINF method
        $driver = $null
        $InParams = $driverClass.psbase.GetMethodParameters("CreateFromINF")
        $InParams.DriverPath = $driverPath
        $InParams.INFFile = $driverINF
        try
        {
            $R = $driverClass.PSBase.InvokeMethod("CreateFromINF", $inParams, $Null)

            # Get the display name out of the result
            $driverXML = [XML]$R.Driver.SDMPackageXML
            $displayName = $driverXML.DesiredConfigurationDigest.Driver.Annotation.DisplayName.Text

            # Populate the localized settings to be used with the new driver instance
            $localizedSetting = $localizedClass.psbase.CreateInstance()
            $localizedSetting.LocaleID =  1033 
            $localizedSetting.DisplayName = $displayName
            $localizedSetting.Description = ""
            [System.Management.ManagementObject[]] $localizedSettings += $localizedSetting

            # Create a new driver instance (one tied to the right namespace) and copy the needed 
            # properties to it.
            $driver = $driverClass.CreateInstance()
            $driver.SDMPackageXML = $R.Driver.SDMPackageXML
            $driver.ContentSourcePath = $R.Driver.ContentSourcePath
            $driver.IsEnabled = $true
            $driver.LocalizedInformation = $localizedSettings
            $driver.CategoryInstance_UniqueIDs = @($categoryID)

            # Put the driver instance
            $null = $driver.Put()
        
            Write-Verbose "Added new driver."
        }
        catch [System.Management.Automation.MethodInvocationException]
        {
            $e = $_.Exception.GetBaseException()
            if ($e.ErrorInformation.ErrorCode -eq 183)
            {
                Write-Verbose "Duplicate driver found: $($e.ErrorInformation.ObjectInfo)"

                # Look for a match on the CI_UniqueID    
                $query = "select * from SMS_Driver where CI_UniqueID = '" + $e.ErrorInformation.ObjectInfo + "'"
                $driver = get-WMIObject -query $query.Replace("\", "/") -namespace $sccmNamespace
    
                # Set the category
                if (-not $driver)
                {
                    Write-Warning "Unable to import and no existing driver found."
                    return
                }
                elseif ($driver.CategoryInstance_UniqueIDs -contains $categoryID)
                {
                    Write-Verbose "Existing driver is already in the specified category."
                }
                else
                {
                    $driver.CategoryInstance_UniqueIDs += $categoryID
                    $null = $driver.Put()
                    Write-Verbose "Added category on existing driver."
                }
            }
            else
            {
                Write-Warning "Unexpected error, skipping INF $($infFile): $($e.ErrorInformation.Description) $($e.ErrorInformation.ErrorCode)"
                return
            }
        }

        # If a package was specified, add the driver to it
        if ($packageID -ne $null)
        {
            $package = Get-SCCMDriverPackage -filter "PackageID = '$packageID'"
            Write-Verbose "Adding driver $($driver.LocalizedDisplayName) to package $($package.Name)"
            $null = Add-SCCMDriverPackageContent -package $package -driver $driver
        }

        # Hack - for some reason without this we don't get the CollectionID value
        $hack = $driver.PSBase | select * | out-null

        # Write the driver object to the pipeline
        $driver
    }
}


function Set-SCCMComputerVariable
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(Position=1, ValueFromPipeline=$true)] $computer,
        [Parameter(Position=2)] $name,
        [Parameter(Position=3)] $value,
        [Parameter(Position=4)] $masked
    )

    # See if there is an existing SMS_MachineSettings instance.  If not, create one.
    $machineSettings = Get-SCCMObject -class SMS_MachineSettings -filter "ResourceID = $($computer.ResourceID)"
    if ($machineSettings -eq $null)
    {
        # Build the parameters for creating the machine settings
        $arguments = @{ResourceID = $computer.ResourceID; SourceSite = $sccmSiteCode; LocaleID = 1033}

        # Create the new instance
        $machineSettings = set-wmiinstance -class SMS_MachineSettings -arguments $arguments -computername $sccmServer -namespace $sccmNamespace

        # Re-get it
        $machineSettings = Get-SCCMObject -class SMS_MachineSettings -filter "ResourceID = $($computer.ResourceID)"
    }

    # See if there is already a variable for this computer
    foreach ($v in $machineSettings.MachineVariables)
    {
        Write-Host $v.Name
    }

    # Create a new computer variable instance
    $variableClass = [wmiclass]"\\$sccmServer\$($sccmNamespace):SMS_MachineVariable"
    $variable = $variableClass.CreateInstance()
    $variable.Name = $name
    $variable.Value = $value
    $variable.IsMasked = $masked

    # Add it to the array
    $machineSettings.MachineVariables += $variable

    # Save the updated machine settings
    $machineSettings.Put()
}

function Repair-SCCMDriver
{
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    param
    (
    )

    Process
    {
        if ($pscmdlet.ShouldProcess("All SCCM drivers with invalid paths"))
        {
            Write-Host "The following drivers have been removed:"
            Get-SCCMDriver | ? {-not (Test-Path $_.ContentSourcePath)} | remove-SCCMDriver
        }
        else
        {
            Write-Host "The following drivers have invalid paths and would have been removed:"
            Get-SCCMDriver | ? {-not (Test-Path $_.ContentSourcePath)} | ft LocalizedDisplayName, ContentSourcePath
        }
    }
}

function New-SCCMPackageDP
{
    [CmdletBinding()]
    PARAM
    (
        [Parameter(ValueFromPipelineByPropertyName=$true, Position=1)] $PackageID, 
        [Parameter(ValueFromPipelineByPropertyName=$true, Position=2)] $NALPath,
        [Parameter(ValueFromPipelineByPropertyName=$true, Position=3)] $siteCode
    )
    
    process
    {
        # Get the site name
        if ($siteCode -eq $null -or $siteCode -eq "")
        {
            $siteCode = $sccmSiteCode
        }
        $site = Get-SCCMObject SMS_Site "SiteCode='$siteCode'"
        $siteName = $site.SiteName

        # Build the parameters for creating the collection
        $arguments = @{PackageID = $PackageID; ServerNALPath = "$NALPath"; SiteCode = $siteCode; SiteName = "$siteName"}
        $newDP = set-wmiinstance -class SMS_DistributionPoint -arguments $arguments -computername $sccmServer -namespace $sccmNamespace -ErrorAction SilentlyContinue

        # Return the DP object if it isn't null
        if ($newDP -ne $null)
        {
            $newDP
        }
    }
}
                                                                        