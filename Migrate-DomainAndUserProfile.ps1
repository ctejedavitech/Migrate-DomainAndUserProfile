function Migrate-DomainAndUserProfile {
    param (
        [string]$localAdminUser,
        [string]$localAdminPass,
        [string]$workgroupName = "WORKGROUP",
        [string]$newDomainName,
        [string]$newDomainUser,
        [string]$newDomainPass,
        [string]$computerName,
        [string]$oldDomain,
        [string]$newDomain,
        [string]$oldUsername,
        [string]$newUsername
    )

    try {
        # Disjoin from current domain
        Write-Host "Attempting to disjoin from current domain..."
        $localAdminPasswordSecure = $localAdminPass | ConvertTo-SecureString -AsPlainText -Force
        $unjoinCredential = New-Object System.Management.Automation.PSCredential("$env:USERDOMAIN\$env:USERNAME", (ConvertTo-SecureString -String $env:USERDOMAIN_PASSWORD -AsPlainText -Force))

        Remove-Computer -UnjoinDomainCredential $unjoinCredential -WorkgroupName $workgroupName -PassThru -Restart -Force
        Write-Host "Successfully disjoined from the domain and restarted the computer."

    } catch {
        Write-Host "Error occurred while trying to disjoin from domain: $_" -ForegroundColor Red
        return
    }

    Start-Sleep -Seconds 60  # Wait to simulate the reboot process

    try {
        # Join the new domain
        Write-Host "Attempting to join the new domain: $newDomainName..."
        $newDomainPasswordSecure = $newDomainPass | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential("$newDomainUser", $newDomainPasswordSecure)

        Add-Computer -DomainName $newDomainName -Credential $credential -Restart -Force -PassThru -NewName $computerName
        Write-Host "Successfully joined the domain and restarted the computer."

    } catch {
        Write-Host "Error occurred while trying to join the new domain: $_" -ForegroundColor Red
        return
    }

    Start-Sleep -Seconds 60  # Wait to simulate the reboot process

    try {
        # Repoint user profile
        Write-Host "Attempting to repoint user profile from $oldDomain\$oldUsername to $newDomain\$newUsername..."
        $userProfile = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.LocalPath -like "*$oldUsername" }

        if ($userProfile) {
            Set-UserProfileOwner -SID $userProfile.SID -NewOwner "$newDomain\$newUsername" -Force
            Write-Host "Successfully updated the user profile ownership."
        } else {
            Write-Host "User profile for $oldUsername not found." -ForegroundColor Yellow
        }

    } catch {
        Write-Host "Error occurred while repointing the user profile: $_" -ForegroundColor Red
        return
    }
}

