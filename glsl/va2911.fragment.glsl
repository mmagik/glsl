#ifdef GL_ES
precision mediump float;
#endif
//another old-ass clod spin off. -george toledo
uniform float time;
uniform vec2 resolution;

float f(vec3 o){	
	float a=(cos(o.x)-o.y*.5)*.1;
	o=vec3(tan(a)*o.x+cos(a)*o.y,sin(a)*o.x*sin(a)*o.y,tan(a)*cos(a)+o.z*2.3);
	return dot(cos(o)*cos(o),vec3(1.5))-1.5;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<450;i++){
		if(f(o+d*t)<.23){
			a=t-.5;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*.5);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(.01,.1,.3),p=o+d*t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*3.14)))*10.0);
			return vec3(mix( ((max(-dot(n,vec3(1.0)),-1.) + 0.125*max(-dot(n,vec3(-.1,-1.1,0)),0.)))*(mod(length(p.xy)*.2,1.)<1.0?vec3(.1,.1,.5):vec3(.79,.3,.4)),vec3(1.3,.1,.1),vec3(pow(t/75.,1.))));
		}
		t+=.23
	;
	}
	return vec3(.1,.1,1.0);
}

void main(){


	float t=dot(gl_FragColor.xyz,vec3(1.1,.5,.1))*.1;
	gl_FragColor=vec4(s(vec3(cos(time*.1)*.1,sin(time)*.2,time), 
	normalize(vec3((2.*gl_FragCoord.xy-vec2(resolution.x,resolution.y))/vec2(resolution.x),.1))),1);
}