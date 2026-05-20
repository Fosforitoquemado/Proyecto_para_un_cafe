shader_type spatial;
render_mode blend_mix, depth_draw_always, unshaded;

uniform sampler2D viewport_texture : filter_linear_mipmap;

// Parámetros de deformación y estética
uniform float curvature : hint_range(0.0, 1.0) = 0.15;
uniform float scanline_count : hint_range(10.0, 1080.0) = 280.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.20;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float aberration : hint_range(0.0, 0.1) = 0.002;
uniform float global_alpha : hint_range(0.0, 1.0) = 1.0;

// Parámetros de animación
uniform float static_noise_intensity : hint_range(0.0, 1.0) = 0.06;
uniform float interference_scroll_speed : hint_range(0.0, 10.0) = 0.5;
uniform float scanline_scroll_speed : hint_range(-10.0, 30.0) = 1.0; // NUEVO: Velocidad de las líneas finitas
uniform float flicker_speed : hint_range(0.0, 100.0) = 30.0;
uniform float flicker_intensity : hint_range(0.0, 0.1) = 0.015;

// Función auxiliar para remapear rangos
float remap(float value, float iMin, float iMax, float oMin, float oMax) {
    return oMin + (oMax - oMin) * ((value - iMin) / (iMax - iMin));
}

// Función de ruido pseudo-aleatorio
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Función de curvatura CRT
vec2 curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv.x *= 1.0 + pow((abs(uv.y) * curvature), 2.0);
    uv.y *= 1.0 + pow((abs(uv.x) * curvature), 2.0);
    return (uv / 2.0) + 0.5;
}

void fragment() {
    vec2 crt_uv = curve(UV);
    
    if (crt_uv.x < 0.0 || crt_uv.x > 1.0 || crt_uv.y < 0.0 || crt_uv.y > 1.0) {
        ALBEDO = vec3(0.0);
        ALPHA = 0.0;
    } else {
        // Muestreo de textura con Aberración Cromática
        vec4 tex_r = texture(viewport_texture, crt_uv + vec2(aberration, 0.0));
        vec4 tex_g = texture(viewport_texture, crt_uv);
        vec4 tex_b = texture(viewport_texture, crt_uv - vec2(aberration, 0.0));
        
        vec3 color = vec3(tex_r.r, tex_g.g, tex_b.b);
        float alpha_canal = (tex_r.a + tex_g.a + tex_b.a) / 3.0;
        
        // Animación 1: Línea de interferencia gruesa que baja rodando
        float scroll_bars = TIME * interference_scroll_speed;
        float interference = sin((crt_uv.y * 4.0) - scroll_bars);
        interference = clamp(remap(interference, -1.0, 1.0, 0.85, 1.0), 0.0, 1.0);
        color *= interference;
        
        // Animación 2: Ruido analógico estático (lluvia)
        float noise = random(crt_uv + fract(TIME)); 
        color += (noise - 0.5) * static_noise_intensity;
        
        // Animación 3: Scanlines finas EN MOVIMIENTO (Acá sumamos el TIME)
        float scroll_lines = TIME * scanline_scroll_speed;
        float scanline = sin((crt_uv.y * scanline_count * PI * 2.0) - scroll_lines);
        scanline = (scanline + 1.0) / 2.0;
        color -= scanline * scanline_opacity * color;
        
        // Animación 4: Parpadeo eléctrico sutil (Flicker)
        float flicker = sin(TIME * flicker_speed) * flicker_intensity;
        color += flicker;
        
        // Viñeta (Bordes oscuros)
        float vignette = crt_uv.x * crt_uv.y * (1.0 - crt_uv.x) * (1.0 - crt_uv.y);
        vignette = clamp(pow(16.0 * vignette, vignette_opacity), 0.0, 1.0);
        
        ALBEDO = color * vignette;
        ALPHA = clamp(alpha_canal * vignette * global_alpha, 0.0, 1.0);
    }
}