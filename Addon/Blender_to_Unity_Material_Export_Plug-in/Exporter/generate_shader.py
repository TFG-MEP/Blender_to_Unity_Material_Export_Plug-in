import bpy
from .strategies_importer import *
from .format_conversion_utils import *
from .writing_utils import *
from .meta_generator import *
from .common_utils import *

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

    # Avoid iterating through already visited nodes
    if (node_name in get_common_values().visited_nodes) :
        return shader_content
    else :
        get_common_values().visited_nodes.add(node_name)

    # print ("Iterating through node: " + node.type + "\n")
    
    # List of property names in this node
    node_properties = []

    for input_socket in node.inputs :

        # Store each read property
        socket_name = input_socket.identifier.replace(" ", "")
        socket_name = socket_name.replace(".", "")
        property_name = node_name + "_" + socket_name

        node_properties.append(property_name)

        if input_socket.is_linked : # If connected to another node, iterate through it
            # input_socket.links[0] indicates that we are only working with one connection 
            # per property/input. If there were more (Blender does not allow this for the 
            # nodes we are working with), we would only work with the first one. If we later 
            # use nodes with multiple connections, we would need to revisit this section 
            # (but this is not a common use).

            connected_node = input_socket.links[0].from_node
            shader_content = iterate_node(connected_node, shader_content)
        elif socket_name == 'Vector':
            parameter='(i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);'
            if node.type == 'TEX_IMAGE' :
                parameter='float3(i.uv,0)'
            fragment_index = shader_content.find("// Call methods")
            func_line = f'float3 {node_name + "_" + socket_name} = {parameter};\n\t\t\t\t'
            shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]
        else :
            # Create an entry for this property in the shader properties
            # print("Property of " + node_type + ": " + input_socket.name + " with type: " + input_socket.bl_label)
            shader_content = process_property(input_socket, node_name, node_type, shader_content)

    strategy = node_type_strategy_map.get(node.type)
    context = Context(strategy=strategy)

    shader_content = context.write_node(node=node, node_properties=node_properties, shader_content=shader_content)

    return shader_content

def clean_material_name(name) : 
    material_name = re.sub(r'[^\w\s]', '', name).replace(' ', '')
    if material_name == "" :
        raise SystemExit("Material name contains only invalid symbols. Please use alphanumeric characters.")
    return material_name


def generate_shader(destination_directory,material):

    # Reset global variables
    get_common_values().clear_common_variables()

    material_name = clean_material_name(material.name)

    # Load the .shader template
    template_shader_path = "./FileTemplates/template.shader"

    with open(template_shader_path, "r") as template_file:
        template_shader = template_file.read()

    # Copy the template to work with it
    shader_content = template_shader
    
    # Needed include to work with the template
    # TODO : revisar pq la plantilla necesita el include
    shader_content = write_include("HLSLTemplates/BSDF/principled_bsdf_includes.txt",shader_content)

    #------------------------------------------------------BLENDING MODE AND CULLING MODE------------------------------------------------------
    get_common_values().blending_mode = material.blend_method
    
    #Agregamos aqui el culling mode porque es parte de los ajustes del material, no corresponde a un nodo especifico
    if material.use_backface_culling == False :
        shader_content= shader_content.replace("// Add culling", "Cull Off")
    
    #TODO: escribir el valor exacto de este de cutoff en el shader
    if material.blend_method== 'CLIP' :
        get_common_values().cutoff = material.alpha_threshold
            
    node_tree = material.node_tree
    nodes = node_tree.nodes
    # TODO : Qué pasa si hay más de un Material Output?
    root_node = nodes.get("Material Output")

    # TODO : eliminar cualquier posible caracter en el nombre del material
    # que no pueda ir en el nombre del shader o como nombre de archivo

    # Rename the shader
    #material_name = material.name.replace(" ", "").replace(".", "")
    shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material_name}_")

    shader_filename = f"{material_name}.shader"
    shader_filepath = f"{destination_directory}/{shader_filename}"

    shader_content = iterate_node(root_node, shader_content)

    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)

    print(f"{shader_filename} file successfully generated.")
    
    #if (get_common_values().MaterialOutput_Surface_added == False) : # TODO : comprobar que esto se imprime bien
    #    print("ERROR: You must use a Material Output node with something connected to Surface.")
    shader_guid = generate_meta_file('FileTemplates/template.shader.meta',destination_directory,material_name,'.shader')
    return material_name, get_common_values().imagesMap,shader_guid