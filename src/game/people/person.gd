class_name Person

const Enums = preload("res://src/game/enums.gd")
const Trait = preload("res://src/game/traits/trait.gd")

var id: int
var name: String
var assignment: int
var race: int # Race enum
var traits: Array # array of traits that apply to this Person
var texture: Texture

func get_individual_resource_effect(resource: int) -> int:
	var amount_to_adjust = 1
	for trait in traits:
		if trait.trait_type == Enums.TraitTypes.GENERATIVE_EFFECT && trait.resource_affected == resource:
			amount_to_adjust += trait.generative_effect

	return amount_to_adjust

func get_needs() -> Array:
	var needs = []
	for trait in traits:
		if trait.trait_type == Enums.TraitTypes.NEED:
			needs.append(trait)
	return needs
