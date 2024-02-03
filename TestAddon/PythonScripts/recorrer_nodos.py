import bpy

nodeInfo_map = {}

class NodeInfo:
    def __init__(self, name="", nodeType=""):
        self.name = name
        self.nodeType = nodeType
        self.properties = {} # "metallic" --> 1.0
        self.outputs = {}

def calcular_salidas_principled_bsdf(node, shader_content) :
    print('Analizando Principled BSDF: ' + node.name + '\n')

def calcular_salidas_rgb(node, shader_content) : 

    # Propiedad que ha definido el usuario en blender

    # Es posible que para calcular esta propiedad haya que realizar
    # un cálculo en tiempo real en Unity --> indicar en la plantilla

    # Aqui indicamos a la(s) plantilla(s) qué deben hacer

    # Un nodo RGB devuelve una lista de valores con un nº para cada canal
    print('Analizando RGB: ' + node.name + '\n')
    def_rgb = node.outputs[0].default_value
    float_values = list(def_rgb)
    mapLocator = node.name + "_" + node.outputs[0].name
    nodeInfo_map[mapLocator] = float_values

def calcular_salidas_value(node) : 
    print('Analizando VALUE: ' + node.name + '\n')
    mapLocator = node.name + "_" + "VALUE"
    nodeInfo_map[mapLocator] = node.outputs[0].default_value

def calcular_salidas_color_ramp(node, assignName) : 
    print('Analizando Color ramp: ' + node.name + '\n')

    # Añadir la función que calcula el color ramp en tiempo real
    # al apartado de funciones de la plantilla (estará guardada en un txt por ejemplo)

    # Añadir en la función fragment shader la llamada al método anterior
    # Escribir: "assignName = color_ramp(nombres de los parametros)"

    mapLocator = node.name + "_" + "VALUE"
    nodeInfo_map[mapLocator] = node.outputs[0].default_value

def escribir_propiedad(input_socket, nodeName, nodeType, shader_content): 
    
    propName = input_socket.name
    propLabel = input_socket.bl_label

    # Manejar casos en los que ignoramos algún tipo de dato concreto
    if propLabel == 'Shader' : # Las propiedades de tipo "shader" vienen dadas por un cálculo con otro nodo
        return shader_content

    # o alguna propiedad específica que no vamos a utilizar en Unity
    if nodeType == 'PRINCIPLED_BSDF' :
        if propName == 'IOR' : # Por ejemplo, si el IOR no lo usamos, lo ignoramos aquí
            return shader_content
    elif nodeType == 'OUTPUT_MATERIAL' : 
        # No escribimos ninguna propiedad de output, solo nos interesa lo que haya conectado a Surface
        # TO_DO : Probablemente pueda eliminarse este caso pues se decartará arriba al eliminar los 'Shader'
        return shader_content

    # Convertir el tipo de blender a tipos de Unity
    if propLabel == 'Float':
        propLabel = 'float'
    elif propLabel == 'Color' :
        propLabel = 'fixed4'
    elif propLabel == 'Vector' :
        propLabel = 'fixed3'

    # Sacamos el valor de la propiedad
    propValue = input_socket.default_value

    # TO_DO : operaciones con el valor si es necesario: normalizar, convertir valores, etc.

    # Quitar espacios a los nombres
    nodeName = nodeName.replace(" ", "")
    propName = propName.replace(" ", "")

    # Añadir la propiedad a la plantilla
    properties_index = shader_content.find("// Add properties")
    # Lo que se escribe es:
    # nombreDelNodo_nombreDeLaPropiedad("nombreDeLaPropiedad", TipoDeDatos) = ValorDeLaPropiedad
    property_line = f'{nodeName}_{propName}("{propName}", {propLabel}) = {propValue}\n\t\t'

    shader_content = shader_content[:properties_index] + property_line + shader_content[properties_index:]

    return shader_content


def recorrer_nodo(node, shader_content):
    nodeInfo = NodeInfo(name=node.name, nodeType=node.type)
    print ("Recorriendo nodo: " + node.name + "\n")
    
    # Se recorren las propiedades o inputs del nodo
    for input_socket in node.inputs :
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
            shader_content = escribir_propiedad(input_socket, nodeInfo.name, nodeInfo.nodeType, shader_content)

    # Switch para tipos específicos de nodos
    if node.type == 'VALUE':
        calcular_salidas_value(node)
    elif node.type == 'RGB' : 
        calcular_salidas_rgb(node, shader_content)
    elif node.type == 'COLOR_RAMP' : 
        calcular_salidas_color_ramp(node)
    elif node.type == 'PRINCIPLED_BSDF' : 
        calcular_salidas_principled_bsdf(node)

    return shader_content


def start():
    # Cargar la plantilla .shader
    template_shader_path = "template.shader"

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

    shader_filename = f"{material.name}_.shader"
    shader_filepath = "" + shader_filename

    shader_content = recorrer_nodo(root_node, shader_content)

    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)

    print(f"Archivo {shader_filename} generado con éxito.")
    print("Proceso completado.")