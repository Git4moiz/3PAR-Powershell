Function Get-3PARPorts {

  <#
      .SYNOPSIS
      Retrieve informations about ports.
      .DESCRIPTION
      This function will retrieve informations about ports. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARHostSets
      List all the ports.
  #>

  [CmdletBinding()]
  Param(
      #[Parameter(Mandatory = $false,HelpMessage = 'Port Position n:s:p')]
      #[String]$Position
  )
  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/ports'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.ports'
  
    #Write result + Formating
    Write-Verbose "Total number of ports: $($dataCount)"
  }

  process {
    If ($Position) {
        Write-Verbose "Return result(s) with the filter: $($Position)"
        return $AlldataPS | Where-Object -FilterScript {$_.portPos -like $Position}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $AlldataPS
    }
  }

}
