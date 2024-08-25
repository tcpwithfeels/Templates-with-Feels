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

#POKEMON OBJECT - Class in Powershell
class Pokemon {
    [string]$Name
    [string]$Type
    [int]$HP
    [int]$Attack
    [int]$Defense

    # Constructor
    Pokemon([string]$name, [string]$type, [int]$hp, [int]$attack, [int]$defense) {
        $this.Name = $name
        $this.Type = $type
        $this.HP = $hp
        $this.Attack = $attack
        $this.Defense = $defense
    }

    # Method to display Pokémon info
    [void]Display() {
        Write-Output "Pokémon: $($this.Name)"
        Write-Output "Type: $($this.Type)"
        Write-Output "HP: $($this.HP)"
        Write-Output "Attack: $($this.Attack)"
        Write-Output "Defense: $($this.Defense)"
    }
}

# Store in a hashy
$pokemonData = @{}
$pokemonData2 = @{}

# Read data
for ($row = 2; $row -le $range.Rows.Count; $row++) {
    $name = $range.Cells.Item($row, 1).Text
    $type = $range.Cells.Item($row, 2).Text
    $hp = $range.Cells.Item($row, 3).Text
    $attack = $range.Cells.Item($row, 4).Text
    $defense = $range.Cells.Item($row, 5).Text

    #Pokemon in a norm HASH
    $pokemonData[$name] = [PSCustomObject]@{
        Name    = $name
        Type    = $type
        HP      = $hp
        Attack  = $attack
        Defense = $defense
    }
    # Pokemon in a HASH stored as OBJECTS
    # Create Poke Objects and STORE
    $pokemonObject = [Pokemon]::new($name, $type, $hp, $attack, $defense)
    $pokemonData2[$name] = $pokemonObject
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
$pokemonName = "Pikachu"
#$pokemonName = Read-Host -Prompt "Enter the Pokémon name"

# First HASH
Write-Output "----"
Write-Output "HASH Value for $pokemonName"
Write-Output "----"

if ($pokemonData.ContainsKey($pokemonName)) {
    $pokemon = $pokemonData[$pokemonName]
    Write-Output "Pokémon: $($pokemon.Name)"
    Write-Output "Type: $($pokemon.Type)"
    Write-Output "HP: $($pokemon.HP)"
    Write-Output "Attack: $($pokemon.Attack)"
    Write-Output "Defense: $($pokemon.Defense)`n"
} else {
    Write-Output "Not in Pokédex\n"
}

Write-Output "----"
Write-Output "OBJECT Value for $pokemonName"
Write-Output "----"

$pokemonData2.GetEnumerator() | ForEach-Object {
    $pokemon = $_.Value

    if ($pokemon.Name -eq "$pokemonName" ) {
        Write-Output $pokemon
    }
<#
    if ($pokemon.Name -eq "$pokemonName" ) {
        Write-Output "Pokémon: $($pokemon.Name)"
        Write-Output "Type: $($pokemon.Type)"
        Write-Output "HP: $($pokemon.HP)"
        Write-Output "Attack: $($pokemon.Attack)"
        Write-Output "Defense: $($pokemon.Defense)" 
    }
#>
}