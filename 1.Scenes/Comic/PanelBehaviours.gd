extends Sprite2D


@export var PanelNumber:int

var FinalPosition1:Vector2 = Vector2.ZERO
var FinalPosition2:Vector2 = Vector2.ZERO
var FinalPosition3:Vector2 = Vector2.ZERO
var FinalPosition4:Vector2 = Vector2.ZERO
var FinalPosition5:Vector2 = Vector2.ZERO
var FinalPosition6:Vector2 = Vector2.ZERO
var FinalPosition7:Vector2 = Vector2.ZERO
var FinalPosition8:Vector2 = Vector2.ZERO
var FinalPosition9:Vector2 = Vector2.ZERO

@export_range(0.0, 1.0, 0.01, "suffix:/f") var LerpFraction = 0.10

var TimeToMove:bool = false

func _ready():
	match get_parent().HeadPage:
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
	
	
	if PanelNumber == 1:
		TimeToMove = true

func _process(_delta):
	if TimeToMove:
		match PanelNumber:
			1:
				self.position = lerp(self.position, FinalPosition1, LerpFraction)
			2:
				self.position = lerp(self.position, FinalPosition2, LerpFraction)
			3:
				self.position = lerp(self.position, FinalPosition3, LerpFraction)
			4:
				self.position = lerp(self.position, FinalPosition4, LerpFraction)
			5:
				self.position = lerp(self.position, FinalPosition5, LerpFraction)
			6:
				self.position = lerp(self.position, FinalPosition6, LerpFraction)
			7:
				self.position = lerp(self.position, FinalPosition7, LerpFraction)
			8:
				self.position = lerp(self.position, FinalPosition8, LerpFraction)
			9:
				self.position = lerp(self.position, FinalPosition9, LerpFraction)
			_:
				pass
	

func _on_timer_timeout():
	TimeToMove = true



func Page1():
	FinalPosition1 = Vector2(771.0, 340.0)
	FinalPosition2 = Vector2(1272.0, 340.0)
	FinalPosition3 = Vector2(703.0, 749.0)
	FinalPosition4 = Vector2(1185.0, 745.0)

func Page2():
	FinalPosition1 = Vector2(440.0, 215.0)
	FinalPosition2 = Vector2(960.0, 215.0)
	FinalPosition3 = Vector2(1570.0, 215.0)
	FinalPosition4 = Vector2(680.0, 720.0)
	FinalPosition5 = Vector2(1570.0, 720.0)

func Page3():
	FinalPosition1 = Vector2(375.0, 215.0)
	FinalPosition2 = Vector2(503.0, 470.0)
	FinalPosition3 = Vector2(625.0, 790.0)
	FinalPosition4 = Vector2(1370.0, 530.0)

func Page4():
	FinalPosition1 = Vector2(380.0, 215.0)
	FinalPosition2 = Vector2(1550.0, 600.0)
	FinalPosition3 = Vector2(630.0, 720.0)

func Page5():
	FinalPosition1 = Vector2(215.0, 215.0)
	FinalPosition2 = Vector2(985.0, 215.0)
	FinalPosition3 = Vector2(1690.0, 215.0)
	FinalPosition4 = Vector2(140.0, 580.0)
	FinalPosition5 = Vector2(390.0, 640.0)
	FinalPosition6 = Vector2(675.0, 740.0)
	FinalPosition7 = Vector2(950.0, 820.0)
	FinalPosition8 = Vector2(1140.0, 870.0)
	FinalPosition9 = Vector2(1525.0, 870.0)

func Page6():
	FinalPosition1 = Vector2(590.0, 215.0) 
	FinalPosition2 = Vector2(1215.0, 215.0)
	FinalPosition3 = Vector2(615.0, 550.0) 
	FinalPosition4 = Vector2(1240.0, 550.0)
	FinalPosition5 = Vector2(970.0, 890.0) 

func Page7():
	FinalPosition1 = Vector2(575.0, 215.0)
	FinalPosition2 = Vector2(1300.0, 215.0)
	FinalPosition3 = Vector2(690.0, 770.0)
	FinalPosition4 = Vector2(1420.0, 770.0)
