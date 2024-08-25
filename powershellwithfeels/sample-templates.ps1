<#
    #------------------------------------
    #
    #                       F  
    #    (\__/)      T      E  
    #    (o^.^)      C with E  
    #    z(_(")(")   P      L  
    #                       S
    #
    #------------------------------------

    .SYNOPSIS
    Brief description of what the script does.

    .DESCRIPTION
    Detailed description of the script's purpose and functionality.

    .AUTHOR
    tcpwithfeels 

    .VERSION
    1.0.0

    .DATE
    August 23, 2024

    .NOTES
    Additional notes about the script.

    .EXAMPLE
    Example of how to run the script:
    .\YourScriptName.ps1

    .INPUTS
    List of input parameters and their descriptions.

    .OUTPUTS
    Description of what the script outputs.

    .LINK
    Any relevant links or references.
#>



# Title
$docTitle = "template-output"

# Current Working Directory
$currentDirectory = Get-Location
Write-Output $currentDirectory

# User Information
function Get-UserInfo {
    $Name = Read-Host "Enter your name"

    # Validation of correct BIRTHDATE inpue
    do {
        $Birthdate = Read-Host "Enter your birthdate (DD/MM/YYYY)"
        
        # REGEX DD/MM/YYYY
        $datePattern = '^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$'
        
        if ($Birthdate -match $datePattern) {
            try {
                $parsedDate = [datetime]::ParseExact($Birthdate, 'dd/MM/yyyy', $null)
                $validDate = $true
            } catch {
                Write-Host "Invalid date. Please enter a valid date in the format DD/MM/YYYY." -ForegroundColor Red
                $validDate = $false
            }
        } else {
            Write-Host "Invalid format. Please enter the date in DD/MM/YYYY format." -ForegroundColor Red
            $validDate = $false
        }
    } while (-not $validDate)

    # Age
    $today = Get-Date
    $Age = $today.Year - $parsedDate.Year
    if ($today.Month -lt $parsedDate.Month -or ($today.Month -eq $parsedDate.Month -and $today.Day -lt $parsedDate.Day)) {
        $Age--
    }

    # When you were born
    $dayOfWeek = $parsedDate.DayOfWeek

    # Return user info as a hashtable
    return @{
        name      = $Name
        birthdate = $parsedDate.ToString('dd/MM/yyyy')
        age       = $Age
        DayOfWeek = $dayOfWeek
    }
}

# Template
$template = @"

Hello, {{ name }}! Your birthdate is {{ birthdate }}
This means you are {{ age }} years old


FUN FACT: You were born on a {{ dayOfWeek }}

Welcome to the {{ project_name }} Templates.
Feel free to explore.

"@

$data = Get-UserInfo
$data["project_name"] = "TCPwithFEELS"

# Function
function Render-Template {
    param (
        [string]$template,
        [hashtable]$data
    )
    
    # Replace
    foreach ($key in $data.Keys) {
        $placeholder = "{{ $key }}"
        $template = $template -replace [regex]::Escape($placeholder), $data[$key]
    }
    
    return $template
}

# Render
$output = Render-Template -template $template -data $data

# Output
Write-Output $output

# Save
$outputPath = "$currentDirectory\$docTitle.txt"
Set-Content -Path $outputPath -Value $output