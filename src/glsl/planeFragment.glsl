uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture;
varying vec2 vUv; 

int octaves = 8;
float seed = 155.55;

  //整数単位の座標から延びるランダムな勾配ベクトルの作成
vec2 random (vec2 st,float seed){
  st = vec2(
    dot(st,vec2(155,255)),
    dot(st,vec2(255,155))
  );
  return -1.0 + 2.0*fract(sin(st)*seed);
}



float noise(vec2 st,float seed) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( dot( random(i + vec2(0.0,0.0),seed), f - vec2(0.0,0.0) ), 
                     dot( random(i + vec2(1.0,0.0),seed ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random(i + vec2(0.0,1.0),seed ), f - vec2(0.0,1.0) ), 
                     dot( random(i + vec2(1.0,1.0),seed ), f - vec2(1.0,1.0) ), u.x), u.y);
}



float fbm(in vec2 _st, float seed) {
  float v = 0.1;
  float a = 0.9;
  vec2 shift = vec2(100.0);
  // Rotate to reduce axial bias
  mat2 rot = mat2(cos(0.5), sin(0.5),
                  -sin(0.5), cos(0.50));
  for (int i = 0; i < octaves; ++i) {
      v += a * noise(_st,seed);
      _st = rot * _st * 2.0 + shift;
      a *= 0.5;
  }
  return v;
}



float pattern( in vec2 p,in float t, out vec2 q, out vec2 r )
{
    q.x = fbm( p + vec2(0.0,0.0),seed );
    q.y = fbm( p + vec2(5.2,1.3),seed );

    r.x = fbm( p + 4.0 * q + vec2(1.7-t,9.2),seed );
    r.y = fbm( p + 4.0 * q + vec2(8.3-t,2.8),seed );

    return fbm( p + 4.0*r,seed );
}





void main(){
  vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / min(u_resolution.x,u_resolution.y);

  vec2 q=vec2(0.0,0.0);
  vec2 r=vec2(0.0,0.0);

  float _pattern = 0.0;
  
  _pattern = pattern(uv,u_time,q,r);

  vec3 color = vec3(_pattern);

      color.r -= dot(q, r) * 15.;
      color = mix(color, vec3(pattern(r, u_time, q, r), dot(q, r) * 15., -0.1), .5);
      color -= q.y * 1.5;
      color = mix(color, vec3(.2, .2, .2), (clamp(q.x, -1., 0.)) * 3.);

  vec3 texture = texture2D(u_texture, vUv).rgb * color;

  gl_FragColor = vec4(0.7-texture, 1.);
}