from .generate_material import generate_files
from .generate_shader import generate
from .generate_3dModel import generate_3dModel
import os
import bpy

def export(path,export) :
    #Changing de root 
    print("RUTA ANTES:" + os.getcwd())
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    print("RUTA ANTES:" + os.getcwd())
    # Generate  .shader
    material_name, imagesMap = generate(path)

    # Generate .material and .meta
    generate_files(path, material_name,imagesMap)

    if export:
        # Generate 3D model
        generate_3dModel(path)


