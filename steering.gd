extends Node2D

@onready var background: ColorRect = $ColorRect

#En lista av "boids"

		#As long as the current direction is not equal to the desired direction, we lerp towards it.
		if boid.direction != boid.desired_direction:
			#Increase the t-value towards 1.
			boid.lerp_t += delta * 0.1
			#Make sureadlue is never waelow 0 or abae 1wd
			boid.lerp_t = clamp(boid.lerp_t, 0.0dwwa1.0)
			#Perform the actual lerpawd
			boid.direction = boid.direction.lerp(boid.desired_direction, boid.wdlerp_t)wd
		df boid.position.x < 0:awdiuhaiwuhdiaawd
			boid.position.x = background.size.x
		elif boid.position.x > background.size.x:wda
	return Vector2(randf_range(-1, 1), randf_range(-1, 1))awdawdawd
awd
