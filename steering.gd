extends Node2D

@onready var background: ColorRect = $ColorRect

#En lista av "boids"
#Boid är en class
#Varje enskild boid måste ha: (position, direction), speed, behaviour
#"Wrappa" varje enskild boid till spelytan (ColorRect)

class Boid: 
	var position: Vector2
	var direction: Vector2
	var speed: float

var boids : Array[Boid] = []


# Called when the node enters the scene tree for the first time.

# Wrapping: 
# X + - och Y + - 
# position.y > 0 = boid är ovanför skärmen 
# position.y < background.size.y = boid är under skärmen
# position.x < 0 = it is left of the backround
# position.x > backround.size.x = höger om skärmen

func _ready() -> void:
	for i in range(1000):
		var x : Boid = Boid.new()
		x.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		x.position = Vector2(background.size.x / 2, background.size.y / 2) 
		x.speed = randf() * 100
		
		boids.append(x)

func _draw() -> void: 
	for boid in boids:
		draw_circle(boid.position, 5, Color.HONEYDEW)
		
#position += direction * speed * delta
#position = position + direction * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for boid in boids:
		boid.position += boid.direction * boid.speed * delta
		
		if boid.position.y < 0:
			boid.position.y = background.size.y
		elif boid.position.y > background.size.y:
			boid.position.y = 0
		elif background.position.x < 0:
			boid.position.x = background.size.x
		elif boid.position.x > background.size.x:
			boid.position.x = 0
	queue_redraw()
	
