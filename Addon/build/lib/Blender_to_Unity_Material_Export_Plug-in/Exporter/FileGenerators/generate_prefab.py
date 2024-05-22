from .meta_generator import *
from ..Utils.unity_hash import xxh64, unsigned_to_signed

def generate_unity_mesh_fileID(mesh_name) :

    s = f"Type:Mesh->{mesh_name}0"
    buffer = s.encode('utf-8')

    hash_value = xxh64(buffer, seed=0)
    result = unsigned_to_signed(hash_value, bits=64)
    
    return result

def generate_prefab(destination_path, fbx_name, file_name, fbx_guid, material_guids) :

    fbx_fileID = generate_unity_mesh_fileID(fbx_name)

    context_prefab = {
        "gameobject_fileID": 123,
        "component1_fileID":12,
        "component2_fileID":34,
        "component3_fileID":56,
        "fbx_fileID": fbx_fileID,
        "fbx_guid": fbx_guid,
        "material_guids": material_guids
    }
    prefab_template_str = load_template_from_file('FileTemplates/template.prefab')
    prefab_content = render_template(prefab_template_str, context_prefab)
    prefab_file_path = f"{destination_path}/{file_name}.prefab"
    save_to_file(prefab_file_path, prefab_content)
   
    