import bpy
from .strategies_importer import *
from .format_conversion_utils import *
from .writing_utils import *

imagesMap = {}

class Context():

    def __init__(self, strategy: Strategy) -> None:

        self._strategy = strategy

    @property
    def strategy(self) -> Strategy:

        return self._strategy

    @strategy.setter
    def strategy(self, strategy: Strategy) -> None:
        """
        The Context allows replacing a Strategy object at runtime.
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

        shader_content = self._strategy.write_node(node, node_properties, shader_content)
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
    shader_content = write_property(property_line, shader_content)

    variable_line = f'float {node_name}_Value;\n\t\t\t'
    shader_content = write_variable(variable_line, shader_content)

    # Se identifica el nodo conectado a la salida Value
    conexion_salida = node.outputs["Value"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("Value conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = write_node("HLSLTemplates/value.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content

def escribir_nodo_rgb(node, node_properties, shader_content) : 

    # Se buscan las propiedades específicas de este tipo de nodo...
    node_name = node.name.replace(" ", "")
    node_name=node_name.replace(".", "")

    node_properties.append(node_name + "_Color")

    node_color = blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")

    property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'
    # ... y se añaden al shader
    shader_content = write_property(property_line, shader_content)

    variable_line = f'float4 {node_name}_Color;\n\t\t\t'
    shader_content = write_variable(variable_line, shader_content)

    # Se identifica el nodo conectado a la salida RGB
    conexion_salida = node.outputs["Color"].links[0]
    nodo_entrada = conexion_salida.to_node
    # y la propiedad específica de dicho nodo que lo recibe
    propiedad_entrada = conexion_salida.to_socket
    #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
    shader_content = write_node("HLSLTemplates/rgb.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content

def escribir_nodo_bsdf(node, node_properties, shader_content) :
    node_name=node.name.replace(".", "")
    conexion_salida = node.outputs["BSDF"].links[0]
    nodo_entrada = conexion_salida.to_node
    propiedad_entrada = conexion_salida.to_socket
    node_properties.insert(0, 'i')
    shader_content = write_node("HLSLTemplates/principled_bsdf.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

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
    shader_content = write_property(property_line, shader_content)

    variable_line = f'sampler2D {node_name}_Image;\n\t\t\t'
    shader_content = write_variable(variable_line, shader_content)
    conexion_salida = node.outputs["Color"].links[0]
    nodo_entrada = conexion_salida.to_node
    propiedad_entrada = conexion_salida.to_socket
    #write_node(function_file_path, function_parameters, destination_node, destination_property, shader_content) 
    shader_content = write_node("HLSLTemplates/image_texture.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

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
    shader_content = write_root(parameter, nodo_entrada, propiedad_entrada, shader_content)

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
    shader_content = write_node("HLSLTemplates/mapping.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

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
    shader_content = write_node("HLSLTemplates/checker.txt", node_properties, nodo_entrada, propiedad_entrada, shader_content)

    return shader_content


def iterate_node(node, shader_content):
    """ Iterates through a materials nodes and adds them to the shader template.
    
    Args:
        node (bpy.types.Node) : Node to process
        shader_content (str) : Shader template current content

    Returns:
        str : Updated shader template with the current processed nodes.
    """
    node_name = node.name.replace(" ", "").replace(".", "")
    node_type = node.type.replace(" ", "").replace(".", "") 

    print ("Iterating through node: " + node.type + "\n")
    
    node_properties = []

    for input_socket in node.inputs :

        # Store each read property
        socket_name = input_socket.name.replace(" ", "")
        socket_name = socket_name.replace(".", "")
        node_properties.append(node_name + "_" + socket_name)

        if input_socket.is_linked : # If connected to another node, iterate through it
            # input_socket.links[0] indicates that we are only working with one connection 
            # per property/input. If there were more (Blender does not allow this for the 
            # nodes we are working with), we would only work with the first one. If we later 
            # use nodes with multiple connections, we would need to revisit this section 
            # (but this is not a common use).

            connected_node = input_socket.links[0].from_node
            shader_content = iterate_node(connected_node, shader_content)
        else :
            # Create an entry for this property in the shader properties
            print("Property of " + node_type + ": " + input_socket.name + " with type: " + input_socket.bl_label)
            shader_content = process_property(input_socket, node_name, node_type, shader_content)

    # TODO : quizás es mejor recorrer las salidas aquí

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

    # Load the .shader template
    template_shader_path = "FileTemplates/template.shader"

    with open(template_shader_path, "r") as template_file:
        template_shader = template_file.read()

    # Copy the template to work with it
    shader_content = template_shader
            
    selected_object = bpy.context.active_object
    material = selected_object.active_material
    material.use_nodes = True
    node_tree = material.node_tree
    nodes = node_tree.nodes
    root_node = nodes.get("Material Output")

    # Rename the shader
    shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material.name}_")

    shader_filename = f"{material.name}.shader"
    shader_filepath = f"{destination_directory}/{shader_filename}"

    shader_content = iterate_node(root_node, shader_content)

    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)

    print(f"{shader_filename} file successfully generated.")
    print("Process finished.")

    if (get_MaterialOutput_Surface_added() == False) :
        print("ERROR: You must use a Material Output node with something connected to Surface.")

    clear_global_variables()

    return material.name, imagesMap