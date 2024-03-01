from .generate_material import generate_files
from .generate_shader import generate

def export(path) :

    # Generar el .shader
    material_name, imagesMap = generate(path)

    # Generar el .material y los .meta
    generate_files(path, material_name,imagesMap)

