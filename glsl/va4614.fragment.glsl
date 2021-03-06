// rotwang @mod+ spiral function, @mod* effect with 2 rotating spirals

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

// Perlin simplex noise
float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
			-0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
	+ i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 1330.0 * dot(m, g);
}

// Messed here with scaling of 1st and 2nd components

float fbm( vec2 p) {
	float f = 0.0;
	f += 0.8100*snoise(p); p *= 2.22;
	f += 0.3200*snoise(p); p *= 2.03;
	//f += 0.1250*snoise(p); p *= 2.01;
	//f += 0.0625*snoise(p); p *= 2.04;
	return f / 0.9375;
}

// Just messing here with the time domain and colour

void main(void) {
	vec2 p = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
	p.x /= resolution.y / resolution.x;
	vec3 c1 = mix(vec3(-0.5), vec3(0, -0.5, 1), gl_FragCoord.y/resolution.y);
	float c2 = 10.0*fbm(p - time/2.) - 10.*fbm(p - time/5.) + 100.*sin(fbm(p - time/20.)) + 11.0;
	float v = 1.2*(((c2 * 0.1) - 0.35) * 0.45) + 0.4;
	gl_FragColor = vec4( mix( c1, vec3(v), v ), 1.0 );
}