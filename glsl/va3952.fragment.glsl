// Playing with symmetries - Fence
//
// by @paulofalcao
//

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

//Util Start
float PI=3.14159265;

vec2 ObjUnion(in vec2 obj0,in vec2 obj1){
  if (obj0.x<obj1.x)
  	return obj0;
  else
  	return obj1;
}
vec3 sim(vec3 p,float s){
   vec3 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 rotsim(vec2 p,float s){
   vec2 ret=p;
   ret=rot(p,-PI/(s*2.0));
   ret=rot(p,floor(atan(ret.x,ret.y)/PI*s)*(PI/s));
   return ret;
}

//Util End

//Scene Start

//Floor
vec2 obj0(in vec3 p){
  return vec2(p.y+3.0,0);
}
//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
     return vec3(0,0,0);
   else
     return vec3(1,1,1);
 else
   if (fract(p.z*.5)>.5)
     return vec3(1,1,1);
   else
     return vec3(0,0,0);
}

vec2 obj1(vec3 p){
  p.y=p.y-6.0;
  p.z=p.z-18.0;
  p.xy=rotsim(p.xy,4.0);
  p.y=p.y-8.0+sin(time*2.0);
  p.xy=rotsim(p.xy,2.0);
  p.y=p.y+sin(time)*4.0;
  p.xy=rotsim(p.xy,16.0); 
  float c1=length(p)-0.5;
  float c3=length(p.xz)-0.2;
  return vec2(min(c1,c3),1);
}

//RoundBox with simple solid color
vec3 obj1_c(in vec3 p){
	return vec3(0.2,0.5,1.0);
}

//Objects union
vec2 inObj(in vec3 p){
  return ObjUnion(obj0(p),obj1(p));
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
 
  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  float mx=mouse.x*PI*2.0;
  float my=mouse.y*PI/2.01;  
  vec3 prp=vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*16.0; //Trackball style camera pos
  float vpd=1.5;  
 
  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 scrCoord=prp+vpn*vpd+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.001||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd){
    if (s.y==0.0)
      c=obj0_c(p);
    else
      c=obj1_c(p);
 
    //tetrahedron normal
    const float n_er=0.01;
    float v1=inObj(vec3(p.x+n_er,p.y-n_er,p.z-n_er)).x;
    float v2=inObj(vec3(p.x-n_er,p.y-n_er,p.z+n_er)).x;
    float v3=inObj(vec3(p.x-n_er,p.y+n_er,p.z-n_er)).x;
    float v4=inObj(vec3(p.x+n_er,p.y+n_er,p.z+n_er)).x;
    n=normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
    
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}