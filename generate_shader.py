import bpy

# Define la ruta donde se guardarán los archivos .shader
output_path = "./GeneratedShaders/"

# Carga la plantilla .shader
template_shader_path = "template.shader"

with open(template_shader_path, "r") as template_file:
    template_shader = template_file.read()

# Itera a través de los materiales del objeto activo
obj = bpy.context.active_object
for i, material in enumerate(obj.data.materials):
    
    # Obtén el color base del material
    base_color = material.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value
    
    # Reemplaza el valor del color en la plantilla
    shader_content = template_shader.replace("(1, 1, 1, 1)", f"({base_color[0]}, {base_color[1]}, {base_color[2]}, {base_color[3]})")
    
    # Guarda el archivo .shader con el nombre del material
    shader_filename = f"{material.name}.shader"
    shader_filepath = output_path + shader_filename
    
    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)
    
    print(f"Archivo {shader_filename} generado con éxito.")

print("Proceso completado.")