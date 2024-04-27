import re
import bpy
from .meta_generator import *
def generate_3D_model(destination_directory, name):
    
    # Appy Transforms to the object
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)

    path_fbx = destination_directory+'\\' + name + ".fbx"

    # Export object to fbx
    bpy.ops.export_scene.fbx(filepath=path_fbx, use_selection=True, axis_forward='-Z', axis_up='Y', object_types={'MESH'},bake_space_transform=True)
    fbx_guid = generate_meta_file('FileTemplates/template.fbx.meta',destination_directory, name,'.fbx')
    return fbx_guid