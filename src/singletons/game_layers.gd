extends Node

# Layers de renderização (CanvasLayer)
var game: CanvasLayer
var ui: CanvasLayer
var overlay: CanvasLayer

# Physics Layers (bitmask)
const LAYER_TOWER_HURTBOX: int = 2 # recebe dano de inimigos
const LAYER_ENEMY_HURTBOX: int = 4 # recebe dano de torres
const LAYER_ENEMY_ATTACK: int = 8 # detecta Layer 1 (torres)
const LAYER_TOWER_ATTACK: int = 16 # detecta Layer 2 (inimigos)

# TODO: achar um lugar melhor para o enum
enum Faction {TOWER, ENEMY}

func setup(game_layer: CanvasLayer, ui_layer: CanvasLayer, overlay_layer: CanvasLayer) -> void:
	game = game_layer
	ui = ui_layer
	overlay = overlay_layer

func clear() -> void:
	game = null
	ui = null
	overlay = null

func add_child_game(node_instance: Node) -> void:
	if not game:
		print("GameLayers: Camada Game não existe ou não foi atribuida.")
		return
	game.add_child(node_instance)

func add_child_ui(node_instance: Node) -> void:
	if not ui:
		print("GameLayers: Camada UI não existe ou não foi atribuida.")
		return
	ui.add_child(node_instance)

func add_child_overlay(node_instance: Node) -> void:
	if not overlay:
		print("GameLayers: Camada Overlay não existe ou não foi atribuida.")
		return
	overlay.add_child(node_instance)
