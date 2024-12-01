extends Object
class_name Gun

var sound:AudioStream
var damage_bonus:float
var name:StringName

var las_gun:bool = false

func setup(n:StringName,s:String,d:float)->Gun:
	name = n
	sound = load(s)
	damage_bonus = d
	return self
	
