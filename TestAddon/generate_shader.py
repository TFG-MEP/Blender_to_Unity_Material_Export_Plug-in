import bpy
from .strategies_importer import *
from .format_conversion_utils import *
from .writing_utils import *

imagesMap = {}

visited_nodes = set()

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
    global visited_nodes
    if (node_name in visited_nodes) :
        return shader_content
    else :
        visited_nodes.add(node_name)

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
        elif socket_name == 'Vector':
            parameter='i.worldPos'
            if node.type == 'TEX_IMAGE' :
                parameter='float3(i.uv,0)'
            fragment_index = shader_content.find("// Call methods")
            func_line = f'float3 {node_name + "_" + socket_name} = {parameter};\n\t\t\t\t'
            shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]
        else :
            # Create an entry for this property in the shader properties
            # print("Property of " + node_type + ": " + input_socket.name + " with type: " + input_socket.bl_label)
            shader_content = process_property(input_socket, node_name, node_type, shader_content)

    # TODO : quizás es mejor recorrer las salidas aquí

    context = Context(strategy=DefaultNode())

    if node.type == 'VALUE':
        context.strategy = ValueNode()
    elif node.type == 'RGB' : 
        context.strategy = RGBNode()
    elif node.type == 'BSDF_PRINCIPLED' :
        context.strategy = PrincipledBSDFNode()
    elif node.type == 'TEX_IMAGE' :
        context.strategy = ImageTextureNode()
    elif node.type == 'TEX_COORD' :
        context.strategy= TextureCoordinateNode()
    elif node.type=='MAPPING' :
        context.strategy = MappingNode()
    elif  node.type=='TEX_CHECKER':
        context.strategy = CheckerNode()

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


    # Reset global variables for future uses
    clear_global_variables()
    
    global visited_nodes
    visited_nodes = set()

    return material.name, imagesMap