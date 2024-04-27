from .meta_generator import *
def texturesInMaterial(imageVariables):
    textList = []
    for index, (nombre_variable, guid) in enumerate(imageVariables.items()):
        entrada = f' {nombre_variable}:\n        '
        entrada += 'm_Texture: {fileID: 2800000, guid: ' + guid + ', type: 3}\n        '
        entrada += 'm_Scale: {x: 1, y: 1}\n        '
        entrada += 'm_Offset: {x: 0, y: 0}'
        entrada += '\n    '
        textList.append(entrada)
    return textList 
    
def generate_material(path, material_name,imageVariables,shader_guid):

    ## .MAT
    context_material = {
        "material_name": material_name, # El nombre del material debe depender del nombre en blender
        "shader_guid":shader_guid,
        "tex_env_strings": texturesInMaterial(imageVariables)
       
        # aquí deben ir el resto de propiedades que se deban asignar al shader (textura, color, otros valores...)
    }
    material_template_str = load_template_from_file('FileTemplates/template.mat')
    material_content = render_template(material_template_str, context_material)
    material_file_path = f"{path}/{material_name}.mat"
    save_to_file(material_file_path, material_content)
    material_guid = generate_meta_file('FileTemplates/template.mat.meta',path,material_name,'.mat')

    return material_guid
    