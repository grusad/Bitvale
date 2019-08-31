extends Node

func vec3_to_dict(vec3):
	var data = {
		"x" : vec3.x,
		"y" : vec3.y,
		"z" : vec3.z
	}
	return data

func dict_to_vec3(dict):
	var vec3 = Vector3()
	vec3.x = dict["x"]
	vec3.y = dict["y"]
	vec3.z = dict["z"]
	return vec3