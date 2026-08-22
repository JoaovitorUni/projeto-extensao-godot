extends RefCounted
class_name WaveBudgetGenerator

## Recebe as regras da onda e gera a fila sorteada de EnemyData baseada no orçamento.
static func generate_spawn_queue(wave_data: WaveData) -> Array[EnemyData]:
	var queue: Array[EnemyData] = []

	if not WaveBudgetGenerator._validate_data(wave_data):
		return queue

	var remaining_budget: int = wave_data.total_budget

	# Algoritmo de Sorteio de Orçamento (Draft Loop)
	while remaining_budget > 0:
		var enemies: Array[EnemyData] = WaveBudgetGenerator._get_affordable_enemies(remaining_budget, wave_data.allowed_enemies)

		if enemies.is_empty():
			break

		var selected_enemy: EnemyData = enemies.pick_random()
		queue.append(selected_enemy)
		
		remaining_budget -= selected_enemy.spawn_cost

	return queue

static func _validate_data(wave_data: WaveData) -> bool:
	if not wave_data:
		push_error("WaveBudgetGenerator: 'wave_data' (WaveData) é obrigatório.")
		return false

	if wave_data.allowed_enemies.is_empty():
		push_warning("WaveBudgetGenerator: NENHUM EnemyData permitido nesta onda.")
		return false

	for enemy in wave_data.allowed_enemies:
		if enemy == null and enemy.spawn_cost <= 0:
			push_warning("WaveBudgetGenerator: NENHUM EnemyData válido foi atribuído nesta onda.")
			return false

	return true

## Pega todos os inimigos cujo custo é menor que o orçamento
static func _get_affordable_enemies(budget: int, allowed_enemies: Array[EnemyData]) -> Array[EnemyData]:
	var affordable_enemies: Array[EnemyData] = []
	for enemy in allowed_enemies:
		if enemy.spawn_cost <= budget:
			affordable_enemies.append(enemy)

	return affordable_enemies
