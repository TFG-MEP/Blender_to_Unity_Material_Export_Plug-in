import bpy
import sys

from .meta_generator import *
sys.path.append("./Utils")

from ..strategies_importer import *

from ..Utils.writing_utils import *
from ..Utils.format_conversion_utils import *
from ..Utils.common_utils import *

class Context():

    def __init__(self, strategy: Strategy) -> None:

        self._strategy = strategy

    @property
    def strategy(self) -> Strategy:

        return self._strategy

    @strategy.setter
    def strategy(self, strategy: Strategy) -> None:

        self._strategy = strategy

    def write_node(self, node, node_properties, shader_content) -> None:

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
            shader_content = process_property(input_socket, node_name, node_type, shader_content)

    strategy = node_type_strategy_map.get(node.type)
    context = Context(strategy=strategy)

    shader_content = context.write_node(node=node, node_properties=node_properties, shader_content=shader_content)

    return shader_content

def clean_material_name(name) : 
    """
    Removes non-alphanumeric characters and spaces from the material name.

    Args:
        name (str): The material name to clean.

    Returns:
        str: The cleaned material name.

    Raises:
        SystemExit: If the name contains only invalid symbols.
    """

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
    shader_content = write_include("HLSLTemplates/BSDF/principled_bsdf_includes.txt", shader_content)

    # Blending mode and culling mode
    get_common_values().blending_mode = material.blend_method
    
    # Add the culling mode here because it's not specific to a certain node
    # but rather a general material setting
    if material.use_backface_culling == False :
        shader_content= shader_content.replace("// Add culling", "Cull Off")
    
    if material.blend_method== 'CLIP' :
        get_common_values().cutoff = material.alpha_threshold
            
    node_tree = material.node_tree
    nodes = node_tree.nodes

    # Assume there is only one Material Output node
    root_node = nodes.get("Material Output")
    if (not root_node or not root_node.inputs['Surface'].is_linked) :
        raise SystemExit("You must use a Material Output node with something linked to its surface.")

    # Rename the shader
    shader_content = shader_content.replace("Custom/ColorShader", f"Custom/Shader{material_name}_")

    shader_filename = f"{material_name}.shader"
    
    shader_filepath = f"{destination_directory}/{shader_filename}"

    shader_content = iterate_node(root_node, shader_content)

    with open(shader_filepath, "w") as shader_file:
        shader_file.write(shader_content)

    print(f"{shader_filename} file successfully generated.")
    
    shader_guid = generate_meta_file('FileTemplates/template.shader.meta',destination_directory,material_name,'.shader')
    return material_name, get_common_values().imagesMap,shader_guid