import xxhash
import struct

def generate_unity_mesh_fileID(mesh_name) :

    s = f"Type:Mesh->{mesh_name}0"
    buffer = s.encode('utf-8')
    hash_value = xxhash.xxh64(buffer, seed=0).intdigest()

    # Convert from ulong (64-bit unsigned) to long (64-bit signed)
    result = struct.unpack('q', struct.pack('Q', hash_value))[0]

    return result

def generate_prefab(destination_path, fbx_name, fbx_guid, material_guid) :

    fbx_fileID = generate_unity_mesh_fileID(fbx_name)

    context_prefab = {
        "gameobject_fileID": 123,
        "component1_fileID":12,
        "component2_fileID":34,
        "component3_fileID":56,
        "fbx_fileID": fbx_fileID,
        "fbx_guid": fbx_guid,
        "material_guid": material_guid
    }
    prefab_template_str = load_template_from_file('FileTemplates/template.prefab')
    prefab_content = render_template(prefab_template_str, context_prefab)
    prefab_file_path = f"{destination_path}/{prefab_name}.prefab"
    save_to_file(prefab_file_path, prefab_content)
    