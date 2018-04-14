attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;
		
uniform mat4 u_camMatrix;
        
varying vec4 v_TexCoord[5];
varying vec4 v_Color;
		
uniform vec2 u_Scale;
uniform vec2 u_InputSize;
uniform vec2 u_OutputSize;
		
void main(void) {
    float x = 0.5 * (1.0 / u_OutputSize.x);
    float y = 0.5 * (1.0 / u_OutputSize.y);
    
    vec2 dg1 = vec2( x, y);
    vec2 dg2 = vec2(-x, y);
    vec2 dx = vec2(x, 0.0);
    vec2 dy = vec2(0.0, y);

    v_TexCoord[0].xy = a_TexCoord0;
    v_TexCoord[1].xy = v_TexCoord[0].xy - dg1;
    v_TexCoord[1].zw = v_TexCoord[0].xy - dy;
    v_TexCoord[2].xy = v_TexCoord[0].xy - dg2;
    v_TexCoord[2].zw = v_TexCoord[0].xy + dx;
    v_TexCoord[3].xy = v_TexCoord[0].xy + dg1;
    v_TexCoord[3].zw = v_TexCoord[0].xy + dy;
    v_TexCoord[4].xy = v_TexCoord[0].xy + dg2;
    v_TexCoord[4].zw = v_TexCoord[0].xy - dx;

    v_Color = a_Color;
    gl_Position = u_camMatrix * a_Position;
}