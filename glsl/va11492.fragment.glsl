#ifdef GL_ES
precision mediump float;
#endif

uniform float time;


void main( void ) {
	
	gl_FragColor = vec4(sin(0.5 + time),0.0,0.0,0.0);
}