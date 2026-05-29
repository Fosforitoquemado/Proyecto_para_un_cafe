extends Resource
class_name DayResource

@export var nombre:String

#RECORDAR
@export var fecha_hoy = {
	"dia": 12,
	"mes": 6,
	"anio": 2026
}
@export var dificultad:int = 1

@export var documentos_habilitados:Array[String]

@export var config:GameConfig
@export var autos_permitidos:AutoArrayResource
@export var nombres:Nombresresources
@export var apellidos:Apellidosresources
@export var colores:ColoresResource
@export var objetosbaullegales:ObjetoArrayResource
@export var objetosbaulilegales:ObjetoArrayResource

@export var tiempo_limite:float = 120.0

@export var tiempo_dia:float = 400.0

@export var dinero_objetivo:float = 2000.0

@export var dialogostele:DialogosTeleResourceArray
