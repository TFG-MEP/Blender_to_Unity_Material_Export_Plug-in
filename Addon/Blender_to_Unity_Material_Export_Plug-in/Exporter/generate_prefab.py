
def get_fbx_fileID(fbx_name) :
    return 1

def generate_prefab(prefab_name, fbx_name, fbx_guid, material_guid) :

    fbx_fileID = get_fbx_fileID("Type:Mesh->" + fbx_name + "0")

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
    prefab_file_path = f"{path}/{prefab_name}.prefab"
    save_to_file(prefab_file_path, prefab_content)
    