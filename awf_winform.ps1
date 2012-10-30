#
# Windows PowerShell in Action
#
# Chapter 11 winform Library functions
#
# This script defines a library of functions that help
# with building WinForm applications in PowerShell. This
# library is used by other examples in chapter 11.
#

[void][reflection.assembly]::LoadWithPartialName("System.Drawing")
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

function wf_point {new-object System.Drawing.Point $args}
function wf_size {new-object System.Drawing.Size $args}
function wf_form ($control, $properties)
{
    $c = new-object "Windows.Forms.$control"
    if ($properties)
    {
        foreach ($prop in $properties.keys)
        {
            $c.$prop = $properties[$prop]
        }
    }
    $c
}

function wf_drawing ($control,$constructor,$properties)
{
    $c = new-object "Drawing.$control" $constructor
    if ($properties.count)
    {
        foreach ($prop in $properties.keys) {$c.$prop = $properties[$prop]}
    }
    $c
}


function wf_RightEdge ($x, $offset=01)
{
    $x.Location.X + $x.Size.Width + $offset
}
function wf_LeftEdge ($x, $offset=1)
{
    $x.Location.X
}
function wf_BottomEdge ($x, $offset=1)
{
    $x.Location.Y + $x.Size.Height + $offset
}
function wf_TopEdge ($x, $offset=1) {
    $x.Location.Y
}

function wf_message ($string, $title='PowerShell Message')
{ 
    [windows.forms.messagebox]::Show($string, $title)
}

function New-Menustrip ($form, $menu)
{
    $ms = wf_form MenuStrip
    [void]$ms.Items.AddRange((&$menu))
    $form.MainMenuStrip = $ms
    $ms
}
function New-Menu($name,$items)
{
    $menu = wf_form ToolStripMenuItem @{Text = $name}
    [void] $menu.DropDownItems.AddRange((&$items))
    $menu
}
function New-Menuitem($name,$action)
{
    $item = wf_form ToolStripMenuItem @{Text = $name}
    [void] $item.Add_Click($action)
    $item
}
function New-Separator { wf_form ToolStripSeparator }

function wf_style ($rowOrColumn="row",$percent=-1)
{
    if ($percent -eq -1)
    {
        $typeArgs = "AutoSize"
    }
    else
    {
        $typeArgs = "Percent",$percent
    }
    new-object Windows.Forms.${rowOrColumn}Style $typeArgs
}

