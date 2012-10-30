
$shapes = ppt-list-shapes
$shapes | % {
  if ($_.Height) {
    $oldLock = $_.LockAspectRatio;
    $_.LockAspectRatio = 0; 
    $_.Height = $_.Height * 4/3;
    $_.LockAspectRatio = $oldLock;
  }
}
