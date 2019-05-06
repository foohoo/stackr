extends StaticBody2D

var is_on = false

func _ready():
	$CubeOn.set_visible(false)
	$CubeOff.set_visible(true)

func toggle():
	if $CubeOn.is_visible():
		$CubeOn.set_visible(false)
		$CubeOff.set_visible(true)
		is_on = false
	else:
		$CubeOn.set_visible(true)
		$CubeOff.set_visible(false)
		is_on = true

func turn_off():
	$CubeOn.set_visible(false)
	$CubeOff.set_visible(true)
	is_on = false

func is_on():
	return is_on