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
		boid.position = Vector2(background.size.x / 2, background.size.y / 2) 
		boid.speed = randf_range(40, 225)
		
		boids.append(boid)

func _draw() -> void: 
	for boid in boids:
		draw_circle(boid.position, 5, Color.HONEYDEW)
		
#position += direction * speed * delta
#position = position + direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for boid in boids:
		
		boid.random_timer -= delta
		
		if boid.random_timer <= 0:
			var random_direction = steering_random()
			boid.desired_direction = random_direction
			boid.speed = randf_range(40, 225)
			print("new direction")
			boid.random_timer = randf_range (2, 8)
			boid.lerp_t = 0.0
		
		if boid.direction != boid.desired_direction:
			boid.lerp_t += delta
			boid.lerp_t = clamp(boid.lerp_t, 0.0, 1.0)
			boid.direction = boid.direction.lerp(boid.desired_direction, boid.lerp_t)
		
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
