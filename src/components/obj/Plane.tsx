import * as THREE from "three"
import { useRef, useMemo } from "react"
import { useFrame, createPortal } from "@react-three/fiber"
import { PerspectiveCamera, ShaderMaterial } from "three"

import Font from "../obj/Font"
import vertex from "../../glsl/planeVertex.glsl"
import fragment from "../../glsl/planeFragment.glsl"

const Plane = () => {
  const cam = useRef<PerspectiveCamera>(null)
  const mat = useRef<ShaderMaterial>(null)

  const [scene, target] = useMemo(() => {
    const scene = new THREE.Scene()
    scene.background = new THREE.Color("rgb(100,100,100)")
    const target = new THREE.WebGLRenderTarget(1024, 1024)
    return [scene, target]
  }, [])

  useFrame((state) => {
    state.gl.setRenderTarget(target)
    state.gl.render(scene, cam.current!)
    state.gl.setRenderTarget(null)
    if (mat.current) {
      mat.current.uniforms.u_time.value += 0.001;
    }
  })

  return (
    <>
      <perspectiveCamera ref={cam} position={[0, 0, 15]} />
      {createPortal(<Font />, scene)}
      <mesh >
        <planeGeometry args={[2, 2]} />
        <shaderMaterial
          ref={mat}
          attach="material"
          args={[
            {
              vertexShader: vertex,
              fragmentShader: fragment,
              uniforms: {
                u_texture: { value: target.texture },
                u_resolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
                u_time: { value: 0 }
              }
            }
          ]}
        />
        {/* <meshStandardMaterial map={target.texture} /> */}
      </mesh>
    </>
  )
}


export default Plane;