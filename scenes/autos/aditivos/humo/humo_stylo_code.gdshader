shader_type spatial;
// He quitado diffuse_toon y specular_toon porque al usar la función light() 
// estás escribiendo tu propio modelo de iluminación manualmente.
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_disabled;

uniform vec2 texture_scale = vec2(1.0, 1.0);
uniform sampler2D disolver_texture : source_color;

uniform float Light_attenuation : hint_range(0.0, 5.0) = 1.3;
uniform float Shadow_roundness : hint_range(0.0, 2.0) = 1.0;
uniform sampler2D Color_1D_Gradient : source_color, hint_default_black;

void fragment() {
    vec4 n_out7p0 = COLOR;
    float n_out7p4 = n_out7p0.a;

    vec2 n_out4p0 = UV * texture_scale;

    vec4 n_out3p0 = texture(disolver_texture, n_out4p0);
    float n_out3p1 = n_out3p0.r;

    ALBEDO = n_out7p0.xyz; // Definimos el color base aquí
    ALPHA = n_out3p1;
    ALPHA_SCISSOR_THRESHOLD = n_out7p4;
}

void light() {
    // 1. Cálculo de la incidencia de luz (Dot product)
    float dot_result = dot(NORMAL, LIGHT);
    
    // 2. Aplicamos la atenuación (Sombras de mapeo y distancia de la luz)
    // Multiplicamos el dot product por la atenuación para que las sombras "corten" el brillo
    float light_intensity = dot_result * ATTENUATION;
    
    // 3. Suavizado y ajuste según tus parámetros
    float wrap = (clamp(light_intensity, -0.9, 0.9) + 1.0) * 0.5 * Light_attenuation;
    
    // 4. Fresnel (Opcional, según tu gusto, a veces es mejor en el fragment)
    float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), Shadow_roundness);
    
    // 5. Combinar para la lectura del gradiente
    float final_sample = clamp(wrap * fresnel, 0.0, 1.0);
    vec3 gradient_color = texture(Color_1D_Gradient, vec2(final_sample)).rgb;
    
    // 6. RESPUESTA FINAL: Multiplicamos ALBEDO * LIGHT_COLOR * GRADIENTE
    // Esto evita que el color se "apile" de forma plana y respete el color del objeto.
    DIFFUSE_LIGHT += LIGHT_COLOR * ALBEDO * gradient_color;
}
