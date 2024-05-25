extends Node2D


	
	
func thrust(is_active:bool):
	if($GPUParticles2D.emitting != is_active):
		$GPUParticles2D.emitting = is_active
