$ppt = new-object -com PowerPoint.Application
$myDocument = $ppt.ActivePresentation.Slides.Item(1)
$shapes = $myDocument.Shapes
$msoShapeIsoscelesTriangle = [Microsoft.Office.Core.MsoAutoShapeType]::msoShapeIsoscelesTriangle
$shapes.AddShape($msoShapeIsoscelesTriangle, 10, 10, 100, 100).Name = "shpOne"
$shapes.AddShape($msoShapeIsoscelesTriangle, 150, 10, 100, 100).Name = "shpTwo"
$shapes.AddShape($msoShapeIsoscelesTriangle, 300, 10, 100, 100).Name = "shpThree"
$range = $shapes.Range(@("shpOne", "shpTwo", "shpThree"))
$group = $range.Group()
$t = [Microsoft.Office.Core.MsoPresetTexture]
$group.Fill.PresetTextured($t::msoTextureBlueTissuePaper)
$group.GroupItems.Item(2).Fill.PresetTextured($t::msoTextureGreenMarble)
