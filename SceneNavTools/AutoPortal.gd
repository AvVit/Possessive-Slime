extends Portal
class_name AutoPortal


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if(body is Mouse):
		print(body.name, " Entered")
		triggered.emit(self, body)
