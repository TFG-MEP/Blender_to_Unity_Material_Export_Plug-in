import bpy

nodeInfo_map = {}

class NodeInfo:
    def __init__(self, name="", nodeType=""):
        self.name = name
        self.nodeType = nodeType
        self.properties = {} # "metallic" --> 1.0
        self.outputs = {}

def calcular_salidas_principled_bsdf(nodeInfo) :
    print('Analizando Principled BSDF: ' + nodeInfo.name + '\n')

    # ... interpretar el formato de la salida (output) si es necesario
    #  y guardarlo en el mapa
    nodeInfo_map[nodeInfo.name + "_" + "BSDF"] = nodeInfo.outputs["BSDF"]
    # Repetir para todas las salidas

    # Se acceden a las propiedades necesarias/relevantes para calcular la salida
    # EN NUESTRO SHADER!! para copiarlas al .material si es necesario

def calcular_salidas_rgb(node) : 

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


def recorrer_nodo(node):
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
            recorrer_nodo(connected_node)
            #mapLocator = connected_node.name + "_" + connected_node.outputs[input_socket.links[0].from_socket.name]
            #nodeInfo.properties[input_socket.name, nodeInfo_map[mapLocator]]
        else :
            # Crear en las propiedades del shader, un atributo que se llame
            # nombre_del_nodo_nombre_de_la_propiedad = valor asociado (default_value)
            #nodeInfo.properties[input_socket.name, nodeInfo_map[mapLocator]]
            
    # Switch para tipos específicos de nodos
    if node.type == 'VALUE':
        calcular_salidas_value(node)
    elif node.type == 'RGB' : 
        calcular_salidas_rgb(node)
    elif node.type == 'COLOR_RAMP' : 
        calcular_salidas_color_ramp(node)

    

def start():
    selected_object = bpy.context.active_object
    material = selected_object.active_material
    material.use_nodes = True
    node_tree = material.node_tree
    nodes = node_tree.nodes
    root_node = nodes.get("Material Output")

    recorrer_nodo(root_node)
    print("done")