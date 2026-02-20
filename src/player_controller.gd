extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var MOUSE_SENSITIVITY : float = 0.5 
@export var INTERACT_RANGE : float = 10

@onready var CAMERA_CONTROLLER = $Camera3D
@onready var fire_ray = $Camera3D/RayCast3D
@onready var inventory = $Inventory
@onready var hud = $Camera3D/HUD
@onready var mug_held = $Camera3D/MugHeld

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

var player_interactable_area

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 0.5) * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_camera(delta)
	var result = shoot_mouse_ray()
	var collider = get_collider_from_mouse_ray(result)
	var interactable = get_interactable(collider)
	if interactable and self.global_position.distance_to(collider.global_position) > 4:
		interactable = null
	#print(collider)
	update_player_interactable_object(interactable)
	#update_player_interactable_object(get_interactable(get_collider_from_mouse_ray(shoot_mouse_ray())))

func update_player_interactable_object(object):
	if object:
		#if object != player_interactable_area and player_interactable_area:
				#attempt_toggle_interactable_billboard(false, player_interactable_area.get_parent()) 
		set_player_interactable_object(object)
	else:
		#if player_interactable_area:
			#attempt_toggle_interactable_billboard(false, player_interactable_area.get_parent())
		set_player_interactable_object(null)

func set_player_interactable_object(area):
	player_interactable_area = area
	#print("player can interact with ", area)

func attempt_toggle_interactable_billboard(val : bool, object) -> void:
	if !val:
		object.call_deferred("toggle_interactable_billboard", val)
	if self.global_position.distance_to(object.global_position) > 3:
		return
	object.call_deferred("toggle_interactable_billboard", val)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input :
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pass
	if event.is_action_pressed("LMB_interact") and player_interactable_area:
		LMB_interact_with_object()
	elif event.is_action_pressed("RMB_interact"):
		RMB_interact_with_object()
	#if event.is_action_pressed("open_inventory"):
		#hud.call_deferred("update_inventory", inventory.get_contents())
		#hud.call_deferred("toggle_inventory")

func LMB_interact_with_object() -> void:
	print("interacted with object")
	var interactable_obj = player_interactable_area.get_parent()
	var has_mug = mug_held.get_child_count()
	
	if interactable_obj.has_method("give_new_mug") and !has_mug:
		pickup_mug(interactable_obj)
	elif interactable_obj.has_method("get_ingredient") and has_mug:
		add_ingredient_to_mug(interactable_obj.get_ingredient())
	elif interactable_obj.has_method("take_mug"):
		if has_mug:
			interactable_obj.call_deferred("attempt_dispense", mug_held.get_child(0))
		else:
			attempt_take_mug_ownership(interactable_obj.attempt_give_finished_drink())
		return
	#player_interactable_object.call_deferred("interact", hook.claw, self)

func RMB_interact_with_object() -> void:
	print("right click interact")
	var has_mug = mug_held.get_child_count()
	if has_mug:
		var mug = mug_held.get_child(0)
		discard_mug(mug)
	else:
		printerr("No mug in hand to discard")
		return

func pickup_mug(mug_dispenser) -> void:
	print('picked up mug')
	var mug = mug_dispenser.give_new_mug()
	attempt_take_mug_ownership(mug)


func attempt_take_mug_ownership(mug) -> void:
	if !mug:
		printerr("No mug to take ownership of")
		return
	print("took ownership of mug")
	mug_held.add_child(mug)
	mug.position = Vector3(0,-0.39,-0.421)
	mug.rotation_degrees = Vector3(14.8,0,0)

func discard_mug(mug) -> void:
	print('discarded mug')
	mug.call_deferred("discard_self")

func add_ingredient_to_mug(ingredient) -> void:
	var mug = mug_held.get_child(0)
	mug.call_deferred("add_ingredient",ingredient)

func shoot_mouse_ray() -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	# The query holds the ray's start, end, and any exceptions.
	var query = PhysicsRayQueryParameters3D.create(
		fire_ray.global_position,
		fire_ray.to_global(fire_ray.get_target_position())
	)
	query.set_collide_with_areas(true)

	# This is crucial: we tell the ray to ignore the player's body.
	query.exclude = [self.get_rid()]
	
	# We execute the raycast!
	var result = space_state.intersect_ray(query)
	
	return result

func get_collider_from_mouse_ray(result) -> Node:
	if result:
		return result.collider
		#print("got collider")
	else:
		return null

func get_interactable(object_looked_at):
	if !object_looked_at:
		return null
	if object_looked_at.get_parent().has_method("get_interactable"):
		#attempt_toggle_interactable_billboard(true, object_looked_at.get_parent())
		return object_looked_at
	else:
		return null

func _update_camera(delta):
	
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
