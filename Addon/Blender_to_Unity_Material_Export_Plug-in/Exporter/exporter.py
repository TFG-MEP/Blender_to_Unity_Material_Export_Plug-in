from .generate_material import generate_material
from .generate_shader import generate_shader
from .generate_3dModel import generate_3dModel
from .generate_textures import generate_textures

import os
import bpy

def export(path,export) :
    #Changing de root 
    print("RUTA ANTES:" + os.getcwd())
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    print("RUTA ANTES:" + os.getcwd())
    # Generate .shader
    material_name, imagesMap,shader_guid= generate_shader(path)
    # Generate textures
    imageVariables=generate_textures(path,imagesMap)
    # Generate .material and .meta
    generate_material(path, material_name,imageVariables,shader_guid)

    if export:
        # Generate 3D model
        generate_3dModel(path)


