attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;
		
uniform mat4 u_camMatrix;
        
varying vec4 v_TexCoord[7];
varying vec4 v_Color;
		
uniform vec2 u_Scale;
uniform vec2 u_InputSize;
uniform vec2 u_OutputSize;
		
void main(void) {
    float x = 0.5 * (1.0 / u_OutputSize.x);
    float y = 0.5 * (1.0 / u_OutputSize.y);
    vec2 dg1 = vec2( x,y);  vec2 dg2 = vec2(-x,y);
    vec2 sd1 = dg1*0.5;     vec2 sd2 = dg2*0.5;
    vec2 ddx = vec2(x,0.0); vec2 ddy = vec2(0.0,y);

    v_Color = a_Color;
    gl_Position = u_camMatrix * a_Position;

    v_TexCoord[0].xy = a_TexCoord0;
    v_TexCoord[1].xy = v_TexCoord[0].xy - sd1;
    v_TexCoord[2].xy = v_TexCoord[0].xy - sd2;
    v_TexCoord[3].xy = v_TexCoord[0].xy + sd1;
    v_TexCoord[4].xy = v_TexCoord[0].xy + sd2;
    v_TexCoord[5].xy = v_TexCoord[0].xy - dg1;
    v_TexCoord[6].xy = v_TexCoord[0].xy + dg1;
    v_TexCoord[5].zw = v_TexCoord[0].xy - dg2;
    v_TexCoord[6].zw = v_TexCoord[0].xy + dg2;
    v_TexCoord[1].zw = v_TexCoord[0].xy - ddy;
    v_TexCoord[2].zw = v_TexCoord[0].xy + ddx;
    v_TexCoord[3].zw = v_TexCoord[0].xy + ddy;
    v_TexCoord[4].zw = v_TexCoord[0].xy - ddx;
}