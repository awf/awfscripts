
$p = new-object -com PowerPoint.Application
foreach ($slide in $p.ActivePresentation.Slides) {
   write-host "Slide $($slide.SlideIndex)"
   foreach ($shape in $slide.Shapes) {
     # write-host "Slide $($slide.SlideIndex)"
     add-property -noteproperty awfSlideIndex $slide.SlideIndex $shape
   }
}

[Microsoft.Office.Core.MsoShapeType]::msoMedia