shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D overlay_tex: repeat_enable, filter_nearest;
uniform float scale = 0.006944444; // calculated by 1/texture size e.g. 1/144
varying vec2 world_position;


uniform bool pixel_mode = true;
uniform float pixel_amount = 32.0;
uniform float distortion : hint_range(0.0, 0.1) = 0.01;

/// Noise Texture System
uniform bool texture_noise_system = true;
uniform float noise_speed = 1.0;
uniform int noise_direction : hint_range(-1, 1) = -1;
uniform sampler2D noise_texture : source_color ,repeat_enable;

/// Worley System
uniform bool worley_noise_system = false;
uniform float worley_cell_density = 10.0;
uniform float worley_speed = 2.0;

/// Bordes Effect
uniform sampler2D mask_texture : source_color, filter_nearest;
uniform bool edge_and_mask = false;
uniform float alpha_value : hint_range(0.0, 1.0) = 1.0;

/// Worley Methods
vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

void vertex(){
	// calculate the world position for use in the fragment shader
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float worley(vec2 uv, float columns, float rows, float time) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			point = vec2( cos(time * point.x * worley_speed), sin(time * point.y * worley_speed) ) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

void fragment() {
	// only apply overlay_tex on the fully red parts of the original tiles
	float mix_amount = 1.0;//floor(COLOR.r);
	
	// sample the overlay_tex using worldPos
	vec4 overlay_color = texture(overlay_tex, world_position * scale);
	//&& COLOR.rgb == vec3(133.0,190.0,140.0)
	// combine original color and overlay color together
	
	
	vec4 uv_result = vec4(0.0);
	vec2 uv;
	
	/// Pixel Mode 
	if (pixel_mode){
		uv = floor(UV * pixel_amount) / pixel_amount;
	}else{
		uv = UV;
	}
	
	/// Noise Texture System
	if (texture_noise_system){
		vec4 noise_uv = texture(noise_texture, uv + TIME * noise_speed * float(noise_direction));
		uv_result += noise_uv;
	}
	
	/// Worley Noise System
	if (worley_noise_system){
		float worley = worley(uv, worley_cell_density, worley_cell_density, TIME);
		vec4 result = texture(TEXTURE, vec2(worley));
		uv_result += result;
	}
	
	/// Blend
	vec2 noise_uv = mix(uv, uv_result.rg, distortion);
	
	if (edge_and_mask){
		vec4 base = texture(TEXTURE, uv);
		vec4 blend = texture(mask_texture, noise_uv);
	
		vec4 final_color = mix(base, blend, blend.a);
		
		COLOR = final_color;
		COLOR.a = (texture(TEXTURE, noise_uv).a) * alpha_value;
	}
	else
	{
		if(COLOR.a==1.0 && COLOR.r == 133.0/255.0 || COLOR.r == 100.0/255.0){
			COLOR = mix(COLOR, overlay_color, mix_amount);
			if (COLOR.r==144.0/255.0){
				COLOR = vec4(190.0/255.0,133.0/255.0,140.0/255.0,1.0);
			}
			else if (COLOR.r==132.0/255.0){
				COLOR = vec4(166.0/255.0,100.0/255.0,147.0/255.0,1.0);
			}
			else if (COLOR.r==116.0/255.0){
				COLOR = vec4(130.0/255.0,96.0/255.0,143.0/255.0,1.0);
			}
			//COLOR = texture(overlay_tex, noise_uv);
			//COLOR.a = (texture(overlay_tex, noise_uv).a) * alpha_value;
			}
	}
	
}
