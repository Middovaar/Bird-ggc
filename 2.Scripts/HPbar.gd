extends Control


@export_category("Text Properties")
@export_range(0.01, 1.00, 0.01,"or_greater", "suffix:sec") var AnimationSpeed:float = 0.08

@export var Boss:Node
@onready var DialoguePath = "res://Dialogue/Dialogue.json"
# Dialogue Singleton
var Dialogue: Dictionary = {} 

## Other Dialogue Handler Variables and fascilitators
@export var Klo:Node
var DisplayedText = ""
var TextIsAnimated = false
var TextCompounder:int = 0
var ReadyText:Array 
var MayCloseEarly = false
var FadeInNamePlate = false
var WhatDialogueAreWeAt:String
var BossActive:bool

signal dummythicc()
var dummydone:bool = true

var DontHandoverTwice:bool = true

signal DialogueHandover(WhatDialogue, HandoverBool)

const ZeroHPDisplacement:float = 250.0
const ZeroBossHPDisplacement:float = 280.0
var CurrentPlayerHPDisplacement:float = 0.0
var CurrentBossHPDisplacement:float = 0.0
var scanner:float = 0.0

## Klo HP Percentage Calculator
var KloeHPFraction:float = 1.000

const BossHPBarActivePosition:float = 2460

func _ready():
	#region that contains Loads the Dialogue Data into Variable Form
	var file = FileAccess.open(DialoguePath, FileAccess.READ)
	var parser = file.get_as_text()
	var jsonObject = JSON.new()
	#region Error Handler
	#region Error Handler
	assert(file.file_exists(DialoguePath), "Attempted to load Json, and json does not exist!")
	#endregion
	jsonObject.parse(parser)
	Dialogue = jsonObject.data
	%TextBox.text = "" #Nulls the text box

func RenderText(DialogueUUID):
	# Detects how many lines of texts there are in a given dialogue block
	if TextCompounder == 0 or TextCompounder == null:
		TextCompounder = DialogueItemBoard(DialogueUUID)
	#The array containing the actively rendered text
	if DialogueSwitchBoard(DialogueUUID+TextCompounder-1) is Array:
		ReadyText = DialogueSwitchBoard(DialogueUUID+TextCompounder-1)
	else:
		FadeInNamePlate = false
		if DontHandoverTwice == false:
			InitializeDialogueHandover(WhatDialogueAreWeAt)
			DontHandoverTwice = true

# Recursively renders out each text segment in the Readied Text until empty
	for TextSegmentCounter in ReadyText.size():
		TextIsAnimated = true
		DisplayedText += ReadyText[TextSegmentCounter]
		await get_tree().create_timer(AnimationSpeed).timeout
		%TextBox.text = DisplayedText
	
	TextCompounder -= 1
	TextIsAnimated = false
	await %Space.ExpectedPress
	if TextCompounder != 0:
		DialogueClear()
		RenderText(DialogueUUID)
	else:
		
		emit_signal("FinishedDialogueBlock", DialogueUUID)
		DialogueClear()

func DialogueClear():
	%TextBox.text = ""
	DisplayedText = ""
	ReadyText = []

func DialogueSwitchBoard(DialogueUUID):
	### DialogueSwitchBoard
	# This Function serves as a Switchboard that routes the appropraite dialogue
	# from the JSON to the RenderText Function
	# 
	# The Id, is catches here, and pushed as DialogueReq
	# Based on DialogueReq, run match and recieve the appropriate Dialogue.address
	var DialogueAdress
	match DialogueUUID:
		106:
			DialogueAdress = Dialogue.KloeStart.A
		105:
			DialogueAdress = Dialogue.KloeStart.B
		104:
			DialogueAdress = Dialogue.KloeStart.C
		103:
			DialogueAdress = Dialogue.KloeStart.D
		102:
			DialogueAdress = Dialogue.KloeStart.E
		101:
			DialogueAdress = Dialogue.KloeStart.F
		100:
			DialogueAdress = "exit"
	
	return DialogueAdress

