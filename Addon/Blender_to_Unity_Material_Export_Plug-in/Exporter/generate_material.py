import uuid
import os
from jinja2 import Template
import shutil

def generate_unity_style_guid():
    generated_uuid = uuid.uuid4()
    # Obtiene la representación hexadecimal sin guiones
    return generated_uuid.hex

def render_template(template_str, context):
    template = Template(template_str, variable_start_string="${", variable_end_string="}$")
    return template.render(context)

def save_to_file(file_path, content):
    with open(file_path, 'w') as file:
        file.write(content)

def load_template_from_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()
def texturesInMaterial(imageVariables):
    textList = []
    total_elementos = len(imageVariables)
    for index, (nombre_variable, guid) in enumerate(imageVariables.items()):
        entrada = f' {nombre_variable}:\n        '
        entrada += 'm_Texture: {fileID: 2800000, guid: ' + guid + ', type: 3}\n        '
        entrada += 'm_Scale: {x: 1, y: 1}\n        '
        entrada += 'm_Offset: {x: 0, y: 0}'
        entrada += '\n    '
        textList.append(entrada)

    
    # textList=[]
    # for nombre_variable, guid in imageVariables.items():
    #     entrada = f'\t{nombre_variable}: \n\t\t\t\t'
    #     entrada += 'm_Texture: {fileID: 2800000, guid: ' + guid + ', type: 3},\n\t\t\t\t'
    #     entrada += 'm_Scale: {x: 1, y: 1},\n\t\t\t\t'
    #     entrada += 'm_Offset: {x: 0, y: 0}\n\t\t\t'
    #     textList.append(entrada)
    # if imageVariables.items()==0:
    #     textList.append('[]')
    return textList 
    
def generate_files(path, material_name,imagesMap):

    material_guid = generate_unity_style_guid()
    shader_guid = generate_unity_style_guid()
    
    #Al recorrer los nodos se guardara la ruta de las imagenes
    #nos guardamos en un map el nombre de la variable con su guid para pasarselo al material
    imageVariables={}
    for image_path, node_names in imagesMap.items():
        print("Ruta de la imagen:", image_path)
        print("Nombres de nodos de imagen asociados:")
        shutil.copy(image_path, path)
        image_guid = generate_unity_style_guid()
        # Generar y guardar archivo .META para la imagen
        context_image_meta = {
            "guid": image_guid,
        }    
        nombre_final = os.path.basename(image_path)
        nombre_final, extension = os.path.splitext(nombre_final)
        print(nombre_final)
        image_meta_template_str = load_template_from_file('FileTemplates/template.image.meta')
        image_meta_content = render_template(image_meta_template_str, context_image_meta)
        image_meta_file_path =f"{path}/{nombre_final}{extension}.meta"    
        save_to_file(image_meta_file_path, image_meta_content)
        for variable in node_names:
            imageVariables[variable]=image_guid
            print(variable)
        print()  # Espacio en blanco entre cada imagen
  
   

    ## .SHADER.META
    # Crear contexto para el .shader.meta
    context_shader_meta = {
        "guid": shader_guid,
    }
    # Renderizar y guardar el .shader.meta
    shader_meta_template_str = load_template_from_file('FileTemplates/template.shader.meta')
    shader_meta_content = render_template(shader_meta_template_str, context_shader_meta)
    # El nombre del archivo deberá depender del nombre del material en blender
    shader_meta_file_path = f"{path}/{material_name}.shader.meta" 
    save_to_file(shader_meta_file_path, shader_meta_content)

    ## .MAT
    context_material = {
        "material_name": material_name, # El nombre del material debe depender del nombre en blender
        "shader_guid": context_shader_meta["guid"],
        "tex_env_strings": texturesInMaterial(imageVariables)
       
        # aquí deben ir el resto de propiedades que se deban asignar al shader (textura, color, otros valores...)
    }
    material_template_str = load_template_from_file('FileTemplates/template.mat')
    material_content = render_template(material_template_str, context_material)
    material_file_path = f"{path}/{material_name}.mat"
    save_to_file(material_file_path, material_content)

    ## .MAT.META
    context_material_meta = {
        "guid": material_guid,
    }
    material_meta_template_str = load_template_from_file('FileTemplates/template.mat.meta')
    material_meta_content = render_template(material_meta_template_str, context_material_meta)
    material_meta_file_path = f"{path}/{material_name}.mat.meta"
    save_to_file(material_meta_file_path, material_meta_content)
    print("END")  # Espacio en blanco entre cada imagen