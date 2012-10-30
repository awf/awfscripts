
# make ppt first to get types loaded
$p = new-object -com PowerPoint.Application

throw "the one in ~/bin is newer"

# List all shapes in the currently runnning PowerPoint's foreground deck
# Groups are flattened
# The output is an array of Shape objects with an additional "awfPath" 
#  property which makes it easy to find which slide and group they are in.

$msoMedia = [Microsoft.Office.Core.MsoShapeType]::msoMedia;
$msoGroup = [Microsoft.Office.Core.MsoShapeType]::msoGroup;

$shapes_to_delete = @()

function annotate($shape, $slide) {
  if ($shape.Type -eq $msoMedia) {
    $filename = $shape.LinkFormat.SourceFullName
    $newfn = $filename
    $newfn = $filename -replace "C:\\images","C:\users\awf\images"
    write-host "Slide $($shape.Parent.SlideIndex)> `"$filename`" -> $newfn"
    if ($newfn -ne $filename) { 
      $mo = $slide.Shapes.AddMediaObject($newfn, $shape.Left, $shape.Top, $shape.Width, $shape.Height)
      write-host "Added $($mo.Name) to slide $($mo.Parent.SlideIndex)"
      $shapes_to_delete += $shape
    }
  }
}

$t0 = get-date
foreach ($slide in $p.ActivePresentation.Slides) {
   write-host "Slide $($slide.SlideIndex)"
   foreach ($shape in $slide.Shapes) {
     if ($shape.Type -eq $msoGroup) {
       foreach ($subshape in $shape.GroupItems) {
	 $o = annotate $subshape $slide
       }
     } else {
       $o = annotate $shape $slide
     }
   }
}
awf-ttoc $t0

foreach ($shape in $shapes_to_delete) {
  write-host "Deleting $($shape.Name) from slide $($shape.Parent.SlideIndex)"
}

# 
# ppt-list-shapes | % {
#   if ($_.Type -eq [Microsoft.Office.Core.MsoShapeType]::msoMedia) {
#      echo "Slide $($_.awfPath.Slide)> `"$($_.LinkFormat.SourceFullName)`""
#   }
# }
