extends Control

const ZeroHPDisplacement:float = 250.0
var CurrentDisplacement:float = 0.0
var scanner:float = 0.0

func _process(delta):
	CurrentDisplacement = HPtoPositionConverter(%Player.CurrentHP)
	$HPMask.offset.x = lerpf($HPMask.offset.x, CurrentDisplacement, 0.15)
	$HPLingMask.offset.x = lerpf($HPLingMask.offset.x, $HPMask.offset.x, 0.04)
	
	$BossHPFrame/BossHPMask.offset.x = lerpf(-$HPMask.offset.x, -CurrentDisplacement, 0.15)
	
func HPtoPositionConverter(HP):
	var HPPercentage = HP*100 / %Player.MaxHP
	
	HPPercentage*10/4 
	
	return -ZeroHPDisplacement + (HPPercentage*10/4) 
