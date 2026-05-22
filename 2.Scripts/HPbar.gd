extends Control

@export var Boss:Node

const ZeroHPDisplacement:float = 250.0
const ZeroBossHPDisplacement:float = 250.0
var CurrentPlayerHPDisplacement:float = 0.0
var CurrentBossHPDisplacement:float = 0.0
var scanner:float = 0.0

const BossHPBarActivePosition:float = 2460

func _process(delta):
	CurrentPlayerHPDisplacement = HPtoPositionConverter(%Player.CurrentHP)
	if Boss != null:
		CurrentBossHPDisplacement = BossHPtoPositionConverter(%Boss.BossHP)
		lerpf(position.x, BossHPBarActivePosition, 0.25)
	else:
		CurrentBossHPDisplacement = -2000
	
	$HPMask.offset.x = lerpf($HPMask.offset.x, CurrentPlayerHPDisplacement, 0.15)
	#This is the white-ish mask that appears when hurt
	$HPLingMask.offset.x = lerpf($HPLingMask.offset.x, $HPMask.offset.x, 0.04)
	
	$BossHPFrame/BossHPMask.offset.x = lerpf(-$HPMask.offset.x, -CurrentBossHPDisplacement, 0.15)
	
func HPtoPositionConverter(HP):
	var HPPercentage = HP*100 / %Player.MaxHP
	HPPercentage*10/4 
	return -ZeroHPDisplacement + (HPPercentage*10/4) 

func BossHPtoPositionConverter(HP):
	var HPPercentage = HP*100 / %Boss.MaxHP
	HPPercentage*10/4
	return -ZeroBossHPDisplacement + (HPPercentage*10/4)
