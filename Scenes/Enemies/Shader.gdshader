shader_type canvas_item;

uniform vec4 colour : source_color;

void fragment() {
	vec4 pixelColour = texture(TEXTURE, UV);
	float brightness = (pixelColour.r + pixelColour.g + pixelColour.b)/3.0;
	vec4 grayScale = vec4(brightness,brightness,brightness,pixelColour.a);
		COLOR = grayScale*colour;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
