
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

# Load 
$jsonFilePath = "$currentDirectory\pokemon-with-feels.json"
$pokemonData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Sort data by Number
$pokemonData = $pokemonData | Sort-Object -Property Number

# Init
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Add()

# Add new worksheet with a specific name
$newWorksheetName = "POKEDEXAmphetamine"
$worksheet = $workbook.Worksheets.Add()
$worksheet.Name = $newWorksheetName

# Set header row
$worksheet.Cells.Item(1, 1) = "Number"
$worksheet.Cells.Item(1, 2) = "Name"
$worksheet.Cells.Item(1, 3) = "Type 1"
$worksheet.Cells.Item(1, 4) = "Type 2"
$worksheet.Cells.Item(1, 5) = "HP"
$worksheet.Cells.Item(1, 6) = "Attack"
$worksheet.Cells.Item(1, 7) = "Defense"
$worksheet.Cells.Item(1, 8) = "Special Attack"
$worksheet.Cells.Item(1, 9) = "Special Defense"
$worksheet.Cells.Item(1, 10) = "Speed"

# Populate Excel with Pokémon data
$row = 2
foreach ($pokemon in $pokemonData) {
    $worksheet.Cells.Item($row, 1) = $pokemon.Number
    $worksheet.Cells.Item($row, 2) = $pokemon.Name
    $worksheet.Cells.Item($row, 3) = $pokemon.Type1
    $worksheet.Cells.Item($row, 4) = $pokemon.Type2
    $worksheet.Cells.Item($row, 5) = $pokemon.HP
    $worksheet.Cells.Item($row, 6) = $pokemon.Attack
    $worksheet.Cells.Item($row, 7) = $pokemon.Defense
    $worksheet.Cells.Item($row, 8) = $pokemon.SpecialAttack
    $worksheet.Cells.Item($row, 9) = $pokemon.SpecialDefense
    $worksheet.Cells.Item($row, 10) = $pokemon.Speed
    $row++
}
$outputDirectory = "OUTPUT-with-Feels"
if (-not (Test-Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Save the Excel file
$excelFilePath = "$currentDirectory\$outputDirectory\OUTPUT-EXC_pokemon-with-feels.xlsx"
$workbook.SaveAs($excelFilePath)

$csvFilePath = "$currentDirectory\$outputDirectory\OUTPUT-CSV_pokemon-with-feels.csv"
$pokemonData | Export-Csv -Path $csvFilePath -NoTypeInformation

# Cleanup
$workbook.Close()
$excel.Quit()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

# Notify user
Write-Output "Excel file created at $excelFilePath"
