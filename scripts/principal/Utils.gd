extends Node

var characters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

# 🎲 Devuelve true con X% de probabilidad
func chance(probabilidad: int) -> bool:
	return randi_range(0, 100) <= probabilidad
 
# 🔢 Número distinto (evita repetir uno específico)
func random_excluding(min:int, max:int, exclude:int) -> int:
	var num := randi_range(min, max - 1)
	
	if num >= exclude:
		num += 1
		
	return num

# 🔤 String aleatorio
func random_string(length: int) -> String:
	var result := ""
	for i in range(length):
		result += characters[randi() % characters.length()]
	return result

# 📅 Generar fecha válida
func generar_fecha(anio_min := 2020, anio_max := 2030) -> String:
	var mes := randi_range(1, 12)
	var dia := dias_en_mes(mes)
	var anio := randi_range(anio_min, anio_max)
	return str(randi_range(1, dia), "/", mes, "/", anio)

# 📅 Días por mes (simplificado)
func dias_en_mes(mes: int) -> int:
	if mes == 2:
		return 28
	elif mes in [4,6,9,11]:
		return 30
	else:
		return 31

# 👤 Nombre random
func random_from(lista: Array):
	return lista[randi_range(0, lista.size() - 1)]

# 🔁 Cambiar un carácter en string
func cambiar_char(texto: String, index: int, nuevo: String) -> String:
	return texto.substr(0, index) + nuevo + texto.substr(index + 1)

# ❌ Introducir error en patente
func romper_patente(patente: String, errores := 1) -> String:
	var resultado := patente
	
	for i in range(errores):
		var pos := randi_range(0, resultado.length() - 1)
		
		if pos <= 2:
			# número
			var nuevo = str(random_excluding(0, 9, int(resultado[pos])))
			resultado = cambiar_char(resultado, pos, nuevo)
		elif pos >= 4:
			# letra
			var nuevo = random_string(1)
			resultado = cambiar_char(resultado, pos, nuevo)
	
	return resultado
