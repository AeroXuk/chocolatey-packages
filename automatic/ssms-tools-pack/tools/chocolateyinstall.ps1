$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = 'https://www.ssmstoolspack.com/Download/STP?v=5.7.3.0'

  softwareName  = 'SSMS Tools Pack *'

  checksum      = 'b4d61384b10f578b4c7be9b43cfd1a37f3f1e6d0fb335bb571f521fde36449a9'
  checksumType  = 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
