
if (! (test-path variable:sho_array_loaded) ) {
  $local:asms = @(
    "IronMath",
    "ArrayFactory",
    "MatrixInterf"
  )
  foreach ($local:i in $local:asms) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName($local:i)
  }
  Update-TypeData $HOME/bin/sho_array.ps1xml
  Update-FormatData $HOME/bin/sho_array.Format.ps1xml
  $sho_array_loaded = $true
}

function sho_array([int]$m, [int]$n) {
  $object = ,[ShoNS.Array.ArrayFactory]::DoubleArray($m,$n)
  $object.PSObject.typenames[0] = "ShoDoubleArray"
  $object
}

function sho_svd($a) {
  [ShoNS.Array.ArrayFactory]::SVD($a)
}

# referenced in sho_array.format.ps1xml
function sho_array_to_display_string($a) {
  $a.ToString()
}
