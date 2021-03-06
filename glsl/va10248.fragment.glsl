#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float snoise(vec2 v);

float fbm( vec2 p ){
	float f = 0.0;
	f+= 0.5000*snoise(p); p*=2.02;
	f+= 0.2500*snoise(p); p*=2.03;
	f+= 0.1250*snoise(p); p*=2.01;
	f+= 0.0625*snoise(p); p*=2.04;
	f /= 0.9375;
	return f;
}

void main( void ) {
	
	vec2 q = gl_FragCoord.xy/resolution.xy;
	vec2 p = -1.0 + 2.0*q;
	p.x *= resolution.x/resolution.y;
	
	float background = smoothstep(-0.25, 0.25, p.x);
	
	p.x -= 0.45;
	
	float r = sqrt( dot(p,p) );
	
	float a = atan( p.y, p.x);
	
	vec3 col = vec3(1.0); 
	//if( r<0.5){
		col = vec3(0.1, 0.55, 0.7);
	
		//float f = fbm( 3.0*p );
		//col = mix( col, vec3(0.5, 0.6, 0.6), f);
		float f;
		
		f = smoothstep(0.0, 1.0, r*r+r-0.1);
		col = mix(col, vec3(0.1, 0.3, 0.4), f);
		
		f = 1. - smoothstep( 0., .5, length(p));
		col += vec3(1.0, 0.9, 0.8)*f*.3;
		
		f = smoothstep(0.3, 1.0,  length(vec2(5.*(sin(time/3.)-r)*fbm(p*1.6), r*cos(time) )) );
		col *= mix( col, vec3(0.2, 0.14, 0.3), 3.*f);
		
		
		
		
		f = smoothstep(0.135*(sin(time)+1.0), 0.15*(sin(time)+1.0), r);
		//col *= f;
	//}
	
	
	gl_FragColor = vec4(col*background, 1.0);
}





vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}