@tool
extends Node2D

## Making maps with noise functions
## https://www.redblobgames.com/maps/terrain-from-noise/#islands

## Generating Procedural Maps using Perlin Noise
## https://www.youtube.com/watch?v=6BdYzfVOyBY


@export var update_texrect: bool:
	set(value):
		create_island()

@export var noise : FastNoiseLite
@onready var texture_rect: TextureRect = $TextureRect


var w : int = 512
var h : int = 512
var maxd_var : float = .25

func _ready() -> void:
	create_island()


func create_island():
	var img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	var max_dist = sqrt(w * w * maxd_var + h * h * maxd_var)
	
	for i in range(w):
		for j in range(h):
			
			var n = noise.get_noise_2d(i, j) #  -1 .. 1
			# need 0 .. 1
			n = remap(n, -1, 1, 0, 1)

			var nx = w * .5 - i
			var ny = h * .5 - j
			var d = sqrt(nx * nx + ny * ny)
			var nd = .5 - 2 * d / max_dist
			
			n = n - nd
			n = remap(n, 0, 1, 1, 0)

			# Select Color .. can use a gradient or a simple color
			var color 
			if n < .2: # water
				color = Color.ROYAL_BLUE
			elif n < .25: # sand
				color = Color.BURLYWOOD
			else: # grass
				color = Color.SEA_GREEN
			
			img.set_pixel(i, j, color)

	texture_rect.texture = ImageTexture.create_from_image(img)
