uniform sampler2D u_Texture0;
		
varying vec2 v_TexCoord;
varying vec4 v_Color;
		
uniform vec2 u_Scale;
uniform vec2 u_Center;
uniform vec2 u_Radius;
uniform vec2 u_InputSize;
uniform vec2 u_OutputSize;

const int indexMatrix4x4[16] = int[](0,  8,  2,  10,
                                     12, 4,  14, 6,
                                     3,  11, 1,  9,
                                     15, 7,  13, 5);

float indexValue() {
    int x = int(mod(gl_FragCoord.x, 4));
    int y = int(mod(gl_FragCoord.y, 4));
    return indexMatrix4x4[(x + y * 4)] / 16.0;
}

void main(void) {
    vec2 normalized = vec2((gl_FragCoord.x - u_Center.x) / u_Radius.x, (gl_FragCoord.y - u_Center.y) / u_Radius.y);
    float dist = length(normalized);
    float dither = indexValue();

    if (dist < 0.5) {
       gl_FragColor = vec4(1, 1, 1, 1);
    } else {
        if (dist < dither) {
            // float c = clamp(1.25 - dist, 0, 1);
            float c = 1 - smoothstep(0.5, 1, dist);
            gl_FragColor = vec4(c, c, c, 1);
        } else {
            discard;
        }
    }
}