<#
    #---------------------------
    #
    #                       F  
    #    (\__/)      T      E  
    #    (o^.^)      C with E  
    #    z(_(")(")   P      L  
    #                       S
    #
    #---------------------------

    .SYNOPSIS
    This script asks input about your name, age and birthdate and outputs the day of the week you were born.

    .DESCRIPTION
    This is a sample Powershell script that is used to help with starting off with Jinja Templates.

    .AUTHOR
    tcpwithfeels

    .VERSION
    1.0.0

    .DATE
    August 23, 2024

    .NOTES
    Additional notes: N/A

    .EXAMPLE
    Example of how to run the script:
    .\<scriptName>.ps1

    .INPUTS
    Name, Age and Birthdate

    .OUTPUTS
    Outputs the day of the week you were born

    .LINK
    www.github.com/tcpwithfeels
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

# Define the path to the template file
$templatePath = "$currentDirectory\jinja2_template.j2"

#template
$j2template = Get-Content -Path $templatePath -Raw

$data = Get-UserInfo
$data["project_name"] = "TCPwithFEELS"

# Function
function Render-Template {
    param (
        [string]$j2templateFile,
        [hashtable]$data
    )
    
    # Replace
    foreach ($key in $data.Keys) {
        $placeholder = "{{ $key }}"
        $j2template  = $j2template  -replace [regex]::Escape($placeholder), $data[$key]
    }
    
    return $j2template
}

# Render
$output = Render-Template -template $template -data $data

# Output
Write-Output $output

# Save
$outputPath = "$currentDirectory\$docTitle.txt"
Set-Content -Path $outputPath -Value $output