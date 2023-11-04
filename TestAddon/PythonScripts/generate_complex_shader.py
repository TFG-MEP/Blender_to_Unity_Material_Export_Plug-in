import bpy

from dfs import dfs

# Recorrer los nodos en profundidad
def dfs(node, visited, hlsl_functions):
    visited.add(node)
    print("Nombre del nodo: ", node.name)

    if (node.name == 'Color Ramp') : 
        with open("color_ramp_template.txt", "r") as color_ramp_file:
            color_ramp_template = color_ramp_file.read()
    elif (node.name == 'Image Texture'):
        # do something
        i = 0
        

    hlsl_functions.append()

    # Recorre los nodos conectados
    for input_socket in node.inputs:
        for link in input_socket.links:
            next_node = link.from_node
            if next_node not in visited:
                dfs(next_node, visited)


# Define la ruta donde se guardarán los archivos .shader
output_path = "./GeneratedShaders/"

# Cargar la plantilla .shader
template_shader_path = "template.shader"

with open(template_shader_path, "r") as template_file:
    template_shader = template_file.read()

# Iterar a través de los materiales del objeto activo
obj = bpy.context.active_object
for i, material in enumerate(obj.data.materials):
    
    # Crear una copia de la plantilla para trabajar en ella
    shader_content = template_shader
    
    # Cambiar el nombre del shader
    shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material.name}_{i}")

    # Obtener el color base del material
    base_color = material.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value
    
    # Reemplazar el valor del color en la plantilla
    shader_content = shader_content.replace("{color_template}", f"({base_color[0]}, {base_color[1]}, {base_color[2]}, {base_color[3]})")
    
    # Guardar el archivo .shader con el nombre del material
    shader_filename = f"{material.name}_{i}.shader"
    shader_filepath = output_path + shader_filename
    
    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)
    
    print(f"Archivo {shader_filename} generado con éxito.")

print("Proceso completado.")