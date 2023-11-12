import bpy



def nodeSelector(node,shader_content):
    if (node.name == 'Color Ramp') : 
     with open("color_ramp_template.txt", "r") as color_ramp_file:
        color_ramp_template = color_ramp_file.read()
    elif (node.name == 'Image Texture'):
        # do something
         i = 0
    elif(node.name== 'Checker Texture'):
        vector = node.inputs['Vector'].default_value
        color1 = node.inputs['Color1'].default_value
        color2 = node.inputs['Color2'].default_value
        scale = node.inputs['Scale'].default_value
     
        properties_list = [
        ("_Color1", "Color", f"({color1[0]}, {color1[1]}, {color1[2]}, {color1[3]})"),
        ("_Color2", "Color", f"({color2[0]}, {color2[1]}, {color2[2]}, {color2[3]})"),
        ("_Scale", "Float", scale)
        ]

       # Encuentra la posición de la cadena "// Añadir más propiedades aquí según sea necesario"
        index = shader_content.find("// Add properties")

        for prop_name, prop_type, prop_default in properties_list:
            property_line = f'{prop_name} ("{prop_name}", {prop_type}) = {prop_default}\n'
            shader_content = shader_content[:index] + property_line + shader_content[index:]

        index = shader_content.find("// Add variables")
        var_list = [
        ("fixed4", "_Color1"),
         ("fixed4", "_Color2")
        ]
        for var_type, var_name in var_list:
            property_line = f'{var_type} {var_name};\n'
            shader_content = shader_content[:index] + property_line + shader_content[index:]


    elif(node.name== 'Principled BSDF'):
        # Reemplazar el valor del color en la plantilla

        base_color = node.inputs['Base Color'].default_value
        print(f"Vector: {base_color[0],base_color[1],base_color[2]}")
        shader_content = shader_content.replace("{color_template}", f"({base_color[0]}, {base_color[1]}, {base_color[2]}, {base_color[3]})")
       
    return shader_content 


# Recorrer los nodos en profundidad
def dfs(node, visited,shader_content):
    visited.add(node)
    print("Nombre del nodo: ", node.name)
    shader_content= nodeSelector(node,shader_content)
    ##hlsl_functions.append()

    # Recorre los nodos conectados
    for input_socket in node.inputs:
        for link in input_socket.links:
            next_node = link.from_node
            if next_node not in visited:
                shader_content=dfs(next_node, visited,shader_content)

    return shader_content

def generateShader(path):
     # Obtiene una referencia al objeto que tiene el material
    obj = bpy.context.object  # Cambia esto al nombre o índice de tu objeto

    # Asegúrate de que el objeto tenga un material
    if obj.data.materials:
        # Accede al primer material asignado al objeto (índice 0)
        material = obj.data.materials[0]
        
        output_path = path

        # Cargar la plantilla .shader
        template_shader_path = "template.shader"

        with open(template_shader_path, "r") as template_file:
            template_shader = template_file.read()

        # Iterar a través de los materiales del objeto activo
        obj = bpy.context.active_object
   
        # Crear una copia de la plantilla para trabajar en ella
        shader_content = template_shader
            
        # Cambiar el nombre del shader
        shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material.name}_")


        # Accede al nodo del material en el Shader Editor
        material.use_nodes = True
        node_tree = material.node_tree
        nodes = node_tree.nodes

        # Nodo raíz
        root_node = nodes.get("Material Output")
        if root_node:
            visited = set()
            shader_content=dfs(root_node, visited,shader_content)

        shader_filename = f"{material.name}_.shader"
        shader_filepath = output_path + shader_filename

        with open(shader_filepath, "w") as shader_file:
            shader_file.write(shader_content)

        print(f"Archivo {shader_filename} generado con éxito.")
        print("Proceso completado.")
