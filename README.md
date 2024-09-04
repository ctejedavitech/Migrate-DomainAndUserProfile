Here's a `README.md` template you can use for your GitHub repository to describe your PowerShell function:

---

# Domain Migration and User Profile Repointing Script

This PowerShell script automates the process of disjoining a computer from its current domain, joining it to a new domain, and repointing user profiles to the new domain. The script is encapsulated in a function `Migrate-DomainAndUserProfile`, which handles domain migrations and user profile changes with error handling for each major operation.

## Features

- Disjoins the computer from its current domain and restarts.
- Joins the computer to a new domain and restarts again.
- Repoints a user profile from the old domain to the new domain.
- Handles potential errors with `try`/`catch` blocks and provides informative error messages.
- Flexible parameters for customizing the domain migration process.

## Requirements

- **PowerShell 5.1** or higher.
- Local administrative privileges on the machine.
- Access to the `Set-UserProfileOwner` cmdlet, which may require a specific module (e.g., `UserProfileMigrate`).

## Usage

### 1. Clone the Repository

To get started, clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/domain-migration-script.git
```

### 2. Modify Parameters

Before running the script, ensure you modify the necessary parameters, such as:

- `localAdminUser` and `localAdminPass` for local administrator credentials.
- `newDomainName`, `newDomainUser`, and `newDomainPass` for the new domain details.
- `oldDomain`, `newDomain`, `oldUsername`, and `newUsername` for user profile migration.

### 3. Example Script Usage

```powershell
Migrate-DomainAndUserProfile `
    -localAdminUser "localadmin" `
    -localAdminPass "localadminpassword" `
    -newDomainName "newdomain.com" `
    -newDomainUser "domainuser" `
    -newDomainPass "domainuserpassword" `
    -computerName "computername" `
    -oldDomain "olddomain" `
    -newDomain "newdomain" `
    -oldUsername "olduser" `
    -newUsername "newuser"
```

### 4. Parameters

| Parameter            | Description                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| `localAdminUser`      | The username of the local administrator on the machine.                     |
| `localAdminPass`      | The password of the local administrator.                                   |
| `workgroupName`       | The workgroup to assign after disjoining from the current domain.           |
| `newDomainName`       | The domain name to join the machine to after disjoining.                    |
| `newDomainUser`       | The domain account with rights to join the machine to the new domain.       |
| `newDomainPass`       | The password for the domain account.                                        |
| `computerName`        | The new name of the computer when joining the new domain (optional).        |
| `oldDomain`           | The current domain for the user profile to be repointed.                    |
| `newDomain`           | The new domain for the user profile.                                        |
| `oldUsername`         | The username from the old domain that needs to be migrated.                 |
| `newUsername`         | The username in the new domain for which the user profile will be repointed.|

### 5. Error Handling

The script includes `try`/`catch` blocks to handle any potential errors that may occur during the following stages:
- **Disjoining from the domain:** If this fails, the script outputs an error message and stops further execution.
- **Joining the new domain:** Any issues during this step will also result in an error message.
- **Repointing the user profile:** The script checks if the user profile exists before attempting to modify it. If not, it will output a warning.

## Notes

- **Restarts:** This script assumes that the machine will automatically restart after disjoining and joining the new domain. Make sure you account for the time it takes for the machine to reboot.
- **Profile Migration:** The profile migration uses the `Set-UserProfileOwner` cmdlet, which might require a custom module (`UserProfileMigrate`). Ensure the module is available on the system.
- **Credential Handling:** For security, avoid hardcoding credentials. Instead, use secure storage methods like the Windows Credential Manager or Azure Key Vault in production environments.


## Contributing

If you'd like to contribute to this script or report issues, feel free to open a pull request or create an issue in the repository.

---

### Example repository structure:

```
domain-migration-script/
│
├── Migrate-DomainAndUserProfile.ps1
├── README.md
└── LICENSE
```

Replace `yourusername` with your actual GitHub username, and feel free to adjust the text to match your specific requirements.
