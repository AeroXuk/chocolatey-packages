[CmdletBinding()]
param($IncludeStream, [switch]$Force)
Import-Module AU

$updateUri = "https://www.routeconverter.com/feedback/update-check/"

# Exmaple: https://static.routeconverter.com/download/previous-releases/2.27/RouteConverterWindowsOpenSource.exe
$downloadUriPrefix = "https://static.routeconverter.com/download/previous-releases/"
$downloadUriSuffix = "/RouteConverterWindowsOpenSource.exe"


function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
  $webResponse = Invoke-WebRequest -UseBasicParsing -Method Post -Uri $updateUri -Body @{'id'='0'}
  $variables = $webResponse.Content -replace '"','' -split ',' -join "`n" | ConvertFrom-StringData
  $latestVersion = $(Get-Version $variables["routeconverter.version"])

  @{
    Version = $latestVersion.ToString()
    RemoteVersion = $latestVersion.ToString()
    URL32   = "$downloadUriPrefix$($latestVersion.ToString(2))$downloadUriSuffix"
  }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
