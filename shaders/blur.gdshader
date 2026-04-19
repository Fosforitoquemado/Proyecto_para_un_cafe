shader_type spatial;
render_mode unshaded; // Evita que la luz afecte el blur para un look más limpio

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
uniform vec4 tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	// Obtenemos la posición de los píxeles detrás de la esfera
	vec2 uv = SCREEN_UV;
	
	// Usamos niveles de mipmap para un blur eficiente y suave
	// A mayor lod, más desenfoque (usa la potencia del hardware)
	vec4 blurred_color = textureLod(screen_texture, uv, blur_amount);
	
	// Aplicamos un color base y el resultado del blur
	ALBEDO = blurred_color.rgb * tint.rgb;
	ALPHA = tint.a;
}