from .generate_material import generate_material
from .generate_shader import generate_shader
from .generate_3D_model import generate_3D_model
from .generate_textures import generate_textures
from .generate_prefab import generate_prefab

import os
import bpy

def exportMaterial(path,material):
    # Generate .shader file
    material_name, imagesMap, shader_guid = generate_shader(path,material)
    
    # Generate textures and obtain a mapping of node names to image GUIDs
    imageVariables = generate_textures(path, imagesMap)
    
    # Generate .material and .meta files
    material_guid = generate_material(path, material_name, imageVariables, shader_guid)

    return material_name, material_guid

def export(path, exportFbx):
    """
    Export materials, textures, shaders, and 3D model to the specified path.

    Args:
        path (str): The directory path where the exported files will be saved.
        export (bool): Flag indicating whether to perform the export operation.
    """

    # Change the current working directory to the directory containing this script
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    material_guids=[]
    if bpy.context.active_object is not None:
        selected_object = bpy.context.active_object
        # Check if there's a material assigned to the object
        if len(selected_object.material_slots) > 0:
            for material_slot in selected_object.material_slots:
                material = material_slot.material
                if material is not None:
                   
                    if material.use_nodes:
                        material.use_nodes = True  
                        material_name, material_guid = exportMaterial(path, material)
                        material_guids.append(material_guid)

                       

                    else:
                        print("The material is None")
        else:
            raise SystemExit("No material is assigned to the object.")
    else:
        raise SystemExit("No object is selected.")
    
    if exportFbx:
        # Generate 3D model
        fbx_guid,name_FBX = generate_3D_model(path)
        # And Prefab
        generate_prefab(path, name_FBX, fbx_guid, material_guids)

   




