extends Node3D

@onready var hud: UIManager = $"../HUD"
@onready var pcsistema: PCStatic = $"../PCSISTEMA"
@onready var pc_control: Control = $"../PCSISTEMA/SubViewport/PCControl"

@onready var day_manager: Node = $"../DayManager"
@onready var DocumentosGenerator: Node = $"../DocumentosGenerator"

@export var nodo_policia: Node3D
@export var papel_multa: MeshInstance3D
@export var nodo_papel_multa: Node3D
@export var dinero: MeshInstance3D

#cedula
@export var cedula: Area3D
@export var dominio_cedula: Label3D
@export var modelo_cedula: Label3D
@export var vencimiento_cedula: Label3D

#licencia
@export var licencia: Area3D
@export var numero_licencia: Label3D
@export var apellido_licencia: Label3D
@export var nombre_licencia: Label3D
@export var fecha_nacimiento_licencia: Label3D
@export var vencimiento_licencia: Label3D

#seguro
@export var seguro: Area3D
@export var asegurado_seguro: Label3D
@export var id_seguro: Label3D
@export var vencimiento_seguro: Label3D

var personaje

var datos_documentos

signal auto_ready

signal auto_out

func mostrar_datos():
	datos_documentos = DocumentosGenerator._generate_documentos()
	var day = day_manager.get_day()
	
	#fecha pc
	pc_control.set_fecha(datos_documentos["fecha_hoy"])
	
	#elementos_auto
	if "vtv" in day.documentos_habilitados:
		GameManager.auto_dupe.find_child("mes_VTV").text = datos_documentos["vtv"]
		pc_control.set_vtv(AutoGenerator._auto_data["vtv_info"]["vtv_string"])
		GameManager.auto_dupe.find_child("VTV").visible = true
	
	GameManager.auto_dupe.find_child("patente_adelante").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_adelante").visible = true
	GameManager.auto_dupe.find_child("patente_atras").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_atras").visible = true
	
	if "objetos_baul" in day.documentos_habilitados and datos_documentos["objeto_info"] != null:
		var ocupado = false
		for objeto_data in datos_documentos["objeto_info"]["objetos"]:
			var objeto_dupe = objeto_data["objeto"].instantiate()
			var objeto_tamanio = objeto_data["tamanio"]
			var rotacion = randi_range(objeto_data["min_rotacion"],objeto_data["max_rotacion"])
			if objeto_tamanio == "grande":
				GameManager.auto_dupe.find_child("nodo_baul_grande").add_child(objeto_dupe)
				objeto_dupe.rotation = Vector3(objeto_dupe.rotation.x,deg_to_rad(rotacion),objeto_dupe.rotation.z)
			elif objeto_tamanio == "mediano":
				if ocupado == false:
					GameManager.auto_dupe.find_child("nodo_baul_mediano_izq").add_child(objeto_dupe)
					objeto_dupe.rotation = Vector3(objeto_dupe.rotation.x,deg_to_rad(rotacion),objeto_dupe.rotation.z)
					ocupado = true
				else:
					GameManager.auto_dupe.find_child("nodo_baul_mediano_der").add_child(objeto_dupe)
					objeto_dupe.rotation = Vector3(objeto_dupe.rotation.x,deg_to_rad(rotacion),objeto_dupe.rotation.z)
	#cedula
	if "cedula" in day.documentos_habilitados:
		dominio_cedula.text = datos_documentos["patente_cedula"] #🎫🎫🎫
		pc_control.set_dominio_cedula(AutoGenerator._auto_data["patente"])
		modelo_cedula.text = datos_documentos["modelo_cedula"] #🎫🎫🎫
		pc_control.set_modelo_cedula(AutoGenerator._auto_data["modelo_info"]["nombre"])
		vencimiento_cedula.text = datos_documentos["fecha_cedula"] #🎫🎫🎫
		pc_control.set_vencimiento_cedula(AutoGenerator._auto_data["fecha_cedula"])
	
	#licencia
	if "licencia" in day.documentos_habilitados:
		numero_licencia.text = datos_documentos["numero_licencia"]#🎫🎫🎫
		pc_control.set_numero_licencia(AutoGenerator._auto_data["numero_licencia"])
		nombre_licencia.text = datos_documentos["nombre_licencia"]#🎫🎫🎫
		pc_control.set_nombre_licencia(AutoGenerator._auto_data["nombre_info"]["nombre"])
		apellido_licencia.text = datos_documentos["apellido_licencia"]#🎫🎫🎫
		pc_control.set_apellido_licencia(AutoGenerator._auto_data["apellido_info"]["apellido"])
		fecha_nacimiento_licencia.text = datos_documentos["nacimiento_licencia"]#🎫🎫🎫
		pc_control.set_fecha_nacimiento(AutoGenerator._auto_data["nacimiento"]["fecha_entera"])
		vencimiento_licencia.text = datos_documentos["fecha_licencia"]#🎫🎫🎫
		pc_control.set_fecha_vencimiento(AutoGenerator._auto_data["fecha_licencia"])
	
	#seguro
	if "seguro" in day.documentos_habilitados:
		asegurado_seguro.text = datos_documentos["asegurado_seguro"] #🎫🎫🎫
		pc_control.set_nombre_seguro(AutoGenerator._auto_data["nombre_info"]["nombre"])
		id_seguro.text = datos_documentos["id_seguro"] #🎫🎫🎫
		pc_control.set_id_seguro(AutoGenerator._auto_data["id_seguro"])
		vencimiento_seguro.text = datos_documentos["fecha_seguro"] #🎫🎫🎫
		pc_control.set_fecha_seguro(AutoGenerator._auto_data["fecha_seguro"])
	#papeles en la mano del personaje
	await  get_tree().create_timer(GameManager.auto_dupe.find_child("AnimationPlayer").current_animation_length + 0.5, false).timeout
	for i in range(GameManager.auto_data["dialogo_llegada_info"]["resource"].array.size()):
		#if skip == true:
			#tele.apagar_tele()
			#return
		var dialogo_actual = GameManager.auto_data["dialogo_llegada_info"]["resource"].array[i]
		var array_final = false
		if GameManager.auto_data["dialogo_llegada_info"]["resource"].array.size() - 1:
			array_final = true
			
		GameManager.auto_dupe.mostrar_mensaje(
			dialogo_actual["texto"],
			dialogo_actual["tamanio_font"],
			dialogo_actual["tamanio_final"],
			dialogo_actual["tiempo"],
			dialogo_actual["tiempo_velocidad"],
			array_final
		)
		
		var tiempo_espera = (dialogo_actual["texto"].length() * dialogo_actual["tiempo_velocidad"]) + 1.5
		await get_tree().create_timer(tiempo_espera, false).timeout
	GameManager.auto_dupe.ocultar_mensaje()
	personaje = GameManager.auto_dupe.get_node("nodo_personaje/personaje")
	if "licencia" in day.documentos_habilitados or "cedula" in day.documentos_habilitados:
		var personaje_animator = personaje.find_child("AnimationPlayer")
		var num = randf_range(1.3,2.5)
		personaje_animator.speed_scale = num
		
		personaje_animator.play("dar_papeles")
		await  get_tree().create_timer(personaje_animator.current_animation_length / num, false).timeout
	
		if "licencia" in day.documentos_habilitados:
			licencia.visible = true
		if "cedula" in day.documentos_habilitados:
			cedula.visible = true
		if "seguro" in day.documentos_habilitados:
			seguro.visible = true
		var nodo_papeles = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D/nodo_papeles")
		cedula.global_position = nodo_papeles.global_position
		licencia.global_position =  nodo_papeles.global_position
		seguro.global_position = nodo_papeles.global_position
		
	auto_ready.emit()
	print("FINAL MOSTRAR DATOS")
