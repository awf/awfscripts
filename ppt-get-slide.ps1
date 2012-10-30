param([int]$slidenumber)
$p = new-object -com PowerPoint.Application

$p.ActivePresentation.Slides.Item($slidenumber)
