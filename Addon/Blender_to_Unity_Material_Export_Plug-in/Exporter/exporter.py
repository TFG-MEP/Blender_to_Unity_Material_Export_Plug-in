from .generate_material import generate_material
from .generate_shader import generate_shader
from .generate_3D_model import generate_3D_model
from .generate_textures import generate_textures
from .generate_prefab import generate_prefab
from mathutils import Vector
import os
import bpy

def exportMaterial(path,material,obj):

    #accessing to bound box
    bound_box_corners = obj.bound_box
    centerPosition = sum((Vector(corner) for corner in bound_box_corners), Vector()) / 8
    dimensions = obj.dimensions
    halfSize = dimensions / 2.0
    boundingBoxMin = centerPosition - halfSize;
    boundingBoxMax = centerPosition + halfSize;
    bounding_box_values = [
        ("_BoundingBoxMin", (-boundingBoxMin[0],boundingBoxMin[1],-boundingBoxMin[2])),
        ("_BoundingBoxMax", (-boundingBoxMax[0],boundingBoxMax[1],-boundingBoxMax[2]))
    ]
    # Generate .shader file
    material_name, imagesMap, shader_guid = generate_shader(path,material)
    
    # Generate textures and obtain a mapping of node names to image GUIDs
    imageVariables = generate_textures(path, imagesMap)
    
    # Generate .material and .meta files
    material_guid = generate_material(path, material_name, imageVariables, shader_guid,bounding_box_values)

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
                        material_name, material_guid = exportMaterial(path, material,selected_object)
                        material_guids.append(material_guid)

                       

                    else:
                        print("The material is None")
        else:
            raise SystemExit("No material is assigned to the object.")
    else:
        raise SystemExit("No object is selected.")
    
    if exportFbx:
        # Generate 3D model
        fbx_guid, clean_name = generate_3D_model(path)
        # And Prefab
        objeto = bpy.context.active_object
        generate_prefab(path, objeto.name, clean_name, fbx_guid, material_guids)

   




