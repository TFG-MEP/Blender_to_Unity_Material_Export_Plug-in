import bpy

added_functions = set()
MaterialOutput_Surface_added = False
imagesMap={}

class NodeInfo:
    def __init__(self, name="", nodeType=""):
        self.name = name
        self.nodeType = nodeType

# Dado un valor de propiedad de un tipo concreto en blender, devuelve un
# string con el formato adecuado en HLSL
def convertir_valor(blender_input, input_type) : 
    if (input_type == 'Float') :
        return blender_input
    elif (input_type == 'Color') :
        return f'({blender_input[0]},{blender_input[1]},{blender_input[2]}, 1.0)'
    elif(input_type == 'Vector') :
        return f'({blender_input[0]}, {blender_input[1]}, {blender_input[2]})'
    else : 
        return blender_input

# Convierte un string que determina un tipo de datos usado por blender,
# en un string con el tipo de datos equivalente en HLSL
def convertir_tipos_hlsl(blender_input):
    if blender_input == 'Float':
        output = 'float'
    elif blender_input == 'Color' :
        output = 'float4'
    elif blender_input == 'Vector' :
        output = 'float3'
    elif blender_input == 'Shader' :
        output = 'float4'
    else : 
        output = blender_input
    # TO_DO : completar con todos los tipos de datos
    return output

# Convierte un string que determina un tipo de datos usado por blender,
# en un string con el tipo de datos equivalente en las propiedades del shader
def convertir_tipos_propiedad(blender_input):
    if blender_input == 'Float':
        output = 'float'
    elif blender_input == 'Color' :
        output = 'Color'
    elif blender_input == 'Vector' :
        output = 'Vector'
    elif blender_input == 'Shader' :
        output = 'Color'
    else : 
        output = blender_input
    # TO_DO : completar con todos los tipos de datos
    return output

