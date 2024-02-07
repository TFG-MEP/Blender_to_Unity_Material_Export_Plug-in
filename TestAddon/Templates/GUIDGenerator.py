import uuid
from jinja2 import Template

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
    
def generateMetas():


    material_guid = generate_unity_style_guid()
    shader_guid = generate_unity_style_guid()

    ## .SHADER
    # . . . 
    # # (Aquí se debe generar el archivo .shader con la información de los nodos de Blender)

    ## .SHADER.META
    # Crear contexto para el .shader.meta
    #Al recorrer los nodos se guardara la ruta de las imagenes
    images=[]
    for idx, image in enumerate(images):
        # Generar metadatos para la imagen
        image_guid = generate_unity_style_guid()

        # Generar y guardar archivo .META para la imagen
        context_image_meta = {
            "guid": image_guid,
        }
        image_meta_template_str = load_template_from_file('template.image.meta')
        image_meta_content = render_template(image_meta_template_str, context_image_meta)
        image_meta_file_path =f"test_{idx}.meta"       
        save_to_file(image_meta_file_path, image_meta_content)

    context_shader_meta = {
        "guid": shader_guid,
    }
    # Renderizar y guardar el .shader.meta
    shader_meta_template_str = load_template_from_file('template.shader.meta')
    shader_meta_content = render_template(shader_meta_template_str, context_shader_meta)
    # El nombre del archivo deberá depender del nombre del material en blender
    shader_meta_file_path = "test.shader.meta" 
    save_to_file(shader_meta_file_path, shader_meta_content)

    ## .MAT
    context_material = {
        "material_name": "MyMaterial", # El nombre del material debe depender del nombre en blender
        "shader_guid": context_shader_meta["guid"],
        # aquí deben ir el resto de propiedades que se deban asignar al shader (textura, color, otros valores...)
    }
    material_template_str = load_template_from_file('template.mat')
    material_content = render_template(material_template_str, context_material)
    material_file_path = "test.mat"
    save_to_file(material_file_path, material_content)

    ## .MAT.META
    context_material_meta = {
        "guid": material_guid,
    }
    material_meta_template_str = load_template_from_file('template.mat.meta')
    material_meta_content = render_template(material_meta_template_str, context_material_meta)
    material_meta_file_path = "test.mat.meta"
    save_to_file(material_meta_file_path, material_meta_content)