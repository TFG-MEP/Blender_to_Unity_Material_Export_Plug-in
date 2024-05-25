import uuid
import os
from jinja2 import Template

def generate_unity_style_guid():
    generated_uuid = uuid.uuid4()
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

def generate_meta_file(template_path,file_path,name,extension):

    #Generate guid
    guid = generate_unity_style_guid()
    context_shader_meta = {
        "guid": guid,
    }

    # Render and save the .meta
    meta_template_str = load_template_from_file(template_path)
    meta_content = render_template(meta_template_str, context_shader_meta)
    shader_meta_file_path = f"{file_path}/{name}{extension}.meta" 
    save_to_file(shader_meta_file_path, meta_content)
    return guid