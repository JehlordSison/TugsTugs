extends Node2D

func _ready():
	play_effect()

func play_effect() -> void:
	# Get all particle nodes
	var particles: Array = [$CPUParticles2D, $CPUParticles2D2, $CPUParticles2D3, $CPUParticles2D4]
	
	# Option 1: Play only ONE random particle
	var random_particle1 = particles[randi() % particles.size()]
	var random_particle2 = particles[randi() % particles.size()]
	random_particle1.emitting = true
	if(random_particle1 != random_particle2):
		random_particle2.emitting = true
