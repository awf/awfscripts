param($images)
# e.g.
# $images = dir C:\users\awf\Images\awf\Basement\png\bt.* | %{import-bitmap $_.fullname}
#  awf-imshow $images

$images = @($images)
if ($images.length -lt 1) {
  echo "ERROR: Need array of images"
  return
}

$warned = $false
for($i = 0; $i -lt $images.length; ++$i) {
  $type = $images[$i].GetType()
  if (-not (($type -eq [System.Drawing.Bitmap]) -or ($type -eq [System.String]))) {
    echo "awf-imshow: WARNING: Images[$i] is of type $($type.fullname)"
    $warned = $true
  }
  
}
if ($warned) {
  return
}

function make_image($image) {
  if ($image.GetType() -eq [System.Drawing.Bitmap]) {
    $image
  } else {
    # echo "Load $image"
    import-bitmap $image
  }
}

# Define interaction variables and event handlers
$script:current_frame = 0
$script:mousedown = @()

function goto_frame($i) {
  $frame_label.text = ("{0:00000}" -f $i)
  if (($script:current_frame -ne $i) -and 
      ($i -ge 0) -and
      ($i -lt $images.length)) {
    $script:current_frame = $i 
    $picbox.Image = make_image $images[$script:current_frame];
  }
}

function prev {
  goto_frame ($script:current_frame-1)
}

function next {
  goto_frame ($script:current_frame+1)
}

function mousedown($e) {
  $dx0 = [int]$script:current_frame - $e.x
  # write-host ("($($e.x),$($e.y),$script:current_frame,$dx0)")
  $script:mousedown = ($e.x, $e.y, $e.button, $dx0)
}

function mousemove($e) {
  $x = $e.x
  $y = $e.y
  if ($e.button -eq 'Left') {
    if ($script:mousedown.length -ne 4) {
       $frame_label.text = "ERROR:$($mousedown.length)"
    } else {
      # write-host ("($x,$y)" + $script:mousedown[3].ToString())
      goto_frame ($script:mousedown[3] + $x)
    }
  }
}

function mouseup($e) {
  # write-host "UP $script:mousedown"
  $script:mousedown = @()
}

############### BEGIN MAIN #########################
# Load forms library utilities
. awf_winform

# lay out form
$form = wf_form Form @{
    Text = "imshow"
    StartPosition = "CenterScreen"
}

$Form.SuspendLayout()

# load first image to get size
$o = make_image $images[0]
$o.ToString()
$picbox = wf_form PictureBox @{
  Size = wf_size ([Math]::max($o.Width,160)) ([Math]::max($o.Height,120))
}
$picbox.Image = $o

$buttons = @(
  "Quit", {$form.Close()},
  "Prev", {prev},
  "Next", {next}
)

$allbuttons = @{}
for($b = 0; $b -lt ($buttons.length/2); ++$b) { 
  $label = $buttons[$b*2 + 0]
  $allbuttons.$label = wf_form Button @{
                Location = wf_point (3 + 53*$b) 3
                Size = wf_size 50 20 
                TabIndex = (1+$b)
                Text = $label
              }
  $allbuttons.$label.add_click($buttons[$b*2+1])
  $form.controls.add($allbuttons.$label)
}
$frame_label = wf_form Label @{
    Location = wf_point ($picbox.Size.Width - 53) 3
    Size = wf_size 50 20
    Text = '######'
}
$form.controls.add($frame_label)

# Add event handlers
$picbox.add_MouseDown({mousedown $_})
$picbox.add_MouseMove({mousemove $_})
$picbox.add_MouseUp({mouseup $_})
$form.controls.add($picbox)
$picbox.add_KeyPress({ write-host $_.ToString() })


# MainForm
$Form.ClientSize = $picbox.Size

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
