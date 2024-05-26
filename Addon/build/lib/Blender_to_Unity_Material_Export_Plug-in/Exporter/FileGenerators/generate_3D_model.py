import re
import bpy
from .meta_generator import *

def generate_3D_model(destination_directory):
    objeto = bpy.context.active_object
    name_Object = re.sub(r'[^\w\s]', '', objeto.name).replace(' ', '')

    if name_Object == "" :
        raise SystemExit("FBX name contains only invalid symbols. Please use alphanumeric characters.")
   
    path_fbx = destination_directory+'\\' + name_Object + ".fbx"

    # Export object to fbx
    bpy.ops.export_scene.fbx(filepath=path_fbx, use_selection=True, axis_forward='-Z', axis_up='Y', object_types={'MESH'},bake_space_transform=True)
    fbx_guid = generate_meta_file('FileTemplates/template.fbx.meta',destination_directory, name_Object,'.fbx')
    return fbx_guid, name_Object