#condicion (0 es se va normal), (1 es se va con multa) y (2 es se va coimeado)

func ocultar_docu_bien():
	var day = day_manager.get_day()
	var nodo_papeles = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D/nodo_papeles")
	var personaje_animator: AnimationPlayer = personaje.find_child("AnimationPlayer")
	if "licencia" in day.documentos_habilitados or "cedula" in day.documentos_habilitados:
		if hud.papeles_on == true:
			personaje_animator.play("dar_papeles")
			await  get_tree().create_timer((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 1.5,false).timeout
			var tween = create_tween()
			tween.tween_property(cedula,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween2 = create_tween()
			tween2.tween_property(licencia,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween3 = create_tween()
			tween3.tween_property(seguro,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
		if hud.papeles_on == true:
			await personaje_animator.animation_finished
		licencia.visible = false
		cedula.visible = false
		seguro.visible = false
	personaje_animator.play("agarrar papeles")
	await  get_tree().create_timer(personaje_animator.current_animation_length / personaje_animator.speed_scale,false).timeout
	personaje_animator.play("manejando")
	
	GameManager.auto_dupe.irse()
	await  get_tree().create_timer(GameManager.auto_dupe.find_child("AnimationPlayer").current_animation_length,false).timeout
	GameManager.auto_dupe.queue_free()
	hud.papeles_on = false
	auto_out.emit()

func ocultar_docu_coima():
	var day = day_manager.get_day()
	var nodo_papeles = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D/nodo_papeles")
	var personaje_animator: AnimationPlayer = personaje.find_child("AnimationPlayer")
	
	if "licencia" in day.documentos_habilitados or "cedula" in day.documentos_habilitados:
		if hud.papeles_on == true:
			personaje_animator.play("dar_papeles")
			await  get_tree().create_timer((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 1.5,false).timeout
			var tween = create_tween()
			tween.tween_property(cedula,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween2 = create_tween()
			tween2.tween_property(licencia,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween3 = create_tween()
			tween3.tween_property(seguro,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
		if hud.papeles_on == true:
			await personaje_animator.animation_finished
		licencia.visible = false
		cedula.visible = false
		seguro.visible = false
		dinero.visible = true
		dinero.global_position = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D/nodo_papeles").global_position
		var tween4 = create_tween()
		tween4.tween_property(dinero,"global_position",Vector3(1.1,0.4,1.2),((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
	personaje_animator.play("agarrar papeles")
	await  get_tree().create_timer(personaje_animator.current_animation_length / personaje_animator.speed_scale,false).timeout
	personaje_animator.play("manejando")
	
	GameManager.auto_dupe.irse()
	await  get_tree().create_timer(GameManager.auto_dupe.find_child("AnimationPlayer").current_animation_length,false).timeout
	dinero.visible = false
	GameManager.auto_dupe.queue_free()
	hud.papeles_on = false
	auto_out.emit()

func ocultar_docu_multa():
	var day = day_manager.get_day()
	var nodo_papeles = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D/nodo_papeles")
	var personaje_animator: AnimationPlayer = personaje.find_child("AnimationPlayer")
	if "objeto_info" in datos_documentos:
		for objetos in datos_documentos["objeto_info"]["cantidad"]:
			if datos_documentos["objeto_info"]["objetos"][objetos]["legal"] == false:
				licencia.visible = false
				cedula.visible = false
				seguro.visible = false
				var pantalla_negra = hud.hud_elementos.find_child("pantalla_negro")
				var sirenas = pantalla_negra.find_child("sirenas")
				sirenas.play()
				nodo_policia.show()
				await get_tree().create_timer(1.5,false).timeout
				pantalla_negra.show()
				var tween = create_tween()
				tween.tween_property(pantalla_negra,"modulate",Color(0.0, 0.0, 0.0, 1.0),3.0)
				var tween2 = create_tween()
				tween2.tween_property(sirenas,"volume_db",-30,3.5)
				personaje_animator.play("manejando")
				await get_tree().create_timer(4,false).timeout
				GameManager.auto_dupe.queue_free()
				nodo_policia.hide()
				var tween3 = create_tween()
				tween3.tween_property(pantalla_negra,"modulate",Color(0.0, 0.0, 0.0, 0.0),1.5)
				await get_tree().create_timer(1.5,false).timeout
				pantalla_negra.visible = false
				pantalla_negra.modulate = Color(0.0, 0.0, 0.0, 0.0)
				sirenas.stop()
				sirenas.volume_db = 0
				hud.papeles_on = false
				auto_out.emit()
				return
	papel_multa.global_position = nodo_papel_multa.global_position
	papel_multa.visible = true
	if "licencia" in day.documentos_habilitados or "cedula" in day.documentos_habilitados:
		if hud.papeles_on == true:
			personaje_animator.play("dar_papeles")
			await  get_tree().create_timer((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 1.5,false).timeout
			var tween = create_tween()
			tween.tween_property(cedula,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween2 = create_tween()
			tween2.tween_property(licencia,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween4 = create_tween()
			tween4.tween_property(seguro,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			var tween3 = create_tween()
			tween3.tween_property(papel_multa,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 2.5))
			await personaje_animator.animation_finished
		if hud.papeles_on == false:
			var tween3 = create_tween()
			tween3.tween_property(papel_multa,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 3))
			await  get_tree().create_timer((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 1.5,false).timeout
	else:
		personaje_animator.play("dar_papeles")
		await  get_tree().create_timer((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 1.5,false).timeout
		var tween3 = create_tween()
		tween3.tween_property(papel_multa,"global_position",nodo_papeles.global_position,((personaje_animator.current_animation_length / personaje_animator.speed_scale) / 2.5))
		await personaje_animator.animation_finished
	licencia.visible = false
	cedula.visible = false
	seguro.visible = false
	papel_multa.visible = false
	papel_multa.global_position = nodo_papel_multa.global_position
	personaje_animator.play("agarrar papeles")
	await  get_tree().create_timer(personaje_animator.current_animation_length / personaje_animator.speed_scale,false).timeout
	personaje_animator.play("manejando")
	
	GameManager.auto_dupe.irse()
	await  get_tree().create_timer(GameManager.auto_dupe.find_child("AnimationPlayer").current_animation_length,false).timeout
	GameManager.auto_dupe.queue_free()
	hud.papeles_on = false
	auto_out.emit()

func ocultar_documentos(condicion):
	if condicion == 0:
		ocultar_docu_bien()
	elif condicion == 1:
		ocultar_docu_multa()
	elif condicion == 2:
		ocultar_docu_coima()