"""
    Añade un método HLSL y su llamada en el shader.

    Parameters
    ----------
    function_file_path : str
        Ruta del archivo HLSL que contiene el método.
    function_parameters : list
        Lista de parámetros del nodo, o parámetros de llamada a la función.
    destination_node : bpy.types.Node
        Nodo de destino donde se conectará la salida del nodo actual.
    destination_property : bpy.types.NodeSocket
        Propiedad de destino donde se conectará la salida del nodo actual.
    shader_content : str
        Contenido del shader.

    Returns
    -------
    shader_content : str
        Contenido del shader actualizado con el método HLSL y su llamada.
"""
def escribir_nodo(function_file_path, function_parameters, destination_node, destination_property, shader_content) : 

    global added_functions
    global MaterialOutput_Surface_added

    # Comprobar si la función HLSL ya se ha agregado al shader
    if function_file_path not in added_functions:

        # Se lee el archivo donde está el método HLSL para este tipo de nodo
        with open(function_file_path, "r") as node_func_file:
            node_function = node_func_file.read()

        # Añadir la función en la sección de la plantilla indicada para ello
        methods_index = shader_content.find("// Add methods")
        shader_content = shader_content[:methods_index] + node_function + "\n\t\t\t" + shader_content[methods_index:]

        # Actualizar el conjunto de funciones HLSL escritas
        added_functions.add(function_file_path)

    prop_type = convertir_tipos_hlsl(destination_property.bl_label)
    # Quitar espacios a los nombres
    destination_node = destination_node.name.replace(" ", "")
    destination_property = destination_property.name.replace(" ", "")
    # Obtenemos el nombre del archivo sin extensión (debe coincidir con el nombre de la función)
    dot_index = function_file_path.find('.')
    slash_index = function_file_path.find('/')
    function_name = function_file_path[slash_index+1:dot_index]

    # Añadir la llamada a la función en el fragment shader
    fragment_index = shader_content.find("// Call methods")

    # El resultado de la llamada a esta función se asigna a lo que indique su conexión
    destination_name = destination_node + "_" + destination_property

    all_parameters = ', '.join(function_parameters)


    func_line = f'{prop_type} {destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    #func_line = f'{destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    if destination_name == 'MaterialOutput_Surface' :
        MaterialOutput_Surface_added = True

    return shader_content
def escribir_raiz( parameter, destination_node, destination_property, shader_content) : 

    global MaterialOutput_Surface_added
    prop_type = convertir_tipos_hlsl(destination_property.bl_label)
    # Quitar espacios a los nombres
    destination_node = destination_node.name.replace(" ", "")
    destination_property = destination_property.name.replace(" ", "")
    # Obtenemos el nombre del archivo sin extensión (debe coincidir con el nombre de la función)
    # Añadir la llamada a la función en el fragment shader
    fragment_index = shader_content.find("// Call methods")
    # El resultado de la llamada a esta función se asigna a lo que indique su conexión
    destination_name = destination_node + "_" + destination_property
    func_line = f'{prop_type} {destination_name} = {parameter};\n\t\t\t\t'
    #func_line = f'{destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    if destination_name == 'MaterialOutput_Surface' :
        MaterialOutput_Surface_added = True

    return shader_content

"""
    Procesa una propiedad de un nodo de blender y las añade al shader
    en un formato adaptado.

    Parameters
    ----------
    input_socket : bpy.types.NodeSocket
        Propiedad del nodo a procesar.
    nodeName : str
        Nombre del nodo.
    nodeType : str
        Tipo del nodo.
    shader_content : str
        Contenido del shader.

    Returns
    -------
    shader_content : str
        Contenido del shader actualizado con la propiedad procesada.
"""
def procesar_propiedad(input_socket, nodeName, nodeType, shader_content): 
    
    propName = input_socket.name
    propLabel = input_socket.bl_label

    # Ignorar propiedades de tipo "Shader"
    if propLabel == 'Shader' : # Las propiedades de tipo "shader" vienen dadas por un cálculo con otro nodo
        return shader_content

    # Ignorar propiedades específicas de ciertos tipos de nodos
    #if nodeType == 'BSDF_PRINCIPLED' :
        #if propName == 'IOR' : # Por ejemplo, si el IOR no lo usamos, lo ignoramos aquí
            #return shader_content
    if nodeType == 'OUTPUT_MATERIAL' : 
        # No escribimos ninguna propiedad de output, solo nos interesa lo que haya conectado a Surface
        return shader_content

    # Convertir el tipo de blender a tipos de Unity/HLSL
    propLabel = convertir_tipos_propiedad(propLabel)
    propLabelVariable=convertir_tipos_hlsl(propLabel)
    # Sacamos el valor de la propiedad
    propValue = input_socket.default_value

    # TO_DO : operaciones con el valor si es necesario: normalizar, convertir a valores que entienda el shader, etc.
    propValue = convertir_valor(propValue, input_socket.bl_label)

    # Quitar espacios a los nombres
    nodeName = nodeName.replace(" ", "")
    propName = propName.replace(" ", "")

    # Añadir la propiedad a la plantilla
    # Lo que se escribe es:
    # nombreDelNodo_nombreDeLaPropiedad("nombreDeLaPropiedad", TipoDeDatos) = ValorDeLaPropiedad
    property_line = f'{nodeName}_{propName}("{propName}", {propLabel}) = {propValue}\n\t\t'
    shader_content = escribir_propiedad(property_line, shader_content)

    variable_line = f'{propLabelVariable} {nodeName}_{propName};\n\t\t\t'
    shader_content = escribir_variable(variable_line, shader_content)

    return shader_content

"""
    Agrega una línea a la sección de propiedades del shader.

    Parameters
    ----------
    line : str
        Línea con la propiedad a escribir.
    shader_content : str
        Contenido actual del shader.

    Returns
    -------
    shader_content : str
        Contenido del shader actualizado con la nueva propiedad.
"""
def escribir_propiedad(line, shader_content) : 
    properties_index = shader_content.find("// Add properties")
    shader_content = shader_content[:properties_index] + line + shader_content[properties_index:]

    return shader_content

def escribir_variable(line, shader_content) : 

    variables_index = shader_content.find("// Add variables")
    shader_content = shader_content[:variables_index] + line + shader_content[variables_index:]

    return shader_content
def igualar_variable(line, shader_content) : 

    variables_index = shader_content.find("//Equal Variables")
    shader_content = shader_content[:variables_index] + line + shader_content[variables_index:]

    return shader_content

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

    variable_line = f'float3 {node_name}_Value;\n\t\t\t'
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

    conexion_salida = node.outputs["BSDF"].links[0]
    nodo_entrada = conexion_salida.to_node
    propiedad_entrada = conexion_salida.to_socket
    print("Nodo BSDF properties: ")
    print(node_properties)
    node_properties.insert(0, 'i')
    shader_content = escribir_nodo("HLSLTemplates/principled_bsdf.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_imageTexture(node, node_properties, shader_content):
    global imagesMap
    node_name = node.name.replace(" ", "")
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
   
    # Verificar si el nodo UV está conectado
    if node.outputs.get('UV').is_linked:
        print("El nodo UV de Texture Coordinate está conectado a otro nodo.")
        conexion_salida = node.outputs["UV"].links[0]
    elif node.outputs.get('Object').is_linked:
        print("El nodo UV de Texture Coordinate no está conectado a otro nodo.")
        conexion_salida = node.outputs["Object"].links[0]

   
    # Se identifica el nodo conectado a la salida RGB
    
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_raiz('float3(i.uv,0)', nodo_entrada, propiedad_entrada, shader_content)

    return shader_content
def escribir_nodo_mapping(node, node_properties, shader_content) : 

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
   

    # Se identifica el nodo conectado a la salida RGB
    conexion_salida = node.outputs["Vector"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = escribir_nodo("HLSLTemplates/mapping.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

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
    nodeInfo = NodeInfo(name=node.name.replace(" ", ""), nodeType=node.type.replace(" ", ""))
    print ("Recorriendo nodo: " + node.name + "\n")
    
    node_properties = []

    # Se recorren las propiedades o inputs del nodo
    for input_socket in node.inputs :

        # Se guarda cada propiedad leída
        socket_name = input_socket.name.replace(" ", "")
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

    if node.type == 'VALUE':
        shader_content = escribir_nodo_value(node, node_properties, shader_content)
    elif node.type == 'RGB' : 
        shader_content = escribir_nodo_rgb(node, node_properties, shader_content)
    elif node.type == 'BSDF_PRINCIPLED' :
        shader_content = escribir_nodo_bsdf(node, node_properties, shader_content)
    elif node.type == 'TEX_IMAGE' :
        shader_content = escribir_nodo_imageTexture(node, node_properties, shader_content)
    elif node.type == 'TEX_COORD' :
        shader_content = escribir_nodo_TexCoord(node, node_properties, shader_content)
    elif node.type=='MAPPING' :
        shader_content=escribir_nodo_mapping(node, node_properties, shader_content)
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