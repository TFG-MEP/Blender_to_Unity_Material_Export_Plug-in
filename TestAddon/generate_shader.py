import bpy
from .strategies_importer import *
from .format_conversion_utils import *
from .writing_utils import *

imagesMap={}

class Context():
    """
    The Context defines the interface of interest to clients.
    """

    def __init__(self, strategy: Strategy) -> None:
        """
        Usually, the Context accepts a strategy through the constructor, but
        also provides a setter to change it at runtime.
        """

        self._strategy = strategy

    @property
    def strategy(self) -> Strategy:
        """
        The Context maintains a reference to one of the Strategy objects. The
        Context does not know the concrete class of a strategy. It should work
        with all strategies via the Strategy interface.
        """

        return self._strategy

    @strategy.setter
    def strategy(self, strategy: Strategy) -> None:
        """
        Usually, the Context allows replacing a Strategy object at runtime.
        """

        self._strategy = strategy

    def write_node(self, node, node_properties, shader_content) -> None:
        """
        The Context delegates some work to the Strategy object instead of
        implementing multiple versions of the algorithm on its own.
        """

        if self._strategy is None:
            print("Context: No strategy set. Cannot write data.")
            return shader_content

        print("Context: Writting data using the strategy (not sure how it'll do it)")
        shader_content = self._strategy.write_node(node, node_properties, shader_content)
        return shader_content

class NodeInfo:
    def __init__(self, name="", nodeType=""):
        self.name = name
        self.nodeType = nodeType