func DialogueItemBoard(DialogueUUID):
	### DialogueItemBoard
	# This Function serves as a ItemTableLookup that grabs how many dialogue lines there is in a block
	# from the JSON to the RenderText Function
	# 
	# The Id, is catches here, and pushed as DialogueReq
	# Based on DialogueReq, run match and recieve the appropriate Dialogue.address
	var DialogueItems:int
	match DialogueUUID:
		105:
			DialogueItems = Dialogue.KloeStart.Items
		_:
			DialogueItems = 0
			
	return DialogueItems

func _process(delta):
	CurrentPlayerHPDisplacement = HPtoPositionConverter(%Player.CurrentHP)
	if Boss != null:
		CurrentBossHPDisplacement = BossHPtoPositionConverter(%Klo.CurrentHP)
	else:
		CurrentBossHPDisplacement = -2000
	
	%HPMask.offset.x = lerpf(%HPMask.offset.x, CurrentPlayerHPDisplacement, 0.15)
	#This is the white-ish mask that appears when hurt
	%HPLingMask.offset.x = lerpf(%HPLingMask.offset.x, %HPMask.offset.x, 0.04)
	
	if dummydone:
		$BossHPFrame/BossHPMask.offset.x = lerpf($BossHPFrame/BossHPMask.offset.x, BossHPtoPositionConverter(KloeHPFraction), 0.15)
	else:
		#print("Congratulations, You defeated Klo,  and you win! Ask Quinn and recieve your reward!")
		$BossHPFrame.position.x = lerpf($BossHPFrame.position.x, 3500.0, 0.3)
	
	if FadeInNamePlate:
		$DialogueBox.modulate = lerp($DialogueBox.modulate, Color.WHITE, 0.4)
		$DialogueBox/Name.modulate = lerp($DialogueBox/Name.modulate, Color.WHITE, 0.3)
	else:
		$DialogueBox.modulate = lerp($DialogueBox.modulate, Color.TRANSPARENT, 0.4)
		$DialogueBox/Name.modulate = lerp($DialogueBox/Name.modulate, Color.TRANSPARENT, 0.3)
		
	if BossActive:
		$BossHPFrame.position.x = lerp($BossHPFrame.position.x, BossHPBarActivePosition, 0.2)

func HPtoPositionConverter(HP) -> float:
	var HPPercentage = HP*100 / %Player.MaxHP
	return -ZeroHPDisplacement + (HPPercentage*10/4) 

func BossHPtoPositionConverter(HPFraction) -> float:
	return 0+(ZeroBossHPDisplacement*(1-HPFraction))

func _on_player_boss_dialogue_initializer(History):
	if TextIsAnimated != true:
		match History:
			"KloeStart":
				RenderText(DialoguetoDialogueUUIDTranslator("KloeStart"))
				WhatDialogueAreWeAt = "KloeStart"
				FadeInNamePlate = true
				DontHandoverTwice = false
				
			_:
				RenderText(DialoguetoDialogueUUIDTranslator("KloeStart"))

func DialoguetoDialogueUUIDTranslator(DialogueDesc:String) -> int:
	var TranslatedDialogueUUID:int
	match DialogueDesc:
		"KloeStart":
			TranslatedDialogueUUID = 107
			
		_:
			TranslatedDialogueUUID = 107
	
	
	return TranslatedDialogueUUID

func InitializeDialogueHandover(DialogueFlag):
	if DontHandoverTwice == false:
		emit_signal("DialogueHandover", DialogueFlag, DontHandoverTwice)
		DontHandoverTwice = true
	else:
		pass

func _on_player_bossfightis_open():
	BossActive = true

func _on_klo_isdonedefeated():
	dummydone = false
	emit_signal("dummythicc")
	


func _on_klo_kloe_current_hp(HP):
	KloeHPFraction = float(HP)/%Klo.MaxHP
	if HP <= 0:
		_on_klo_isdonedefeated()
