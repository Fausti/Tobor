#version 120
attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;
		
uniform mat4 u_camMatrix;
        
varying vec2 v_TexCoord;
varying vec4 v_Color;

uniform int u_Mode;

uniform vec2 u_Center;
uniform vec2 u_Radius;

uniform vec2 u_Scale;
uniform vec2 u_InputSize;
uniform vec2 u_OutputSize;
		
void main(void) {
    v_TexCoord = a_TexCoord0;

    v_Color = a_Color;
    gl_Position = u_camMatrix * a_Position;
}