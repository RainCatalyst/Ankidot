shader_type canvas_item;

uniform float freq = 10.0;
uniform float ratio = 1.0;
uniform float alpha = 1.0;
uniform vec4 grid_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float thickness = 1.0; // line thickness

void fragment() {
	vec2 uv = vec2(UV.x, UV.y * ratio);
    vec2 grid = fract(uv * freq); // distance to grid line
    vec2 aa = fwidth(uv * freq) * thickness; // anti-aliasing width

    float line_x = smoothstep(0.0, aa.x, grid.x) * smoothstep(1.0, 1.0 - aa.x, grid.x);
    float line_y = smoothstep(0.0, aa.y, grid.y) * smoothstep(1.0, 1.0 - aa.y, grid.y);

    float line = 1.0 - min(line_x, line_y); // keep either horizontal or vertical line

    vec4 final_color = mix(COLOR, grid_color, line * grid_color.a);
    COLOR = final_color;
}
