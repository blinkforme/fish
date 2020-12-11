attribute vec2 position;
attribute vec2 texcoord;
uniform vec2 size;
uniform mat4 mmat;
varying vec2 v_texcoord;
void main(){
    vec4 pos =mmat*vec4(position.x,position.y,0,1);
    gl_Position = vec4((pos.x/size.x-0.5)*2.0, (0.5-pos.y/size.y)*2.0, pos.z, 1.0);
    v_texcoord = texcoord;
}