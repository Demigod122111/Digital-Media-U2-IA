shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform bool noAlpha = false;
uniform bool lerpAlpha = true;
uniform vec4 customColor: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool useCustomColor = true;

void fragment() {
	if (useCustomColor)
		COLOR = customColor * progress;
	else
		COLOR = COLOR * progress;

	if (noAlpha)
		COLOR.a = 1.0;
	if (lerpAlpha)
		COLOR.a = progress;
}