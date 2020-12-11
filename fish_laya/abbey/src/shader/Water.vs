

attribute vec2 	texcoord;
attribute vec4 	position;
varying vec2    v_texCoord;
varying float 	v_time;
uniform float CC_PMatrix;
uniform float CC_Time;
uniform float g;
void main()
{
	v_texCoord  = texcoord;
	gl_Position = CC_PMatrix * position;
	v_time = mod(CC_Time.g*0.05,2.0*3.1415926535897932);
}