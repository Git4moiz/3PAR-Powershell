function Send-3PARRequest {
    [CmdletBinding()]
    Param (
        [parameter(Position = 0, Mandatory = $true, HelpMessage = "Enter the resource URI (ex. /volumes)")]
        [ValidateScript({if ($_.startswith('/')) {$true} else {throw "-URI must being with a '/' (eg. /volumes) in its value. Please correct the value and try again."}})]
        [string]$uri
    )

    Begin {}

    Process {
      
      $APIurl = 'https://'+$global:3parArray+':8080/api/v1'

      $url = $APIurl + $uri


      $headers = @{}
      $headers["Accept"] = "application/json"
      $headers["X-HP3PAR-WSAPI-SessionKey"] = $global:3parKey
      
      # Request
      Try
      {
          $data = Invoke-WebRequest -Uri "$url" -ContentType "application/json" -Headers $headers -Method GET -UseBasicParsing
          return $data  
      }
      Catch
      {
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $responseBody = $reader.ReadToEnd();
        Write-Verbose "Status: A system exception was caught."
        Write-Verbose $responsebody

        throw 'Error connecting to HP 3PAR Array'
      }
    }

    End {}
}
