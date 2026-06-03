extends Resource
class_name GameConfig
#tiempo de carga
@export var tiempo_de_carga: float = 3
#patente faltante
@export_range(0,100) var probabilidad_patente_faltante:= 90
@export_range(0,100) var probabilidad_color:= 95
#cedula
@export_range(0,100) var probabilidad_patente_cedula:= 95
@export_range(0,100) var probabilidad_fecha_cedula:= 95
@export_range(0,100) var probabilidad_fecha_cedula_2026:= 30
@export_range(0,100) var probabilidad_modelo_cedula:= 95
#licencia
@export_range(0,100) var probabilidad_nombre_licencia:= 95
@export_range(0,100) var probabilidad_apellido_licencia:= 95
@export_range(0,100) var probabilidad_numero_licencia:= 95
@export_range(0,100) var probabilidad_fecha_licencia:= 95
@export_range(0,100) var probabilidad_fecha_licencia_2026:= 30
@export_range(0,100) var probabilidad_nacimineto_licencia:= 95
@export_range(0,100) var probabilidad_nacimiento_licencia_16:= 30
#vtv
@export_range(0,100) var probabilidad_vtv:= 95
#baul
@export_range(0,100) var probabilidad_objeto_baul:= 95
@export_range(0,100) var probabilidad_objeto_baul_legal:= 50
#seguro
@export_range(0,100) var probabilidad_nombre_seguro:= 95
@export_range(0,100) var probabilidad_id_seguro:= 95
@export_range(0,100) var probabilidad_fecha_seguro:= 95
@export_range(0,100) var probabilidad_fecha_seguro_2026:= 30
#alcholemia
@export_range(0,100) var probabilidad_alcholemia:= 95
#permiso
@export_range(0,100) var probabilidad_tipo_vehiculo:= 95
