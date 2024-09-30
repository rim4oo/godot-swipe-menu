extends ScrollContainer

@export var card_scale: float = 1.0
@export var card_current_scale: float = 1.3
@export var scroll_duration: float = 0.3

var card_current_index: int = 1
var card_x_positions: Array = []
var scroll_tween: Tween
var scrollContainer = get_parent()

@onready var margin_r: int = $CenterContainer/MarginContainer.get_theme_constant("margin_right")
@onready var card_space: int = $CenterContainer/MarginContainer.get_theme_constant("separation")
@onready var card_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()

func _ready() -> void:
	await get_tree().create_timer(0).timeout
	get_h_scroll_bar().modulate.a = 0
	for _card in card_nodes:
		var _card_pos_x: float = (margin_r + _card.position.x) - ((size.x - _card.size.x) / 2)
		_card.pivot_offset = (_card.size / 2)
		card_x_positions.append(_card_pos_x)

	if card_x_positions.size() > 0:
		scroll_horizontal = card_x_positions[card_current_index]
		scroll()

func _process(delta: float) -> void:
	if card_x_positions.size() == 0:
		return  # Если массив пуст, выходим из функции

	for _index in range(card_x_positions.size()):
		var _card_pos_x: float = card_x_positions[_index]
		var _swipe_length: float = (card_nodes[_index].size.x / 2) + (card_space / 2)
		var _swipe_current_length: float = abs(_card_pos_x - scroll_horizontal)
		var _card_scale: float = remap(_swipe_current_length, _swipe_length, 0, card_scale, card_current_scale)
		var _card_opacity: float = remap(_swipe_current_length, _swipe_length, 0, 0.3, 1)
		_card_scale = clamp(_card_scale, card_scale, card_current_scale)
		_card_opacity = clamp(_card_opacity, 0.3, 1)
		card_nodes[_index].scale = Vector2(_card_scale, _card_scale)
		card_nodes[_index].modulate.a = _card_opacity

		if _swipe_current_length < _swipe_length and _index != card_current_index:
			card_current_index = _index
		

func scroll() -> void:
	if card_x_positions.size() == 0:
		return  # Если массив пуст, выходим из функции

func _on_scroll_ended():
	var sss = create_tween()
	sss.tween_property(
		self,
		"scroll_horizontal",
		card_x_positions[card_current_index],
		scroll_duration
	)
