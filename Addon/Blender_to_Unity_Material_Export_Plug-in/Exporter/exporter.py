from .generate_material import generate_material
from .generate_shader import generate_shader
from .generate_3D_model import generate_3D_model
from .generate_textures import generate_textures

import os
import bpy
def exportMaterial(path,material):
    # Generate .shader file
    material_name, imagesMap, shader_guid = generate_shader(path,material)
    
    # Generate textures and obtain a mapping of node names to image GUIDs
    imageVariables = generate_textures(path, imagesMap)
    
    # Generate .material and .meta files
    generate_material(path, material_name, imageVariables, shader_guid)

def export(path, export):
    """
    Export materials, textures, shaders, and 3D model to the specified path.

    Args:
        path (str): The directory path where the exported files will be saved.
        export (bool): Flag indicating whether to perform the export operation.
    """
    # Change the current working directory to the directory containing this script
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    if bpy.context.active_object is not None:
        selected_object = bpy.context.active_object
        # Check if there's a material assigned to the object
        if len(selected_object.material_slots) > 0:
            for material_slot in selected_object.material_slots:
                material = material_slot.material
                if material is not None:
                   
                    if material.use_nodes:
                        material.use_nodes = True  
                        exportMaterial(path,material)
                    else:
                        print("The material is None")
        else:
            raise SystemExit("No material is assigned to the object.")
    else:
        raise SystemExit("No object is selected.")

    # Export if export flag is set to True
    if export:
        # Generate 3D model
        generate_3D_model(path)



