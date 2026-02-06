extends Resource
class_name CurrencyReference

enum Type
{
	ActionPoints,  
	Radiation,
	Temperature,
	Energy,
	SafetyPoints,
	VictoryPoints,
	Difficulty,
}

@export var type : Type
@export var value : float
