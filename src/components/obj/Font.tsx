import { FC } from "react";
import { FontLoader, TextGeometry, FontData } from "three/examples/jsm/Addons.js";
import { Center } from "@react-three/drei";

import fnt from "../../../public/Roboto Medium_Regular.json"
import vertex from "../../glsl/fontVertex.glsl"
import fragment from "../../glsl/fontFragment.glsl"


const FontComponent: FC = () => {
  const loader = new FontLoader()
  const font = loader.parse(fnt as unknown as FontData)
  const textGeo = new TextGeometry("Oil_Fluid", {
    font: font,
    size: 1,
    height: 0.2,
  });

  return (
    <Center>
      <mesh geometry={textGeo} >
        <shaderMaterial
          vertexShader={vertex}
          fragmentShader={fragment}
        />
      </mesh>
    </Center>
  )
}

export default FontComponent;