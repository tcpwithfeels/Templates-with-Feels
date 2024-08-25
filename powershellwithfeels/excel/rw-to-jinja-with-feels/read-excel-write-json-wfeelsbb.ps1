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

# Current Working Directory
$currentDirectory = Get-Location
Write-Output $currentDirectory

# Define paths
$templateFilePath = "$currentDirectory\pokemon_template-with-feels.j2"
$templateFilePath2 = "$currentDirectory\pokegate_config_template.j2"

$jsonFilePath = "$currentDirectory\pokemon-with-feels.json"
$outputDirectory = "OUTPUT-with-Feels"
if (-not (Test-Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}
$outputFilePath = "$currentDirectory\$outputDirectory\JINJA2Pokemon.txt"
$outputFilePath2 = "$currentDirectory\$outputDirectory\POKEGATES.txt"
# Read the template file
$template = Get-Content -Path $templateFilePath -Raw
$template2 = Get-Content -Path $templateFilePath2 -Raw
# Read JSON data from file
$jsonData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Initialize empty string to store the rendered output
$renderedOutput = ""
$renderedOutput2 = ""

# Process each Pokémon entry
foreach ($pokemon in $jsonData) {
    $renderedOutput += $template -replace "{{ Name }}", $pokemon.Name `
                                      -replace "{{ Number }}", $pokemon.Number `
                                      -replace "{{ Type1 }}", $pokemon.Type1 `
                                      -replace "{{ Type2 }}", $pokemon.Type2 `
                                      -replace "{{ HP }}", $pokemon.HP `
                                      -replace "{{ Attack }}", $pokemon.Attack `
                                      -replace "{{ Defense }}", $pokemon.Defense `
                                      -replace "{{ SpecialAttack }}", $pokemon.SpecialAttack `
                                      -replace "{{ SpecialDefense }}", $pokemon.SpecialDefense `
                                      -replace "{{ Speed }}", $pokemon.Speed
    $renderedOutput += "`n`n"
}
foreach ($pokemon in $jsonData) {
    $renderedOutput2 += $template2 -replace "{{ Name }}", $pokemon.Name `
                                      -replace "{{ Number }}", $pokemon.Number `
                                      -replace "{{ Type1 }}", $pokemon.Type1 `
                                      -replace "{{ Type2 }}", $pokemon.Type2 `
                                      -replace "{{ HP }}", $pokemon.HP `
                                      -replace "{{ Attack }}", $pokemon.Attack `
                                      -replace "{{ Defense }}", $pokemon.Defense `
                                      -replace "{{ SpecialAttack }}", $pokemon.SpecialAttack `
                                      -replace "{{ SpecialDefense }}", $pokemon.SpecialDefense `
                                      -replace "{{ Speed }}", $pokemon.Speed
    $renderedOutput2 += "`n"
}

$prependString =  @"   
--------------------------------------------------------------------------------------------------------------                  
                         F
    (\__/)        T      E  
    (o^.^)        C with E  
    z(_(`")(`")     P      L  
                         S
-------------------------------------------------------

"@
$THANKS =  @"
-------------------------------------------------------                     
                         F
    (\__/)        T      E  
   \(o^.^)/       H with E  
    z(_(`")(`")     X      L  
                         S
--------------------------------------------------------------------------------------------------------------
"@

$fullOutput = $prependString + $renderedOutput
$fullOutput += $THANKS

$fullOutput2 = $prependString + $renderedOutput2
$fullOutput2 += $THANKS

# Write the rendered output to a file
Set-Content -Path $outputFilePath -Value $fullOutput
Set-Content -Path $outputFilePath2 -Value $fullOutput2

Write-Output "Rendered template saved to $outputFilePath"
Write-Output "POKIGATE Rendered template saved to $outputFilePath2"
