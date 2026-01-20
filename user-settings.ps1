Function UserMenu{
    Write-Host "`n          User Settings              " -ForegroundColor Black -BackgroundColor Green
    Write-Host "-----------------------------------------" -ForegroundColor Black
    Write-Host "1) Start user injection into AD      " -ForegroundColor green -BackgroundColor Black
    Write-Host "2) Start user injection into Entra             " -ForegroundColor green -BackgroundColor Black
    Write-Host "3) Configure injections (do this if running first time)            " -ForegroundColor green -BackgroundColor Black
    Write-Host "4) Back to main                " -ForegroundColor green -BackgroundColor Black
    Write-Host "-----------------------------------------" -ForegroundColor Black
    Write-Host "`n"
}

Function ConfigureInjections{
    Write-Output "You will now be asked a series of questions. These questions will determine what data will be used in the injections."
    $departmentListNumber = [int](Read-Host "How many departments do you have that you would like to inject into?")
    $departmentList = [System.Collections.ArrayList]::new()
    
    For ($i = 1; $i -le $departmentListNumber; $i++) {
        $departmentInput = Read-Host "Enter in department name #$i and press ENTER"
        [void]$departmentList.Add($departmentInput)
    }
    Write-Output "`nDepartments configured:"
    
    $departmentList | ForEach-Object { Write-Output "- $_" }
    Write-Host "PLEASE REMEMBER THE DEPARTMENT AND WHAT NUMBER IT IS ON THE LIST. YOU WILL NEED THIS FOR LATER!" -ForegroundColor White -BackgroundColor Red

    $positionListNumber = [int](Read-Host "`nHow many positions would you like to create?")
    $positionList = [System.Collections.ArrayList]::new()
    $positionAssociation = [System.Collections.ArrayList]::new()
    
    For ($i = 1; $i -le $positionListNumber; $i++) {
        $positionInput = Read-Host "Enter in position name #$i and press ENTER"
        $positionAssociationInput = [int](Read-Host "Enter the department number associated and press ENTER")
        [void]$positionList.Add($positionInput)
        [void]$positionAssociation.Add($positionAssociationInput)
    }
    Write-Output "`nPositions configured:"
    $departmentList | ForEach-Object { Write-Output "- $_" }

    $managerList = [System.Collections.ArrayList]::new()

    ForEach($manager in $departmentList){
        $managerName = Read-Host "`nFor each department supply a manager name"
        [void]$managerList.Add($managerName)
    }
    Write-Output "`nManagers configured:"
    $managerList | ForEach-Object { Write-Output "- $_" }

    $officeListNumber = [int](Read-Host "`nHow office locations would you like to create?")
    $officeList = [System.Collections.ArrayList]::new()
    
    For ($i = 1; $i -le $positionListNumber; $i++) {
        $officeInput = Read-Host "Enter in position name #$i and press ENTER"
        [void]$officeList.Add($officeInput)
    }
    Write-Output "`nOffices configured:"
    $officeList | ForEach-Object { Write-Output "- $_" }
    Write-Host "PLEASE REMEMBER THE OFFICE AND WHAT NUMBER IT IS ON THE LIST. YOU WILL NEED THIS FOR LATER!" -ForegroundColor White -BackgroundColor Red

    $areaCodeList = [System.Collections.ArrayList]::new()
    $areaCodeAssociation = [System.Collections.ArrayList]::new()
    
    For ($i = 0; $i -lt $officeList.Count; $i++) {
        $areaCodeInput = Read-Host "Enter in area code for $($officeList[$i]) and press ENTER"
        $areaCodeAssociationInput = $i + 1  # Store 1-based index
        [void]$areaCodeList.Add($areaCodeInput)
        [void]$areaCodeAssociation.Add($areaCodeAssociationInput)
    }   
    Write-Output "`nArea codes configured:"
    $areaCodeList | ForEach-Object { Write-Output "- $_" }

    $centralOfficeCodeList = [System.Collections.ArrayList]::new()
    $centralOfficeCodeAssociation = [System.Collections.ArrayList]::new()

    
    For ($i = 0; $i -lt $officeList.Count; $i++) {
        $centralOfficeCodeInput = Read-Host "Enter in central office code for $($officeList[$i]) and press ENTER"
        $centralOfficeAssociationInput = $i + 1
        [void]$centralOfficeCodeList.Add($centralOfficeCodeInput)
        [void]$centralOfficeCodeAssociation.Add($centralOfficeAssociationInput)
    }

    Write-Output "`nCentral office codes configured:"
    $centralOfficeCodeList | ForEach-Object { Write-Output "- $_" }

    $LicenseListNumber = [int](Read-Host "`nHow many licenses would you like to create?")
    $LicenseList = [System.Collections.ArrayList]::new()
    

    For ($i = 1; $i -le $LicenseListNumber; $i++) {
        $LicenseListInput = Read-Host "Enter in the EXACT name of the license and press ENTER"
        [void]$LicenseList.Add($LicenseListInput)

    }
    Write-Output "`nLicenses configured:"
    $LicenseList | ForEach-Object { Write-Output "- $_" }

    # RBAC Role Configuration
    $RBACRoleListNumber = [int](Read-Host "`nHow many RBAC roles would you like to configure?")
    $RBACRoleList = [System.Collections.ArrayList]::new()
    $RBACRoleAssociations = [System.Collections.ArrayList]::new()
    
    For ($i = 1; $i -le $RBACRoleListNumber; $i++) {
        $RBACRoleInput = Read-Host "Enter the EXACT name of RBAC role #$i and press ENTER"
        [void]$RBACRoleList.Add($RBACRoleInput)
        
        Write-Output "`nCurrent Positions:"
        For ($j = 0; $j -lt $positionList.Count; $j++) {
            Write-Output "$($j + 1)) $($positionList[$j])"
        }
        
        $associatedPositions = Read-Host "Enter position numbers that should have this role (comma-separated, e.g., 1,3,4)"
        [void]$RBACRoleAssociations.Add($associatedPositions)
    }
    
    Write-Output "`nRBAC Roles configured:"
    For ($i = 0; $i -lt $RBACRoleList.Count; $i++) {
        $role = $RBACRoleList[$i]
        $associations = $RBACRoleAssociations[$i]
        Write-Output "- $role assigned to position(s): $associations"
    }

    # AD OU Configuration (for on-premises Active Directory)
    Write-Output "`n--- Active Directory OU Configuration (Optional) ---"
    $ouConfigChoice = Read-Host "Would you like to configure specific OUs for AD user creation by department? (Y/N)"
    $OUList = [System.Collections.ArrayList]::new()
    $OUAssociations = [System.Collections.ArrayList]::new()
    
    if ($ouConfigChoice -eq 'Y') {
        Write-Output "`nCurrent Departments:"
        For ($j = 0; $j -lt $departmentList.Count; $j++) {
            Write-Output "$($j + 1)) $($departmentList[$j])"
        }
        
        For ($i = 0; $i -lt $departmentList.Count; $i++) {
            $ouInput = Read-Host "Enter the OU path for department '$($departmentList[$i])' (e.g., OU=Sales,OU=Users,DC=domain,DC=local) or press ENTER to skip"
            if ($ouInput.Trim() -ne '') {
                [void]$OUList.Add($ouInput)
                [void]$OUAssociations.Add($i + 1) # Store 1-based index
            } else {
                [void]$OUList.Add("")
                [void]$OUAssociations.Add($i + 1)
            }
        }
        
        Write-Output "`nOU Configuration for Departments:"
        For ($i = 0; $i -lt $departmentList.Count; $i++) {
            $ouPath = $OUList[$i]
            if ($ouPath -ne '') {
                Write-Output "- $($departmentList[$i]): $ouPath"
            } else {
                Write-Output "- $($departmentList[$i]): (default OU)"
            }
        }
    } else {
        Write-Output "Skipping OU configuration. All users will be created in the specified OU."
    }

    Write-Output "`nPlease select the UPN format from the list below:"
    Write-Output "1) first.lastname@companyname.com"
    Write-Output "2) lastname.firstname@companyname.com"
    Write-Output "3) firstinitiallastname@companyname.com"
    Write-Output "4) lastinitialfirstinitial@companyname.com"

    $UPNFormat = [int](Read-Host "Select a number and press ENTER")
    
    Write-Output "`nPlease review the inputs below and confirm if accurate:"
    Write-Output $departmentList
    Write-Output $positionList
    Write-Output $managerList
    Write-Output $officeList
    Write-Output $areaCodeList
    Write-Output $centralOfficeCodeList
    #Write-Output $LicenseList
    Write-Output $UPNFormat

    $confirmation = Read-Host 'Y/N:'

    if($confirmation -eq "Y"){
        $info = @"
        DepartmentList: $($departmentList -join '|')
        DepartmentAssociations: $($positionAssociation -join '|')
        PositionList: $($positionList -join '|')
        PositionAssociation: $($positionAssociation -join '|')
        ManagerList: $($managerList -join '|')
        OfficeList: $($officeList -join '|')
        AreaCodeList: $($areaCodeList -join '|')
        CentralOfficeCodeList: $($centralOfficeCodeList -join '|')
        AreaCodeAssociation: $($areaCodeAssociation -join '|')
        CentralOfficeAssociation: $($centralOfficeCodeAssociation -join '|')
        RBACRoleList: $($RBACRoleList -join '|')
        RBACRoleAssociations: $($RBACRoleAssociations -join '|')
        OUList: $($OUList -join '|')
        OUAssociations: $($OUAssociations -join '|')

        UPNFormat: $UPNFormat

"@

        $path = Read-Host "Enter a PATH (.txt) and press ENTER"
        $info | Out-File -FilePath $path -Encoding UTF8
    }


    elseif ($confirmation -eq "N") {
        ConfigureInjections
    }
    
}

