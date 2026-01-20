Function MainMenu {
    Write-Host "`n          Welcome to BAESL!              " -ForegroundColor Black -BackgroundColor Green
    Write-Host "-----------------------------------------" -ForegroundColor Black
    Write-Host "1) User Settings      " -ForegroundColor green -BackgroundColor Black
    Write-Host "2) Environment Settings                " -ForegroundColor green -BackgroundColor Black
    Write-Host "3) About & Help                        " -ForegroundColor green -BackgroundColor Black
    Write-Host "4) Exit                                " -ForegroundColor green -BackgroundColor Black
    Write-Host "-----------------------------------------" -ForegroundColor Black
    Write-Host "`n"
}


Function Get-UserMenuChoice {
    Read-Host "Enter a number and press ENTER"
}

# --- Main Menu Loop ---
$exitMenu = $false
do {
    MainMenu # Display the menu

    $userInput = Get-UserMenuChoice # Get user's choice

    switch ($userInput) {
        "1" {
            .\user-settings.ps1
        }
        "2" {
            .\environment-settings.ps1
        }
        "3" {
            # About & Help
            $about = @'
=== BAESL - About ===
BAESL AD/Entra Sandbox Loader - v1.0
Description: Creates and manages test users for sandbox environments.
Author: Colby Pryor (PryroTech - pryrotech.com)

Usage:
- Select option 1 to edit User Settings.
- Select option 2 to edit Environment Settings.
- Place CSV files in the workspace; import routines will consume them.

Required Graph API Scopes:
Application.Read.All, Directory.Read.All, DelegatedPermissionGrant.Read.All

Required Applications (if injecting into Active Directory):
To inject users into Active Directory, ensure that you have ADUC installed on your machine. Otherwise, this will not work.

Help and Troubleshooting:
- Ensure you are connected to Microsoft Graph before running import operations.
- See README.md for txt formatting and examples.
- If you see permission errors, verify tenant admin consent for required scopes.

For more information, check README.md or contact the script author.
'@
            Write-Host $about -ForegroundColor Green
            Read-Host "Press Enter to return to menu"
        }
        "4" {
            # Exit
            Write-Host "Exiting BAESL. Goodbye!" -ForegroundColor Magenta
            $exitMenu = $true
            Disconnect-MgGraph
            Start-Sleep -Seconds 2
        }
        default {
            Write-Host "Invalid choice. Please enter a number from 1 to 4." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while (-not $exitMenu)