extends Node2D

@onready var background: ColorRect = $ColorRect

#En lista av "boids"
#Boid är en class
#Varje enskild boid måste ha: (position, direction), speed, behaviour
#"Wrappa" varje enskild boid till spelytan (ColorRect)


@export var random_weight = 1.0

class Boid: 
	var position: Vector2
	var direction: Vector2
	var desired_direction: Vector2
	var speed: float
	var lerp_t: float = 0
	var random_timer: float

var boids : Array[Boid] = []


# Called when the node enters the scene tree for the first time.

# Wrapping: 
# X + - och Y + - 
# position.y > 0 = boid är ovanför skärmen 
# position.y < background.size.y = boid är under skärmen
# position.x < 0 = it is left of the backround
# position.x > backround.size.x = höger om skärmen

func _ready() -> void:
	for i in range(100):
		var boid : Boid = Boid.new()
		boid.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		boid.desired_direction = boid.direction
		boid.position = Vector2(background.size.x / 2, background.size.y / 2) 
		boid.speed = randf_range(40, 225)
		
		boids.append(boid)

func _draw() -> void: 
	for boid in boids:
		draw_circle(boid.position, 5, Color.HONEYDEW)
		
#position += direction * speed * delta
#position = position + direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.

#TODO:
# 1. Comment out all lerping and make it work with direct rotations (so no lerping). 
# 2. We want to break out the wander component of the _process() function. Wander should be its own function. 
# 3. The wander function should return a unit vector (Vector2 direction) and nothing else. 
# 4. I've marked in the code what section should be in its own wander function.

func _process(delta: float) -> void:
	for boid in boids:
		
		#Wander function starts here
		
		boid.random_timer -= delta
		
		#When random timer reaches 0, we update the direction of the wander.
		if boid.random_timer <= 0:
			#var random_direction = steering_random()
			
			#Generate a random degree between -45 and 45 (90 degrees)
			var random_degree = randf_range(-45, 45)
			#Rotate the desired direction with the random degree, converted from degrees to radian.
			boid.desired_direction = boid.desired_direction.rotated(deg_to_rad(random_degree))
			
			#Set a random speed and timer
			boid.speed = randf_range(40, 225)
			boid.random_timer = randf_range (2, 5)
			boid.lerp_t = 0.0
		
		#Wander function ends here
		
		#Example for how it could look when all steering functions are finished:
		#var combined_vector: Vector2
	#	combined_vector += wander(boid) * WANDER_WEIGHT
	#	combined_vector += avoid(boid) * AVOID_WEIGHT
	#	combined_vector += group(boid) * GROUP_WEIGHT
		
		#As long as the current direction is not equal to the desired direction, we lerp towards it.
		if boid.direction != boid.desired_direction:
			#Increase the t-value towards 1.
			boid.lerp_t += delta * 0.1
			#Make sure the t-value is never below 0 or above 1.
			boid.lerp_t = clamp(boid.lerp_t, 0.0, 1.0)
			#Perform the actual lerp
			boid.direction = boid.direction.lerp(boid.desired_direction, boid.lerp_t)
		
		#Important! Always normalize the direction before applying it.
		boid.direction = boid.direction.normalized()
		
		#Move boid forward in the current direction
		boid.position += boid.direction * boid.speed * delta
		
		#Screen wrapping
		if boid.position.y < 0:
			boid.position.y = background.size.y
		elif boid.position.y > background.size.y:
			boid.position.y = 0
		elif boid.position.x < 0:
			boid.position.x = background.size.x
		elif boid.position.x > background.size.x:
			boid.position.x = 0
	
	queue_redraw()
	
func steering_random() -> Vector2:
	return Vector2(randf_range(-1, 1), randf_range(-1, 1))