Function ADUserInjection {
    # Check for Active Directory module (robust handling across Server/Workstation)
    $adModule = Get-Module -ListAvailable -Name ActiveDirectory
    if (-not $adModule) {
        Write-Warning "Active Directory PowerShell module not found."
        # Try to import in case it's installed but not loaded
        try { Import-Module ActiveDirectory -ErrorAction Stop; $adModule = Get-Module -Name ActiveDirectory } catch {}
    }

    if (-not $adModule) {
        Write-Host "The ActiveDirectory module is required to create AD users on-premises." -ForegroundColor Yellow
        Write-Host "You can attempt an automatic install (requires admin) or install RSAT manually." -ForegroundColor Yellow
        Write-Host "Options:`n1) Attempt automatic install (will try Server and RSAT methods)`n2) Show manual install instructions and abort`n3) Abort now" -ForegroundColor Cyan
        $installChoice = Read-Host "Choose 1, 2 or 3"

        if ($installChoice -eq '1') {
            # Detect Server vs Workstation and try appropriate install method
            try { $productType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType } catch { $productType = $null }
            # ProductType: 1 = Workstation, 3 = Server
            if ($productType -eq 3) {
                try {
                    Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubFeature -ErrorAction Stop
                    Import-Module ActiveDirectory -ErrorAction Stop
                    Write-Host "Installed and imported ActiveDirectory module (Server)." -ForegroundColor Green
                    $adModule = Get-Module -Name ActiveDirectory
                } catch {
                    Write-Warning "Server install attempt failed: $_"
                }
            } else {
                try {
                    Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" -ErrorAction Stop
                    Import-Module ActiveDirectory -ErrorAction Stop
                    Write-Host "Installed and imported ActiveDirectory module (RSAT)." -ForegroundColor Green
                    $adModule = Get-Module -Name ActiveDirectory
                } catch {
                    Write-Warning "RSAT install attempt failed: $_"
                }
            }

            if (-not $adModule) {
                Write-Error "Automatic installation did not succeed. See manual instructions below and re-run the function when module is available."
                Write-Host "Manual install instructions:" -ForegroundColor Cyan
                Write-Host " - On Windows Server: run as Administrator and install the 'RSAT-AD-PowerShell' server role or use Server Manager." -ForegroundColor Cyan
                Write-Host " - On Windows 10/11: Settings -> Optional features -> Add a feature -> 'RSAT: Active Directory' OR run:`n   Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'" -ForegroundColor Cyan
                return
            }

        } elseif ($installChoice -eq '2') {
            Write-Host "Manual install instructions:" -ForegroundColor Cyan
            Write-Host " - On Windows Server: run as Administrator and install the 'RSAT-AD-PowerShell' role or use Server Manager." -ForegroundColor Cyan
            Write-Host " - On Windows 10/11: Settings -> Optional features -> Add a feature -> 'RSAT: Active Directory' OR run:`n   Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'" -ForegroundColor Cyan
            return
        } else {
            Write-Host "Aborting AD user creation." -ForegroundColor Yellow
            return
        }
    }

    # Final attempt to import the module (ensures Import-Module is only called when available)
    try {
        Import-Module ActiveDirectory -ErrorAction Stop
    } catch {
        Write-Error "ActiveDirectory module is still not available. Aborting. Error: $_"
        return
    }

    $injectionFile = Read-Host "Enter in the full PATH to the injection file and press ENTER"
    Write-Output "`nPlease confirm that the following parameters are correct:`n"
    Get-Content $injectionFile

    $confirmation = Read-Host "`nIs the information correct (Y/N)?"

    if($confirmation -eq "Y"){
        # Read the config file
        $configLines = Get-Content $injectionFile

        # Create a hashtable to store parsed values
        $config = @{}

        foreach ($line in $configLines) {
            # Skip empty lines or lines without a colon
            if ([string]::IsNullOrWhiteSpace($line) -or $line.IndexOf(':') -eq -1) {
                continue
            }
            
            # Split into key and value
            $parts = $line -split ":", 2
            if ($parts.Count -lt 2) {
                continue
            }
            
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            
            # Skip if key or value is empty
            if ([string]::IsNullOrWhiteSpace($key) -or [string]::IsNullOrWhiteSpace($value)) {
                continue
            }

            # If it's UPNFormat (single value), store as-is
            if ($key -eq "UPNFormat") {
                $config[$key] = [int]$value
            } else {
                # Otherwise split by pipe and store as array
                $config[$key] = $value -split "\|" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            }
        }

        # Parse configuration values
        $DepartmentList = $config["DepartmentList"]
        $DepartmentAssociations = $config["DepartmentAssociations"]
        $PositionList = $config["PositionList"]
        $PositionAssociation = $config["PositionAssociation"]
        $ManagerList = $config["ManagerList"]
        $OfficeList = $config["OfficeList"]
        $AreaCodeList = $config["AreaCodeList"]
        $CentralOfficeCodeList = $config["CentralOfficeCodeList"]
        $AreaCodeAssociation = $config["AreaCodeAssociation"]
        $CentralOfficeAssociation = $config["CentralOfficeAssociation"]
        $OUList = $config["OUList"]
        $OUAssociations = $config["OUAssociations"]
        $UPNFormat = $config["UPNFormat"]

        Write-Output "`nParsed Configuration:"
        Write-Output "Departments: $($DepartmentList -join ', ')"
        Write-Output "Positions: $($PositionList -join ', ')"
        Write-Output "Managers: $($ManagerList -join ', ')"
        Write-Output "Offices: $($OfficeList -join ', ')"
        Write-Output "UPN Format: $UPNFormat"
        if ($OUList -and $OUList[0]) {
            Write-Output "OUs configured: Yes"
        }

        $numberOfUsers = Read-Host "`nSpecify number of users and press ENTER"
        $domain = Read-Host "Specify the domain you want to use for the UPN (e.g., domain.local) and press ENTER"
        $defaultOUPath = Read-Host "Specify the default OU path where users should be created (e.g., OU=Users,DC=domain,DC=local) and press ENTER"
        
        # Validate default OU path
        try {
            if (-not (Get-ADOrganizationalUnit -Identity $defaultOUPath)) {
                Write-Error "Default OU path not found. Please check the path and try again."
                return
            }
        } catch {
            Write-Error "Invalid default OU path: $_"
            return
        }
        
        # Validate configured OUs (if any)
        if ($OUList) {
            foreach ($ou in $OUList | Where-Object { $_ -ne '' }) {
                try {
                    if (-not (Get-ADOrganizationalUnit -Identity $ou)) {
                        Write-Error "Configured OU path not found: $ou"
                        return
                    }
                } catch {
                    Write-Error "Invalid configured OU path: $ou - Error: $_"
                    return
                }
            }
        }

        # Load name lists
        $firstNames = ((Get-Content "first-names.txt") -join "") -split "," | Where-Object { $_.Trim() -ne "" }
        $lastNames = ((Get-Content "last-names.txt") -join "") -split "," | Where-Object { $_.Trim() -ne "" }

        if (-not $firstNames) { Write-Error "First name list is empty or failed to load." ; return }
        if (-not $lastNames) { Write-Error "Last name list is empty or failed to load." ; return }

        # Show sample user
        Write-Output "`nThis is what a sample user will appear like, please review:"
        $randomFirstName = ($firstNames | Get-Random) -replace '["]', ''
        $randomLastName = ($lastNames | Get-Random) -replace '["]', ''
        $Department = $DepartmentList | Get-Random
        $Office = $OfficeList | Get-Random

        Write-Host "First Name:" $randomFirstName
        Write-Host "Last Name:" $randomLastName
        Write-Host "Department:" $Department
        Write-Host "Office:" $Office

        $confirmation = Read-Host "`nContinue? (Y/N)"

        if ($confirmation -eq "Y") {
            for ($i = 1; $i -le $numberOfUsers; $i++) {
                # Generate user details
                $FirstName = ($firstNames | Get-Random) -replace '["]', ''
                $LastName = ($lastNames | Get-Random) -replace '["]', ''
                
                # Position and department
                $positionIndex = Get-Random -Minimum 0 -Maximum $PositionList.Count
                $Position = $PositionList[$positionIndex]
                $deptIndexRaw = $PositionAssociation[$positionIndex]
                $Department = if ($deptIndexRaw) { $DepartmentList[[int]$deptIndexRaw - 1] } else { "Unassigned" }
                
                # Determine OU based on department
                $userOUPath = $defaultOUPath
                if ($OUList -and $deptIndexRaw) {
                    $deptIndex = [int]$deptIndexRaw - 1
                    if ($deptIndex -lt $OUList.Count -and $OUList[$deptIndex] -ne '') {
                        $userOUPath = $OUList[$deptIndex]
                    }
                }
                
                # Manager
                $Manager = $ManagerList[[int]$deptIndexRaw - 1]
                
                # Office and phone
                $officeIndex = Get-Random -Minimum 0 -Maximum $OfficeList.Count
                $Office = $OfficeList[$officeIndex]
                $areaCodeIndex = [int]$AreaCodeAssociation[$officeIndex] - 1
                $centralCodeIndex = [int]$CentralOfficeAssociation[$officeIndex] - 1
                $AreaCode = $AreaCodeList[$areaCodeIndex]
                $CentralOfficeCode = $CentralOfficeCodeList[$centralCodeIndex]
                $LineNumber = Get-Random -Minimum 1000 -Maximum 9999
                $PhoneNumber = "($AreaCode) $CentralOfficeCode-$LineNumber"
                
                # Generate sanitized username parts
                $sanitizedFirstName = $FirstName -replace '[^a-zA-Z0-9]', ''
                $sanitizedLastName = $LastName -replace '[^a-zA-Z0-9]', ''
                
                if ([string]::IsNullOrEmpty($sanitizedFirstName)) { $sanitizedFirstName = "user" }
                if ([string]::IsNullOrEmpty($sanitizedLastName)) { $sanitizedLastName = "$(Get-Random -Minimum 1000 -Maximum 9999)" }
                
                # Generate UPN and SAM account name
                switch ($UPNFormat) {
                    1 { $UPN = "$($sanitizedFirstName.ToLower()).$($sanitizedLastName.ToLower())@$domain" }
                    2 { $UPN = "$($sanitizedLastName.ToLower()).$($sanitizedFirstName.ToLower())@$domain" }
                    3 { $UPN = "$($sanitizedFirstName.Substring(0,1).ToLower())$($sanitizedLastName.ToLower())@$domain" }
                    4 { $UPN = "$($sanitizedLastName.Substring(0,1).ToLower())$($sanitizedFirstName.Substring(0,1).ToLower())@$domain" }
                    default { $UPN = "$($sanitizedFirstName.ToLower()).$($sanitizedLastName.ToLower())@$domain" }
                }
                
                $samAccountName = ($UPN -split '@')[0]
                if ($samAccountName.Length -gt 20) {
                    $samAccountName = $samAccountName.Substring(0, 20)
                }
                
                # Generate password
                $password = -join ((33..126) | Get-Random -Count 12 | ForEach-Object { [char]$_ }) + "A" + (Get-Random -Minimum 0 -Maximum 9) + "!"
                $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
                
                try {
                    # Create new AD user
                    $newUserParams = @{
                        Name = "$FirstName $LastName"
                        GivenName = $FirstName
                        Surname = $LastName
                        DisplayName = "$FirstName $LastName"
                        SamAccountName = $samAccountName
                        UserPrincipalName = $UPN
                        Path = $userOUPath
                        AccountPassword = $securePassword
                        Title = $Position
                        Department = $Department
                        Office = $Office
                        OfficePhone = $PhoneNumber
                        Enabled = $true
                        ChangePasswordAtLogon = $true
                    }

                    New-ADUser @newUserParams

                    # Attempt to resolve and assign manager (AD expects DistinguishedName)
                    if ($Manager -and $Manager.Trim() -ne '') {
                        try {
                            $mgr = $null
                            
                            # Strategy 1: Try SamAccountName (if manager looks like a username)
                            if ($Manager -notlike "*@*") {
                                $mgr = Get-ADUser -Filter "SamAccountName -eq '$Manager'" -ErrorAction SilentlyContinue
                            }
                            
                            # Strategy 2: Try UserPrincipalName (if it's a UPN or looks like email)
                            if (-not $mgr -and $Manager -like "*@*") {
                                $mgr = Get-ADUser -Filter "UserPrincipalName -eq '$Manager'" -ErrorAction SilentlyContinue
                            }
                            
                            # Strategy 3: Try constructing UPN with first.last format
                            if (-not $mgr) {
                                $sanitizedManager = $Manager -replace '\s+', '.' # Replace spaces with dots
                                $sanitizedManager = $sanitizedManager -replace '[^a-zA-Z0-9.]', '' # Remove special chars but keep dots
                                $managerUPN = "$($sanitizedManager.ToLower())@$domain"
                                $mgr = Get-ADUser -Filter "UserPrincipalName -eq '$managerUPN'" -ErrorAction SilentlyContinue
                            }
                            
                            # Strategy 4: Try DisplayName (exact match)
                            if (-not $mgr) {
                                $mgr = Get-ADUser -Filter "DisplayName -eq '$Manager'" -ErrorAction SilentlyContinue
                            }
                            
                            # Strategy 5: Try Name (cn attribute)
                            if (-not $mgr) {
                                $mgr = Get-ADUser -Filter "Name -eq '$Manager'" -ErrorAction SilentlyContinue
                            }

                            if ($mgr) {
                                try {
                                    Set-ADUser -Identity $samAccountName -Manager $mgr.DistinguishedName -ErrorAction Stop
                                    Write-Host "Assigned manager $($mgr.Name) to $samAccountName" -ForegroundColor Green
                                } catch {
                                    Write-Warning "Failed to assign manager for $samAccountName : $_"
                                }
                            } else {
                                Write-Warning "Manager '$Manager' not found in AD; skipping manager assignment. Consider creating the manager account first or use a manager UPN/SamAccountName."
                            }
                        } catch {
                            Write-Warning "Error while resolving manager '$Manager': $_"
                        }
                    }

                    # Output created user info
                    [PSCustomObject]@{
                        FirstName = $FirstName
                        LastName = $LastName
                        UPN = $UPN
                        SamAccountName = $samAccountName
                        Position = $Position
                        Department = $Department
                        Manager = $Manager
                        Office = $Office
                        PhoneNumber = $PhoneNumber
                        Status = "Created Successfully"
                        Password = $password
                    } | Format-Table -AutoSize

                    # Save user credentials to a file
                    [PSCustomObject]@{
                        UPN = $UPN
                        SamAccountName = $samAccountName
                        Password = $password
                    } | Export-Csv -Path "UserCredentials_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv" -Append -NoTypeInformation

                } catch {
                    Write-Error "Failed to create user $UPN : $_"
                    [PSCustomObject]@{
                        FirstName = $FirstName
                        LastName = $LastName
                        UPN = $UPN
                        Status = "Failed to Create: $_"
                    } | Format-Table -AutoSize
                }
            }
        }
    }
}