"""
    Añade un nodo de tipo "Value" al shader.

    Parameters
    ----------
    node : bpy.types.Node
        Nodo de tipo "Value" a agregar en la concatenación de llamadas.
    node_properties : list
        Lista de propiedades del nodo.
    shader_content : str
        Contenido del shader.

    Returns
    -------
    shader_content : str
        Contenido del shader actualizado con el nodo "Value".
"""
def escribir_nodo_value(node, node_properties, shader_content) :

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")
    node_properties.append(node_name + "_Value")
    property_line = f'{node_name}_Value("Value", float) = {node.outputs["Value"].default_value}\n\t\t'
    # ... y se añaden al shader
    shader_content = escribir_propiedad(property_line, shader_content)

    variable_line = f'float {node_name}_Value;\n\t\t\t'
    shader_content = escribir_variable(variable_line, shader_content)

    # Se identifica el nodo conectado a la salida Value
    conexion_salida = node.outputs["Value"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("Value conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_nodo("HLSLTemplates/value.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content

def escribir_nodo_rgb(node, node_properties, shader_content) : 

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")

    node_properties.append(node_name + "_Color")

    node_color = convertir_valor(node.outputs["Color"].default_value, "Color")

    property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'
    # ... y se añaden al shader
    shader_content = escribir_propiedad(property_line, shader_content)

    variable_line = f'float4 {node_name}_Color;\n\t\t\t'
    shader_content = escribir_variable(variable_line, shader_content)

    # Se identifica el nodo conectado a la salida RGB
    conexion_salida = node.outputs["Color"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_nodo("HLSLTemplates/rgb.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content

def escribir_nodo_bsdf(node, node_properties, shader_content) :
    node_name=node.name.replace(".", "")
    conexion_salida = node.outputs["BSDF"].links[0]
    nodo_entrada = conexion_salida.to_node
    propiedad_entrada = conexion_salida.to_socket
    node_properties.insert(0, 'i')
    shader_content = escribir_nodo("HLSLTemplates/principled_bsdf.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_imageTexture(node, node_properties, shader_content):
    global imagesMap

    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")
    node_properties.append(node_name + "_Image")

    image_path = bpy.path.abspath(node.image.filepath)
    if image_path not in imagesMap:
        imagesMap[image_path] = []
    # Ahora agregamos el nombre del nodo de imagen al diccionario imagesMap
    imagesMap[image_path].append(f'{node_name}_Image')

    property_line = f'{node_name}_Image("Texture", 2D) = "white" {{}}\n\t\t'
    # ... y se añaden al shader
    shader_content = escribir_propiedad(property_line, shader_content)

    variable_line = f'sampler2D {node_name}_Image;\n\t\t\t'
    shader_content = escribir_variable(variable_line, shader_content)
    conexion_salida = node.outputs["Color"].links[0]
    nodo_entrada = conexion_salida.to_node
    propiedad_entrada = conexion_salida.to_socket
    #escribir_nodo(function_file_path, function_parameters, destination_node, destination_property, shader_content) 
    shader_content = escribir_nodo("HLSLTemplates/image_texture.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_TexCoord(node, node_properties, shader_content) : 

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")
    parameter=''
    # Verificar si el nodo UV está conectado
    if node.outputs.get('UV').is_linked:
        print("El nodo UV de Texture Coordinate está conectado a otro nodo.")
        conexion_salida = node.outputs["UV"].links[0]
        parameter='float3(i.uv,0)'
    elif node.outputs.get('Object').is_linked:
        print("El nodo UV de Texture Coordinate no está conectado a otro nodo.")
        conexion_salida = node.outputs["Object"].links[0]
    elif node.outputs.get('Generated').is_linked:
        print("El nodo UV de Texture Coordinate no está conectado a otro nodo.")
        conexion_salida = node.outputs["Generated"].links[0]
        parameter='i.worldPos'
   
    # Se identifica el nodo conectado a la salida RGB
    
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_raiz(parameter, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_mapping(node, node_properties, shader_content) : 

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")

    # Se identifica el nodo conectado a la salida RGB
    conexion_salida = node.outputs["Vector"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_nodo("HLSLTemplates/mapping.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_cheqker(node, node_properties, shader_content):
    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")
    # Se identifica el nodo conectado a la salida RGB
    conexion_salida = node.outputs["Color"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_nodo("HLSLTemplates/checker.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content

"""
    Recorre los nodos del material y los agrega al shader.

    Parameters
    ----------
    node : bpy.types.Node
        Nodo a procesar.
    shader_content : str
        Contenido del shader.

    Returns
    -------
    shader_content : str
        Contenido del shader actualizado con los nodos procesados.
"""
def recorrer_nodo(node, shader_content):
    nodeInfo = NodeInfo(name=node.name.replace(" ", "").replace(".", ""), nodeType=node.type.replace(" ", "").replace(".", ""))
    print ("Recorriendo nodo: " + node.type + "\n")
    
    node_properties = []

    # Se recorren las propiedades o inputs del nodo
    for input_socket in node.inputs :

        # Se guarda cada propiedad leída
        socket_name = input_socket.name.replace(" ", "")
        socket_name = socket_name.replace(".", "")
        node_properties.append(nodeInfo.name + "_" + socket_name)

        if input_socket.is_linked : # Si están conectados a otro nodo, se recorre este
            # input_socket.links[0] indica que solo trabajamos con una conexión 
            # por cada propiedad/input. Si por algún motivo hubiera más (en principio 
            # blender no permite hacer eso para los nodos con los que estamos trabajando), 
            # solo trabajamos con la primera. Si más adelante utilizamos nodos con múltiples
            # conexiones, habría que revisitar este apartado (pero esto no es un uso común).

            connected_node = input_socket.links[0].from_node
            shader_content = recorrer_nodo(connected_node, shader_content)
        else :
            # Crear en las propiedades del shader, una entrada para esta propiedad
            print("Property of " + nodeInfo.nodeType + ": " + input_socket.name + " with type: " + input_socket.bl_label)
            shader_content = procesar_propiedad(input_socket, nodeInfo.name, nodeInfo.nodeType, shader_content)

    # TO_DO quizás es mejor recorrer las salidas aquí
    context = Context(strategy=DefaultNode())

    if node.type == 'VALUE':
        shader_content = escribir_nodo_value(node, node_properties, shader_content)
    elif node.type == 'RGB' : 
        context.strategy = RGBNode()
    elif node.type == 'BSDF_PRINCIPLED' :
        shader_content = escribir_nodo_bsdf(node, node_properties, shader_content)
    elif node.type == 'TEX_IMAGE' :
        shader_content = escribir_nodo_imageTexture(node, node_properties, shader_content)
    elif node.type == 'TEX_COORD' :
        shader_content = escribir_nodo_TexCoord(node, node_properties, shader_content)
    elif node.type=='MAPPING' :
        shader_content=escribir_nodo_mapping(node, node_properties, shader_content)
    elif  node.type=='TEX_CHECKER':
        shader_content=escribir_nodo_cheqker(node, node_properties, shader_content)

    shader_content = context.write_node(node=node, node_properties=node_properties, shader_content=shader_content)

    return shader_content


def generate(destination_directory):
    # Cargar la plantilla .shader
    template_shader_path = "FileTemplates/template.shader"

    with open(template_shader_path, "r") as template_file:
        template_shader = template_file.read()

    # Crear una copia de la plantilla para trabajar en ella
    shader_content = template_shader
            
    selected_object = bpy.context.active_object
    material = selected_object.active_material
    material.use_nodes = True
    node_tree = material.node_tree
    nodes = node_tree.nodes
    root_node = nodes.get("Material Output")

    # Cambiar el nombre del shader
    shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material.name}_")

    shader_filename = f"{material.name}.shader"
    shader_filepath = f"{destination_directory}/{shader_filename}"

    shader_content = recorrer_nodo(root_node, shader_content)

    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)

    print(f"Archivo {shader_filename} generado con éxito.")
    print("Proceso completado.")

    if (MaterialOutput_Surface_added == False) : 
        print("ERROR: Hay que usar un nodo Material Output con algo conectado a la salida Surface")

    return material.name,imagesMap