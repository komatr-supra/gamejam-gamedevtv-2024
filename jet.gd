extends Node2D

func _ready():
	$GPUParticles2D.emitting = false
	
func thrust(is_active:bool):
	if($GPUParticles2D.emitting != is_active):
		$GPUParticles2D.emitting = is_active
