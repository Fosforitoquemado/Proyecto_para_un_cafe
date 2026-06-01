shader_type spatial;
render_mode depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// Parámetros ajustables desde el Inspector
group_uniforms Wind_Settings;
uniform float wind_speed : hint_range(0.0, 10.0) = 1.5;
uniform float wind_strength : hint_range(0.0, 2.0) = 0.02;
uniform float wind_frequency : hint_range(0.0, 2.0) = 0.9;

group_uniforms Visual_Settings;
uniform vec4 albedo : source_color = vec4(0.337, 0.345, 0.165, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.8;

void vertex() {
	// 1. Conseguimos la posición global única de ESTE árbol específico
	vec3 world_pos = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	
	// 2. Creamos un desfase único para este árbol combinando sus coordenadas X y Z.
	// Multiplicamos por números primos o decimales raros (como 12.9898) para romper la simetría.
	float unique_offset = sin(world_pos.x * 0.15 + world_pos.z * 0.23) * 10.0;
	
	// 3. Aplicamos el tiempo + el desfase único
	float time = (TIME * wind_speed) + unique_offset;
	
	// Mascara de altura (la base Y=0 no se mueve, la punta sí)
	float mask = max(0.0, VERTEX.y); 
	
	// 4. Movimiento principal (X) y secundario (Z) ligeramente desfasados entre sí
	vec3 wind_offset = vec3(0.0);
	wind_offset.x = sin(time * wind_frequency) * wind_strength;
	wind_offset.z = cos(time * wind_frequency * 0.8 + unique_offset) * (wind_strength * 0.4);
	
	// Aplicamos el movimiento al vértice
	VERTEX.xyz += wind_offset * mask;
}

void fragment() {
	ALBEDO = albedo.rgb;
	ROUGHNESS = roughness;
	SPECULAR = 0.2;
}
