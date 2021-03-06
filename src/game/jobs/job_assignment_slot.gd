extends Control

const Person = preload("res://src/game/people/person.gd")
const Enums = preload("res://src/game/enums.gd")
const JobTypes = preload("res://src/game/jobs/job_types.gd")
const TraitManager = preload("res://src/game/traits/trait_manager.gd")

signal job_assignment_changed()
var assigned_person: Person
var job_type: int

func _ready():
	add_to_group("post_cycleables")
	$HBoxContainer/button_assign.show()
	$HBoxContainer/slot_icon.hide()
	$HBoxContainer/slot_name.hide()

func _on_button_assign_pressed():
	var job_assignment_popup = PopupMenu.new()
	var personManager = get_tree().get_nodes_in_group("game_root")[0].person_manager
	var unassignedPersons = personManager.get_unassigned_persons()
	var person_idx = 0
	for person in unassignedPersons:
		job_assignment_popup.add_icon_item(person.texture, person.name, person.id)
		if job_type != JobTypes.JobTypes.chart_stars:
			var tooltip = TraitManager.get_traits_description(person, TraitManager.get_resources_affected_by_job(job_type), false)
			job_assignment_popup.set_item_tooltip(person_idx, tooltip)
			person_idx += 1

	add_child(job_assignment_popup)
	job_assignment_popup.popup_centered()
	job_assignment_popup.connect('modal_closed', job_assignment_popup, 'queue_free')
	job_assignment_popup.connect('id_pressed', self, '_on_assignment_selected')

func _on_assignment_selected(id: int) -> void:
	var personManager = get_tree().get_nodes_in_group("game_root")[0].person_manager
	var person = personManager.get_person_by_id(id)
	personManager.assign_person(person, job_type)
	assigned_person = person
	$HBoxContainer/button_assign.hide()
	$HBoxContainer/slot_name.show()
	$HBoxContainer/slot_icon.show()
	$HBoxContainer/slot_icon.texture = assigned_person.texture
	$HBoxContainer/slot_effects.show()
	$HBoxContainer/slot_name.set_text(assigned_person.name)
	$HBoxContainer/slot_effects.set_text(TraitManager.get_traits_description(person, TraitManager.get_resources_affected_by_job(job_type), true))
	emit_signal("job_assignment_changed")
		
func _on_post_cycle():
	if assigned_person != null:
		var personManager = get_tree().get_nodes_in_group("game_root")[0].person_manager
		personManager.unassign_person(assigned_person)
		assigned_person = null
		$HBoxContainer/button_assign.show()
		$HBoxContainer/slot_name.hide()
		$HBoxContainer/slot_icon.hide()
		$HBoxContainer/slot_effects.hide()
		emit_signal("job_assignment_changed")
