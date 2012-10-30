
# List all shapes in the currently runnning PowerPoint's foreground deck
# Groups are flattened
# The output is an array of Shape objects with an additional "awfPath" 
#  property which makes it easy to find which slide and group they are in.

function annotate($shape,$path) {
  add-member -inputObject $shape -passthru -membertype NoteProperty -name awfPath -value $path 
}

$t0 = get-date
$p = new-object -com PowerPoint.Application
foreach ($slide in $p.ActivePresentation.Slides) {
   write-host "Slide $($slide.SlideIndex)"
   $t = get-date
   foreach ($shape in $slide.Shapes) {
     $path = @{Slide=$slide.SlideIndex}
     if ($shape.Type -eq [Microsoft.Office.Core.MsoShapeType]::msoGroup) {
       $path["Group"] = $shape.Name
       foreach ($subshape in $shape.GroupItems) {
	 $o = annotate $subshape $path
       }
     } else {
       $o = annotate $shape $path
     }
   }
   awf-ttoc $t
}
awf-ttoc $t0
