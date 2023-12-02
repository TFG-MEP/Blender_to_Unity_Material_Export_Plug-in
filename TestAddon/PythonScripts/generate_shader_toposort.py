import bpy
from jinja2 import Template

"""
Aplica corrección gamma a los valores de entrada.

La corrección gamma ajusta el brillo de una imagen en pantalla.
En esta función se usa una aproximación común del valor
usado para hacer la corrección (2.2).

Parameters:
- values (list): Lista de valores numéricos que representan canales de color RGB.

Returns:
- list: La misma lista con nuevos valores corregidos con el valor 2.2
"""
def gamma_correction(values):
    return [value ** (1 / 2.2) for value in values]

class DfsBlender:
    properties = []
    variables = []
    methods = []

    """ 
    Recorre todos los nodos conectados a un nodo inicial mediante
    una depth-first search (búsqueda en profundidad)
    """
    def dfs(node, visited):
        visited.add(node)
        print("\tNombre del nodo visitado: ", node.name)

        # recorro cada propiedad del nodo
        for input_socket in node.inputs:
            # y cada arista que sale 
            for link in input_socket.links:
                # si no ha sido visitado antes, se evalua el nodo conectado
                next_node = link.from_node
                if next_node not in visited:
                    DfsBlender.get_node_value(next_node)


    """
    Evalua el tipo de un nodo y devuelve el valor que devuelve 
    dicho nodo hacia adelante en el grafo de materiales. 

    Dentro de este método se modifica la plantilla del shader
    para que tenga en cuenta las acciones realizadas por los
    nodos a la hora de evaluar el valor de salida del shader.

    Parameters:
    - node (Blender Node): Nodo del grado de materiales de blender
    que se está tratando en este script.

    Returns:
    - Valor que proporciona el nodo
    """
    def get_node_value(node) :
 
        # Evaluamos cada caso según el tipo de nodo
        if (node.type == 'RGB') :
            # Un nodo RGB devuelve una lista de valores con un nº para cada canal
            print('Analizando RGB\n')
            def_rgb = node.outputs[0].default_value
            float_values = list(def_rgb)
            return float_values
        elif(node.type=='VALUE'):
            print('Analizando nodo value\n')
            single_value=node.outputs[0].default_value
            print("valor value: "+str(single_value))
            return single_value
        elif(node.type=="BSDF_PRINCIPLED"):
            print('Analizando principled\n')
            baseColor= DfsBlender.get_node_value(node.inputs['Base Color'].links[0].from_node)
            metallic=DfsBlender.get_node_value(node.inputs['Metallic'].links[0].from_node)
            roughness=DfsBlender.get_node_value(node.inputs['Roughness'].links[0].from_node)
            return
        elif (node.type == 'TEX_CHECKER') : 

            # TO_DO :
            # Se debe comprobar que las llamadas recursivas devuelven
            # un valor y poner uno por defecto si no lo hacen

            # TO_DO : analizar los nodos conectados a Vector y Scale recursivamente
            vector = node.inputs['Vector'].default_value
            scale = node.inputs['Scale'].default_value

            # Este código recorre los nodos que "entran" hacia este nodo pasandole 
            # algun tipo de información
            # for n_inputs in node.inputs:
            #     for node_links in n_inputs.links:
            #         print("nodes in tex_checker : " + node_links.from_node.name)
            
            # Los colores se obtienen según lo que determine el canal 'Color1/2' del nodo
            color1 = DfsBlender.get_node_value(node.inputs['Color1'].links[0].from_node)
            color2 = DfsBlender.get_node_value(node.inputs['Color2'].links[0].from_node)

            # se añaden las propiedades obtenidas al shader
            DfsBlender.properties+=[("_Color1","Color1" ,"Color", f"({color1[0]}, {color1[1]}, {color1[2]}, {color1[3]})"),
                ("_Color2","Color2"  ,"Color", f"({color2[0]}, {color2[1]}, {color2[2]}, {color2[3]})"),
                    ("_Scale","Scale", "Float", scale) ]


            DfsBlender.variables+=[ ("fixed4", "_Color1"),
                                    ("fixed4", "_Color2"),
                                    ("float", "_Scale")
                                    ]


            # Copiamos de un txt el método que calcula el checker texture en HLSL
            # a nuestro shader, para usarlo en ejecución
            hlsl_file_path = "checker.txt"

            # Lee el contenido del archivo HLSL
            with open(hlsl_file_path, "r") as hlsl_file:
                hlsl_method_content = hlsl_file.read()

            DfsBlender.methods.append(hlsl_method_content)


# Genera un archivo .shader a partir de una plantilla y la información
# obtenida de blender en la ubicación indicada en 'path'
def generateShader(path):

    # Referencia al objeto que tiene el material
    obj = bpy.context.object

    if obj.data.materials:

        # Accede al primer material asignado al objeto
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

        # Empezamos a recorrer desde el Nodo raíz
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
