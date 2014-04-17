#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 mouse;
uniform vec2 resolution;


// just messin' around

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 25.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 20.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

  
       vec4 o =  vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
  if (gl_FragCoord.x < (.425 * resolution.x) ) 
    { 
      float g = 1.;
      g = 3. / ( resolution.x / gl_FragCoord.x );
      o = o + vec4(0.4,g,.01,1.0);
    }
       gl_FragColor = o;
         
}