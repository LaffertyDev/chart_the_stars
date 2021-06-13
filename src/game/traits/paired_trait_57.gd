extends PairedTrait

func _init():
    self.title = "Pair 57 T"
    self.description = "Paire 57 D"
    self.player_affected_1_id = 5
    self.player_affected_2_id = 7

func apply_pair_effect(resourceManager: ResourceManager) -> void:
    resourceManager.human_water_delta += 100

func apply_pair_effect_on_cycle() -> void:
    pass