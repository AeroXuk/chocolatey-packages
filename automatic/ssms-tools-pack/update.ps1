[CmdletBinding()]
param($IncludeStream, [switch]$Force)
Import-Module AU

$soapUri  = 'http://www.ssmstoolspack.com/ssmstoolspackservice.asmx?WSDL'
$downloadUri = "https://www.ssmstoolspack.com/Download/STP?v="

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
  $SsmsToolsPackService = New-WebServiceProxy -Uri $soapUri -Namespace SsmsToolsPackService
  $latestVersion = $(Get-Version $($SsmsToolsPackService.ZadnjaVerzija())).ToString()

  @{
    Version = $latestVersion
    RemoteVersion = $latestVersion
    URL32   = "$downloadUri$($latestVersion)"
  }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
