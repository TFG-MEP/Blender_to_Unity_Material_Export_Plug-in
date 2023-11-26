import bpy
from jinja2 import Template
class DfsBlender:
    properties=[]
    variables=[]
    methods=[]
    def nodeSelector(node):

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
            DfsBlender.properties+=[("_Color1","Color1" ,"Color", f"({color1[0]}, {color1[1]}, {color1[2]}, {color1[3]})"),
                      ("_Color2","Color2"  ,"Color", f"({color2[0]}, {color2[1]}, {color2[2]}, {color2[3]})"),
                          ("_Scale","Scale", "Float", scale) ]
   

            DfsBlender.variables+=[ ("fixed4", "_Color1"),
                                    ("fixed4", "_Color2"),
                                    ("float", "_Scale")
                                    ]
            
            
            hlsl_file_path = "checker.txt"
            # Lee el contenido del archivo HLSL
            with open(hlsl_file_path, "r") as hlsl_file:
                hlsl_method_content = hlsl_file.read()

            DfsBlender.methods.append(hlsl_method_content);
           
            
            # property_line = f'color=checker(i.worldPos,_Color1,_Color2,_Scale);\n'
            # shader_content = shader_content[:index] + property_line + shader_content[index:]
        elif(node.name== 'Principled BSDF'):
            # Reemplazar el valor del color en la plantilla

            base_color = node.inputs['Base Color'].default_value
            print(f"Vector: {base_color[0],base_color[1],base_color[2]}")
            # shader_content = shader_content.replace("{color_template}", f"({base_color[0]}, {base_color[1]}, {base_color[2]}, {base_color[3]})")
        
  


    # Recorrer los nodos en profundidad
    def dfs(node, visited):
        visited.add(node)
        print("Nombre del nodo: ", node.name)
        DfsBlender. nodeSelector(node)
        ##hlsl_functions.append()

        # Recorre los nodos conectados
        for input_socket in node.inputs:
            for link in input_socket.links:
                next_node = link.from_node
                if next_node not in visited:
                    DfsBlender.dfs(next_node, visited)



# recorrido de los nodos(nodo desde el cual empiezo a recorrer):
#     recorro cada propiedad del nodo(aka cada arista)
#         para cada propiedad, hago lo mismo hasta llegar a una que no tenga aristas
#             voy devolviendo lo que obtenga en el nodo 

def generateShader(path):
    # Obtiene una referencia al objeto que tiene el material
    obj = bpy.context.object

    # Asegúrate de que el objeto tenga un material
    if obj.data.materials:
        # Accede al primer material asignado al objeto (índice 0)
        material = obj.data.materials[0]
        
        output_path = path

        # Cargar la plantilla .shader
        template_shader_path = "templateJinja.shader"

        with open(template_shader_path, "r") as template_file:
            template_content = template_file.read()

        # Crear una instancia de la clase Template con la plantilla cargada
        shader_template = Template(template_content)

        # Iterar a través de los materiales del objeto activo
        obj = bpy.context.active_object
   
        # Accede al nodo del material en el Shader Editor
        material.use_nodes = True
        node_tree = material.node_tree
        nodes = node_tree.nodes

        # Nodo raíz
        root_node = nodes.get("Material Output")
        if root_node:
            visited = set()
            DfsBlender.dfs(root_node, visited)

       
        shader_filename = f"{material.name}_.shader"
        shader_filepath = output_path + shader_filename
        print(DfsBlender.properties)
        print(DfsBlender.methods)
        shader_data = {
        "shader_name": f"Shader{material.name}_",
        "properties":DfsBlender.properties,
        "variables": DfsBlender.variables,
        "methods": DfsBlender.methods
         }
      
        shader_content = shader_template.render(**shader_data)
        with open(shader_filepath, "w") as shader_file:
            shader_file.write(shader_content)

        print(f"Archivo {shader_filename} generado con éxito.")
        print("Proceso completado.")
