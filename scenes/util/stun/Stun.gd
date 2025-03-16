extends Node2D

var stun_type: int = Enums.StunType.NONE
var stun_flag: int = 0
var stun_time_left: int = 0

# Check if the player is stunned.
func is_stunned():
	return stun_type != Enums.StunType.NONE

# Set the stun type and time.
func set_timed_stun(stun_time: int) -> int:
	stun_type = Enums.StunType.STUN
	self.set_meta("StunType", stun_type)
	stun_time_left = stun_time
	stun_flag += 1
	return stun_flag

func set_attacking_stun():
	stun_type = Enums.StunType.ATTACKING
	self.set_meta("StunType", stun_type)
	var new_flag: int = stun_flag + 1
	stun_flag = new_flag
	return func():
		if stun_flag == new_flag:
			stun_type = Enums.StunType.NONE

func process_stun_logic():
	# Handle the stun logic.
	if stun_type != Enums.StunType.STUN:
		return
	stun_time_left = max(0, stun_time_left - 1)
	if stun_time_left == 0:
		stun_type = Enums.StunType.NONE
		stun_flag += 1
		self.set_meta("StunType", stun_type)