extends Resource
class_name WaveData

@export_category("Config")
@export var total_budget: int
@export var allowed_enemies: Array[EnemyData]
@export var max_duration: float
@export var spawn_interval: float # TODO: Futuramente podemos elaborar um algoritmo que deixe mais natural o spawn de inimigos
@export var is_big_wave: bool
