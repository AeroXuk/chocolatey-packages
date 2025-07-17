$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.ssmstoolspack.com/Download/STP?v=6.8.0.0'

  softwareName  = 'SSMS Tools Pack *'

  checksum      = '5832fe170b66a16a845f500b77fa30425dd9b1947f0fb02d834b0ca012cb49d9'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
