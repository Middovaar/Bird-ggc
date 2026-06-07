extends Node2D

@export var HeadPage:int

@onready var NextPage

signal HitUpNextPage()


func _input(_event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Jump"):
		emit_signal("HitUpNextPage")
		match HeadPage:
			1:
				Page1()
			2:
				Page2()
			3:
				Page3()
			4:
				Page4()
			5:
				Page5()
			6:
				Page6()
			7:
				Page7()

func Page1():
	GetSceneTreeToDeleteTimers()
	get_node("1p1").position = get_node("1p1").FinalPosition1
	get_node("1p2").position = get_node("1p2").FinalPosition2
	get_node("1p3").position = get_node("1p3").FinalPosition3
	get_node("1p4").position = get_node("1p4").FinalPosition4
	for i in 50:
		get_node("1p1").TimeToMove = false
		get_node("1p2").TimeToMove = false
		get_node("1p3").TimeToMove = false
		get_node("1p4").TimeToMove = false
		get_node("1p1").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("1p2").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("1p3").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("1p4").position.y += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout

func Page2():
	GetSceneTreeToDeleteTimers()
	get_node("2p1").position = get_node("2p1").FinalPosition1
	get_node("2p2").position = get_node("2p2").FinalPosition2
	get_node("2p3").position = get_node("2p3").FinalPosition3
	get_node("2p4").position = get_node("2p4").FinalPosition4
	get_node("2p5").position = get_node("2p5").FinalPosition5
	for i in 50:
		get_node("2p1").TimeToMove = false
		get_node("2p2").TimeToMove = false
		get_node("2p3").TimeToMove = false
		get_node("2p4").TimeToMove = false
		get_node("2p5").TimeToMove = false
		get_node("2p1").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("2p2").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("2p3").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("2p4").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("2p5").position.y += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout

func Page3():
	GetSceneTreeToDeleteTimers()
	get_node("3p1").position = get_node("3p1").FinalPosition1
	get_node("3p2").position = get_node("3p2").FinalPosition2
	get_node("3p3").position = get_node("3p3").FinalPosition3
	get_node("3p4").position = get_node("3p4").FinalPosition4
	for i in 50:
		get_node("3p1").TimeToMove = false
		get_node("3p2").TimeToMove = false
		get_node("3p3").TimeToMove = false
		get_node("3p4").TimeToMove = false
		get_node("3p1").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("3p2").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("3p3").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("3p4").position.x += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout

func Page4():
	GetSceneTreeToDeleteTimers()
	get_node("4p1").position = get_node("4p1").FinalPosition1
	get_node("4p2").position = get_node("4p2").FinalPosition2
	get_node("4p3").position = get_node("4p3").FinalPosition3
	for i in 50:
		get_node("4p1").TimeToMove = false
		get_node("4p2").TimeToMove = false
		get_node("4p3").TimeToMove = false
		get_node("4p1").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("4p2").position.x += clamp(30.0, -2500.0, 2500.0)
		get_node("4p3").position.x -= clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout

func Page5():
	GetSceneTreeToDeleteTimers()
	get_node("5p1").position = get_node("5p1").FinalPosition1
	get_node("5p2").position = get_node("5p2").FinalPosition2
	get_node("5p3").position = get_node("5p3").FinalPosition3
	get_node("5p4").position = get_node("5p4").FinalPosition4
	get_node("5p5").position = get_node("5p5").FinalPosition5
	get_node("5p6").position = get_node("5p6").FinalPosition6
	get_node("5p7").position = get_node("5p7").FinalPosition7
	get_node("5p8").position = get_node("5p8").FinalPosition8
	get_node("5p9").position = get_node("5p9").FinalPosition9
	
	for i in 50:
		get_node("5p1").TimeToMove = false
		get_node("5p2").TimeToMove = false
		get_node("5p3").TimeToMove = false
		get_node("5p4").TimeToMove = false
		get_node("5p5").TimeToMove = false
		get_node("5p6").TimeToMove = false
		get_node("5p7").TimeToMove = false
		get_node("5p8").TimeToMove = false
		get_node("5p9").TimeToMove = false
		
		get_node("5p1").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("5p2").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("5p3").position.y -= clamp(30.0, -2500.0, 2500.0)
		get_node("5p4").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("5p5").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("5p6").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("5p7").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("5p8").position.y += clamp(30.0, -2500.0, 2500.0)
		get_node("5p9").position.y += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout

func Page6():
	GetSceneTreeToDeleteTimers()
	get_node("6p1").position = get_node("6p1").FinalPosition1
	get_node("6p2").position = get_node("6p2").FinalPosition2
	get_node("6p3").position = get_node("6p3").FinalPosition3
	get_node("6p4").position = get_node("6p4").FinalPosition4
	get_node("6p5").position = get_node("6p5").FinalPosition5
	for i in 50:
		get_node("6p1").TimeToMove = false
		get_node("6p2").TimeToMove = false
		get_node("6p3").TimeToMove = false
		get_node("6p4").TimeToMove = false
		get_node("6p5").TimeToMove = false
		get_node("6p1").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("6p2").position.x += clamp(30.0, -2500.0, 2500.0)
		get_node("6p3").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("6p4").position.x += clamp(30.0, -2500.0, 2500.0)
		get_node("6p5").position.y += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout



func Page7():
	GetSceneTreeToDeleteTimers()
	get_node("7p1").position = Vector2(575.0, 215.0)
	get_node("7p2").position = Vector2(1300.0, 215.0)
	get_node("7p3").position = Vector2(690.0, 770.0)
	get_node("7p4").position = Vector2(1420.0, 770.0)
	for i in 50:
		get_node("7p1").TimeToMove = false
		get_node("7p2").TimeToMove = false
		get_node("7p3").TimeToMove = false
		get_node("7p4").TimeToMove = false
		get_node("7p1").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("7p2").position.x += clamp(30.0, -2500.0, 2500.0)
		get_node("7p3").position.x -= clamp(30.0, -2500.0, 2500.0)
		get_node("7p4").position.x += clamp(30.0, -2500.0, 2500.0)
		await get_tree().create_timer(0.01).timeout


## Allows to hot-skip a comic page
func GetSceneTreeToDeleteTimers():
	var current_scene = get_tree().current_scene
	if current_scene:
		free_all_timers_in(current_scene)

func free_all_timers_in(parent_node: Node) -> void:
	if not parent_node:
		return
	
	for i in range(parent_node.get_child_count() - 1, -1, -1):
		var child = parent_node.get_child(i)
		
		if child is Timer:
			child.queue_free()
		else:
			free_all_timers_in(child)
