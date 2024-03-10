from .generate_material import generate_files
from .generate_shader import generate
from .generate_3dModel import generate_3dModel

def export(path,export) :

    # Generate  .shader
    material_name, imagesMap = generate(path)

    # Generate .material and .meta
    generate_files(path, material_name,imagesMap)

    if export:
        # Generate 3D model
        generate_3dModel(path)