Function EntraUserInjection{
    # Check for Microsoft Graph PowerShell module
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
        Write-Warning "Microsoft Graph PowerShell module is not installed."
        $installChoice = Read-Host "Would you like to install it now? (Y/N)"
        if ($installChoice -eq 'Y') {
            Install-Module Microsoft.Graph -Force -AllowClobber
        } else {
            Write-Error "Microsoft Graph PowerShell module is required for Entra ID operations."
            return
        }
    }

    # Import the Microsoft Graph module
    Import-Module Microsoft.Graph

    # Connect to Microsoft Graph with required permissions
    try {
        Connect-MgGraph -Scopes "User.ReadWrite.All"
        Write-Host "Successfully connected to Microsoft Graph with User.ReadWrite.All permission." -ForegroundColor Green
    } catch {
        Write-Error "Failed to connect to Microsoft Graph. Error: $_"
        Write-Host "Please ensure you have the User.ReadWrite.All permission in your Entra ID app registration." -ForegroundColor Yellow
        return
    }

    $injectionFile = Read-Host "Enter in the full PATH to the injection file and press ENTER"
    Write-Output "`nPlease confirm that the following parameters are correct:`n"
    Get-Content $injectionFile

    $confirmation = Read-Host "`nIs the information correct (Y/N)?"


    if($confirmation -eq "Y"){
        # Read the config file
        $configLines = Get-Content $injectionFile

        # Create a hashtable to store parsed values
        $config = @{}

        foreach ($line in $configLines) {
            # Skip empty lines or lines without a colon
            if ([string]::IsNullOrWhiteSpace($line) -or $line.IndexOf(':') -eq -1) {
                continue
            }
            
            # Split into key and value
            $parts = $line -split ":", 2
            if ($parts.Count -lt 2) {
                continue
            }
            
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            
            # Skip if key or value is empty
            if ([string]::IsNullOrWhiteSpace($key) -or [string]::IsNullOrWhiteSpace($value)) {
                continue
            }

            # If it's UPNFormat (single value), store as-is
            if ($key -eq "UPNFormat") {
                $config[$key] = [int]$value
            } else {
                # Otherwise split by pipe and store as array
                $config[$key] = $value -split "\|" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            }
        }

        # Assign to individual variables
        $DepartmentList           = $config["DepartmentList"]
        $DepartmentAssociations   = $config["DepartmentAssociations"]
        $PositionList             = $config["PositionList"]
        $PositionAssociation      = $config["PositionAssociation"]
        $ManagerList              = $config["ManagerList"]
        $OfficeList               = $config["OfficeList"]
        $AreaCodeList             = $config["AreaCodeList"]
        $CentralOfficeCodeList    = $config["CentralOfficeCodeList"]
        $AreaCodeAssociation      = $config["AreaCodeAssociation"]
        $CentralOfficeAssociation = $config["CentralOfficeAssociation"]
        $RBACRoleList            = $config["RBACRoleList"]
        $RBACRoleAssociations    = $config["RBACRoleAssociations"]
        $UPNFormat               = $config["UPNFormat"]
        #$LicensesAssigned        = $config["LicensesAssigned"]

        # Optional: Display for confirmation
        Write-Host "`nParsed Configuration:"
        Write-Host "Departments: $($DepartmentList -join ', ')"
        Write-Host "Department Associations: $($DepartmentAssociations -join ', ')"
        Write-Host "Positions: $($PositionList -join ', ')"
        Write-Host "Position Associations: $($PositionAssociation -join ', ')"
        Write-Host "Managers: $($ManagerList -join ', ')"
        Write-Host "Offices: $($OfficeList -join ', ')"
        Write-Host "Area Codes: $($AreaCodeList -join ', ')"
        Write-Host "Central Office Codes: $($CentralOfficeCodeList -join ', ')"
        Write-Host "UPN Format: $UPNFormat"
        #Write-Host "Licenses Assigned:" $LicensesAssigned

            
    }

    $numberOfUsers = Read-Host "`nSpecify number of users and press ENTER"
    $domain = Read-Host "Specify the domain you want to use for the UPN and press ENTER"
    $group = Read-Host "Specify a specific group to add the users to, or leave blank and press ENTER"
    $usageLocation = Read-Host "Specify the usage location (e.g., US) for license assignment and press ENTER"
    Write-Output "`nThis is what a sample user will appear like, please review:"
    $firstNames = ((Get-Content "first-names.txt") -join "") -split "," | Where-Object { $_.Trim() -ne "" }
    $lastNames  = ((Get-Content "last-names.txt") -join "") -split "," | Where-Object { $_.Trim() -ne "" }

    if (-not $firstNames) { Write-Error "First name list is empty 
    or failed to load." ; return }
    if (-not $lastNames)  { Write-Error "Last name list is empty or failed to load." ; return }

    $randomFirstName = $firstNames | Get-Random
    $randomLastName  = $lastNames  | Get-Random
    $Department = $DepartmentList | Get-Random
    $Manager = $ManagerList[[int]($PositionAssociation | Where-Object { $PositionList.IndexOf($_) -eq ($PositionList | Get-Random -Count 1 | ForEach-Object { $PositionList.IndexOf($_) }) }) - 1]
    $Office = $OfficeList | Get-Random
    Write-Host "First Name:" $randomFirstName
    Write-Host "Last Name:"  $randomLastName
    if($UPNFormat -eq "1"){
        Write-Output "UPN:$randomFirstName.$randomLastName@$domain"
    }

    # Pick a random position index
    $positionIndex = Get-Random -Minimum 0 -Maximum $PositionList.Count

    # Get the position
    $Position = $PositionList[$positionIndex]

    # Get the associated department index (1-based in config, convert to 0-based)
    $deptIndexRaw = $PositionAssociation[$positionIndex]
    if (-not $deptIndexRaw) {
        Write-Warning "No department index found for position '$Position'."
        $Department = "Unassigned"
    } else {
        $deptIndex = [int]$deptIndexRaw - 1
        if ($deptIndex -ge 0 -and $deptIndex -lt $DepartmentList.Count) {
            $Department = $DepartmentList[$deptIndex]
        } else {
            Write-Warning "Department index out of bounds for position '$Position'."
            $Department = "Unassigned"
        }
    }

    # Select a random office index
    $officeIndex = Get-Random -Minimum 0 -Maximum $OfficeList.Count
    $Office = $OfficeList[$officeIndex]

    # Get associated area code and central office code
    $areaCodeIndexRaw = $AreaCodeAssociation[$officeIndex]
    $centralCodeIndexRaw = $CentralOfficeAssociation[$officeIndex]

    # Validate and convert to 0-based index
    if (-not $areaCodeIndexRaw -or -not $centralCodeIndexRaw) {
        Write-Warning "Missing phone code association for office index $officeIndex"
        $PhoneNumber = "Unassigned"
    } else {
        $areaCodeIndex = [int]$areaCodeIndexRaw - 1
        $centralCodeIndex = [int]$centralCodeIndexRaw - 1

        $AreaCode = $AreaCodeList[$areaCodeIndex]
        $CentralOfficeCode = $CentralOfficeCodeList[$centralCodeIndex]
        $LineNumber = Get-Random -Minimum 1000 -Maximum 9999

        $PhoneNumber = "($AreaCode) $CentralOfficeCode-$LineNumber"
    }


    Write-Host "Department:" $Department 
    Write-Host "Department:" $Position
    Write-Host "Manager:" $Manager
    Write-Host "Office:" $Office
    Write-Host "Phone Number:" $PhoneNumber
    #Write-Host "Licenses Assigned:" $LicensesAssigned

    $confirmation = Read-Host "`nContinue? (Y/N)" 

    if($confirmation -eq "Y"){
        for ($i = 1; $i -le $numberOfUsers; $i++) {

            # Random name
            $FirstName = $firstNames | Get-Random
            $LastName  = $lastNames  | Get-Random

            # Position and department
            $positionIndex = Get-Random -Minimum 0 -Maximum $PositionList.Count
            $Position = $PositionList[$positionIndex]
            $deptIndexRaw = $PositionAssociation[$positionIndex]
            $Department = if ($deptIndexRaw) { $DepartmentList[[int]$deptIndexRaw - 1] } else { "Unassigned" }

            # Manager
            $Manager = $ManagerList[[int]$deptIndexRaw - 1]

            # Office and phone
            $officeIndex = Get-Random -Minimum 0 -Maximum $OfficeList.Count
            $Office = $OfficeList[$officeIndex]
            $areaCodeIndex = [int]$AreaCodeAssociation[$officeIndex] - 1
            $centralCodeIndex = [int]$CentralOfficeAssociation[$officeIndex] - 1
            $AreaCode = $AreaCodeList[$areaCodeIndex]
            $CentralOfficeCode = $CentralOfficeCodeList[$centralCodeIndex]
            $LineNumber = Get-Random -Minimum 1000 -Maximum 9999
            $PhoneNumber = "($AreaCode) $CentralOfficeCode-$LineNumber"

            # License
            #$License = $LicenseList

            # UPN
            # Sanitize first and last names for UPN
            $sanitizedFirstName = $FirstName -replace '[^a-zA-Z0-9]', ''
            $sanitizedLastName = $LastName -replace '[^a-zA-Z0-9]', ''
            
            # Ensure we have valid parts
            if ([string]::IsNullOrEmpty($sanitizedFirstName)) { $sanitizedFirstName = "user" }
            if ([string]::IsNullOrEmpty($sanitizedLastName)) { $sanitizedLastName = "$(Get-Random -Minimum 1000 -Maximum 9999)" }
            
            switch ($UPNFormat) {
                1 { $UPN = "$($sanitizedFirstName.ToLower()).$($sanitizedLastName.ToLower())@$domain" }
                2 { $UPN = "$($sanitizedLastName.ToLower()).$($sanitizedFirstName.ToLower())@$domain" }
                3 { $UPN = "$($sanitizedFirstName.Substring(0,1).ToLower())$($sanitizedLastName.ToLower())@$domain" }
                4 { $UPN = "$($sanitizedLastName.Substring(0,1).ToLower())$($sanitizedFirstName.Substring(0,1).ToLower())@$domain" }
                default { $UPN = "$($sanitizedFirstName.ToLower()).$($sanitizedLastName.ToLower())@$domain" }
            }

            # Validate domain format
            if ($domain -notmatch '^[a-zA-Z0-9]+([-.][a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$') {
                Write-Error "Invalid domain format. Please enter a valid domain (e.g., company.com)"
                return
            }

            # Get RBAC roles for the position
            $assignedRBACRoles = @()
            for ($roleIndex = 0; $roleIndex -lt $RBACRoleList.Count; $roleIndex++) {
                $positionNumbers = $RBACRoleAssociations[$roleIndex] -split ',' | ForEach-Object { [int]$_.Trim() }
                $currentPositionNumber = $positionIndex + 1
                if ($positionNumbers -contains $currentPositionNumber) {
                    $assignedRBACRoles += $RBACRoleList[$roleIndex]
                }
            }

            # Generate a secure password
            $PasswordProfile = @{
                Password = -join ((33..126) | Get-Random -Count 12 | ForEach-Object { [char]$_ }) + 
                          "A" + (Get-Random -Minimum 0 -Maximum 9) + "!" # Ensures password complexity
                ForceChangePasswordNextSignIn = $true
            }

            # Create sanitized mailNickname (remove special chars and spaces)
            $mailNickname = ($UPN -split '@')[0]
            $mailNickname = $mailNickname -replace '[^a-zA-Z0-9]', '' # Remove all non-alphanumeric characters
            
            if ([string]::IsNullOrEmpty($mailNickname)) {
                $mailNickname = "$($FirstName.ToLower())$($LastName.ToLower())" -replace '[^a-zA-Z0-9]', ''
            }
            
            if ([string]::IsNullOrEmpty($mailNickname)) {
                $mailNickname = "user$(Get-Random -Minimum 10000 -Maximum 99999)"
            }

            # Sanitize display name
            $displayName = "$FirstName $LastName" -replace '["]', ''
            
            # Create user parameters
            $newUserParams = @{
                DisplayName = $displayName
                GivenName = $FirstName -replace '["]', ''
                Surname = $LastName -replace '["]', ''
                UserPrincipalName = $UPN
                MailNickname = $mailNickname
                AccountEnabled = $true
                PasswordProfile = $PasswordProfile
                JobTitle = $Position
                Department = $Department
                OfficeLocation = $Office
                BusinessPhones = @($PhoneNumber)
                UsageLocation = $usageLocation 
            }

            try {
                # Create the user in Entra ID first
                $newUser = New-MgUser @newUserParams

                # Check if manager exists and set if found
                if ($Manager -and $Manager.Trim() -ne '') {
                    $existingManager = $null
                    
                    # Try to find manager by multiple strategies
                    # Strategy 1: Try as-is if it looks like a UPN (contains @)
                    if ($Manager -like "*@*") {
                        try {
                            $existingManager = Get-MgUser -Filter "userPrincipalName eq '$Manager'" -ErrorAction SilentlyContinue
                        } catch {}
                    }
                    
                    # Strategy 2: Try constructing UPN with first.last format
                    if (-not $existingManager) {
                        $sanitizedManager = $Manager -replace '\s+', '.' # Replace spaces with dots
                        $sanitizedManager = $sanitizedManager -replace '[^a-zA-Z0-9.]', '' # Remove special chars but keep dots
                        $managerUPN = "$($sanitizedManager.ToLower())@$domain"
                        try {
                            $existingManager = Get-MgUser -Filter "userPrincipalName eq '$managerUPN'" -ErrorAction SilentlyContinue
                        } catch {}
                    }
                    
                    # Strategy 3: Try by displayName
                    if (-not $existingManager) {
                        try {
                            $existingManager = Get-MgUser -Filter "displayName eq '$Manager'" -ErrorAction SilentlyContinue
                        } catch {}
                    }
                    
                    # Strategy 4: Try by mail (if manager string looks like email)
                    if (-not $existingManager -and $Manager -like "*@*") {
                        try {
                            $existingManager = Get-MgUser -Filter "mail eq '$Manager'" -ErrorAction SilentlyContinue
                        } catch {}
                    }

                    # Set manager if found
                    if ($existingManager) {
                        try {
                            Set-MgUserManager -UserId $newUser.Id -ManagerId $existingManager.Id
                            Write-Host "Successfully set manager $($existingManager.DisplayName) for user $($newUser.UserPrincipalName)" -ForegroundColor Green
                        } catch {
                            Write-Warning "Failed to set manager for user $($newUser.UserPrincipalName): $_"
                        }
                    } else {
                        Write-Warning "Manager '$Manager' not found in Entra ID. Consider creating the manager account first or use a manager UPN/email directly in the config."
                    }
                }

                # Assign RBAC roles if any
                foreach ($role in $assignedRBACRoles) {
                    try {
                        $roleDefinition = Get-MgDirectoryRole | Where-Object { $_.DisplayName -eq $role }
                        if ($roleDefinition) {
                            New-MgDirectoryRoleMember -DirectoryRoleId $roleDefinition.Id -DirectoryObjectId $newUser.Id
                            Write-Host "Assigned role $role to user $($newUser.UserPrincipalName)" -ForegroundColor Green
                        } else {
                            Write-Warning "Role '$role' not found in Entra ID"
                        }
                    } catch {
                        Write-Warning "Failed to assign role '$role' to user $($newUser.UserPrincipalName): $_"
                    }
                }

                # Output created user info
                [PSCustomObject]@{
                    FirstName    = $FirstName
                    LastName     = $LastName
                    UPN         = $UPN
                    Position    = $Position
                    Department  = $Department
                    Manager     = $Manager
                    Office      = $Office
                    PhoneNumber = $PhoneNumber
                    RBACRoles   = $assignedRBACRoles -join ', '
                    Status      = "Created Successfully"
                    Password    = $PasswordProfile.Password
                    UsageLocation = $usageLocation
                } | Format-Table -AutoSize

                # Save user credentials to a file
                $userCredential = [PSCustomObject]@{
                    UPN = $UPN
                    Password = $PasswordProfile.Password
                }
                $userCredential | Export-Csv -Path "UserCredentials_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv" -Append -NoTypeInformation

            } catch {
                Write-Error "Failed to create user $UPN : $_"
                [PSCustomObject]@{
                    FirstName    = $FirstName
                    LastName     = $LastName
                    UPN         = $UPN
                    Status      = "Failed to Create: $_"
                } | Format-Table -AutoSize
            }
        }

    }

}


Function Get-UserMenuChoice {
    Read-Host "Enter a number and press ENTER"
}

# --- Main Menu Loop ---
$exitMenu = $false
do {
    UserMenu # Display the menu

    $userInput = Get-UserMenuChoice # Get user's choice

    switch ($userInput) {
        "1" {
            ADUserInjection
        }
        "2" {
            EntraUserInjection
        }
        "3" {
            ConfigureInjections
        }
        
        default {
            Write-Host "Invalid choice. Please enter a number from 1 to 5." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while (-not $exitMenu)
