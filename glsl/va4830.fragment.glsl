/*****************\
| 		  |
| USA IS whatever |
|		  |
\*****************/

// sorry, turned it into a billion dots (extra credits for knowing how many :)

// extra credits answer answer is roughly 16 width * 10 height * ((25 rep factor)^2) = 100000 what 100000!? there's no way that can be right

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define RATE 10.0

vec3 invert(vec3 c){
	return vec3(1.-c);
}

float rotate(vec2 p,float angle){
   return p.x*cos(angle)-p.y*sin(angle);
}

float rect(vec2 p, vec2 s ){
	vec2 dist = abs(p)-s;
	return step(dist.x,0.)*step(dist.y,0.);
}

float star(vec2 p,float r) {
	float p0 = rotate(p, radians(54.0));
	float p1 = rotate(p, radians(126.0));
	float p2 = rotate(p, radians(198.0));
	float p3 = rotate(p, radians(270.0));
	float p4 = rotate(p, radians(342.0));
	
	float j = step(r,p0)+step(r,p1)+step(r,p2)+step(r,p3)+step(r,p4);
	return step(j,1.5);
}

void main( void ) {
	// wave
	vec2 pos = ( gl_FragCoord.xy / resolution.y );
	float waveAmount = exp(mouse.x*4.);
	pos += tan((pos.yx-.5)*3.*waveAmount+time)*.1/waveAmount;
	
	// stripes
	vec3 col = vec3(1,0,0);
	col += step(.5,fract(pos.y*6.5))*vec3(0,1,1);
	col *= step(0.,pos.x)*step(0.,pos.y)*step(pos.x,1.6)*step(pos.y,1.);
	
	// blue area
	float blue = rect(pos-vec2(0.3,19./26.),vec2(0.3,7./26.));
	col = col*(1.-blue) + vec3(0,0,1)*blue;
	
	//5 by 6 stars then a 4 by 5 stars
	vec2 pos2 = (pos-vec2(0.045,0.53))*10.+.5;
	col += star((fract(pos2)-.5)*.1,.01)*step(-pos2.x,0.)*step(-pos2.y,0.)*step(pos2.x,6.)*step(pos2.y,5.);
	pos2 -= .5;
	col += star((fract(pos2)-.5)*.1,.01)*step(-pos2.x,0.)*step(-pos2.y,0.)*step(pos2.x,5.)*step(pos2.y,4.);
	
	col *= fract(pos2.x*25.0)>0.5?1.0:0.0;
	col *= fract(pos2.y*25.0)>0.5?1.0:0.0;
	
	gl_FragColor = vec4(col, 1.0 );

}