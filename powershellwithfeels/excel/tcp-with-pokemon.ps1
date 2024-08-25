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

    .DESCRIPTION

    .AUTHOR
    tcpwithfeels 

    .VERSION
    1.0.0

    .DATE

    .NOTES

    .EXAMPLE

    .INPUTS

    .OUTPUTS

    .LINK

#>

# Title
$excelTitle = "pokemon-data.xlsx"

# Current Working Directory
$currentDirectory = Get-Location

# Init COM object
$excel = New-Object -ComObject Excel.Application

# Open Twerkbook
$workbook = $excel.Workbooks.Open("$currentDirectory\$excelTitle")

# Twerksheet
$worksheet = $workbook.Worksheets.Item("Pokemon")

# Range rover
$range = $worksheet.UsedRange

# Store in a hashy
$pokemonData = @{}

# Read data
for ($row = 2; $row -le $range.Rows.Count; $row++) {
    $name = $range.Cells.Item($row, 1).Text
    $type = $range.Cells.Item($row, 2).Text
    $hp = $range.Cells.Item($row, 3).Text
    $attack = $range.Cells.Item($row, 4).Text
    $defense = $range.Cells.Item($row, 5).Text

    $pokemonData[$name] = [PSCustomObject]@{
        Name    = $name
        Type    = $type
        HP      = $hp
        Attack  = $attack
        Defense = $defense
    }
}

# Close workbook
$workbook.Close($false)

# Quit Excel
$excel.Quit()

# Release COM
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

# Get input
$pokemonName = Read-Host -Prompt "Enter the Pokémon name"

# Check data
if ($pokemonData.ContainsKey($pokemonName)) {
    $pokemon = $pokemonData[$pokemonName]
    Write-Output "Pokémon: $($pokemon.Name)"
    Write-Output "Type: $($pokemon.Type)"
    Write-Output "HP: $($pokemon.HP)"
    Write-Output "Attack: $($pokemon.Attack)"
    Write-Output "Defense: $($pokemon.Defense)"
} else {
    Write-Output "Not in Pokédex"
}

