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


			#Increase the t-value towards 1.
			boid.lerp_t += delta * 0.1
			#Make sure the t-value is never below 0 or above 1.
			boid.lerp_t = clamp(boid.lerp_t, 0.0, 1.0)
			#Perform the actual lerp
			boid.direction = boid.direction.lerp(boid.desired_direction, boid.lerp_t)
		
		#Important! Always normalize the direction before applying it.
		boid.direction = boid.direction.normalized()
		
		#Move boid forward in the current direction
		elif boid.position.x < 0:
			boid.position.x = background.size.x
		elif boid.position.x > background.size.x:
			boid.position.x = 0
	
	queue_redraw()
	
func steering_random() -> Vector2:
	return Vector2(randf_range(-1, 1), randf_range(-1, 1))
