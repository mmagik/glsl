.5*ti
PI=3.14159;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float gc=fract(time*3.2/3.),
gb=fract(gc*2.),c*2.),
vec3 ff(vec2 p){
    vec2 q=vec2(sin(.08*p.x),4.*p.y);
    vec3 c=vec3(0);
    for(float i=0.;i<15.;i++)
      c+=(1.+sin(i*s =(1.+sin(i*s
// from http://frank.bitsnbites.eu/safe.html

#ifdef GL_ES
precision highp float;
#endif2.2),2.),.001,gc));
}
vec3 ft(vec3 o,vec3 d){
    d.y*=.65+.1*sin(in(time)+vec3(0.,1.3,2.2)))*.2/length(q-vec2(sin(i),12.*sin(.3*time+i)));
    return c+vec3(mix(mod(floor(p.x*.2)+floor(p.y* 2)+floor(p.y*me);
    float D=1./(d.y*d.y+d.z*d.z),
          a=(o.y*d.y+o.z*d.z)*D,
          b=(o.y*o.y+o.z*o.z-36.)*D,
          t=-a-sqrt(a*a-b);
    o+=t*d;
    return ff(vec2(o.x,atan(o.y,o.z)))*(1.+.01*t);
}
void main(){
    vec2 p=(2.*gl_FragCoord.xy-resolution)/resolution.y,
         q=2.*gl_FragCoord.xy/resolution-1.;
    vec3 cp=vec3(-time*20.+1.,1.6*sin(time*1.2),2.+2.*cos(time*.3)),
         ct=cp+vec3(1.,.3*cos(time),-.2),
         cd=normalize(ct-cp),
         cr=normalize(cross(cd,vec3(.5*cos(.3*time),0.,1.))),
         cu=cross(cr,cd),
         rd=normalize(2.*cd+cr*p.x+cu*p.y),
         c=ft(cp,rd)*
           min(1.,1.8-dot(q,q))*(.9+.1*sin(3.*sin(gc)*gl_FragCoord.y));
    gl_FragColor=vec4(c,1);
}