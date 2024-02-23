import bpy
from .format_conversion_utils import *

added_functions = set()
MaterialOutput_Surface_added = False

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
    destination_node=destination_node.replace(" ", "").replace(".", "")
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
    destination_node=destination_node.replace(" ", "").replace(".", "")
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
    nodeName = nodeName.replace(".", "")
    propName = propName.replace(" ", "")
    propName = propName.replace(".", "")

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
