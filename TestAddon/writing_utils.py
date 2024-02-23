import bpy
from .format_conversion_utils import *

added_functions = set()
MaterialOutput_Surface_added = False

def clear_global_variables() : 

    global added_functions
    global MaterialOutput_Surface_added

    added_functions = set()
    MaterialOutput_Surface_added = False

def get_MaterialOutput_Surface_added() : 
    return MaterialOutput_Surface_added

def write_node(function_file_path, function_parameters, destination_node, destination_property, shader_content) : 

    """ Add an HLSL function and its respective call to the shader template

    Args:
        function_file_path (str) :  Path to the file that contains the HLSL function
        function_parameters (list) : List of function call parameters
        destination_node (bpy.types.Node) : Target node to which the output of the current node will connect.
        destination_property (bpy.types.NodeSocket) : Target property to which the output of the current node will connect.
        shader_content (str) : Current template content

    Returns:
        str: Updated shader template with the HLSL method and its call.
    """
    global added_functions
    global MaterialOutput_Surface_added

    # Check if the HLSL function has already been added to the shader
    if function_file_path not in added_functions:

        # Read the file that contains the required HLSL function
        with open(function_file_path, "r") as node_func_file:
            node_function = node_func_file.read()

        # Add the function to the shader template
        methods_index = shader_content.find("// Add methods")
        shader_content = shader_content[:methods_index] + node_function + "\n\t\t\t" + shader_content[methods_index:]

        # Add the function to the written functions group
        added_functions.add(function_file_path)

    prop_type = blender_type_to_hlsl(destination_property.bl_label)
    # Remove any possible blanks from the name
    destination_node = destination_node.name.replace(" ", "")
    destination_property = destination_property.name.replace(" ", "")
    # Name of the file minus extension (must be the same as the name of the hlsl function)
    dot_index = function_file_path.find('.')
    slash_index = function_file_path.find('/')
    function_name = function_file_path[slash_index+1:dot_index]

    # Add the function call to the shader template
    fragment_index = shader_content.find("// Call methods")
    destination_node = destination_node.replace(" ", "").replace(".", "")
    destination_name = destination_node + "_" + destination_property

    all_parameters = ', '.join(function_parameters)

    func_line = f'{prop_type} {destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    #func_line = f'{destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    # Check when the MeterialOutput node has been added to ensure correct shaders
    if destination_name == 'MaterialOutput_Surface' :
        MaterialOutput_Surface_added = True

    return shader_content

def write_root( parameter, destination_node, destination_property, shader_content) : 

    global MaterialOutput_Surface_added

    prop_type = blender_type_to_hlsl(destination_property.bl_label)
    
    destination_node = destination_node.name.replace(" ", "")
    destination_property = destination_property.name.replace(" ", "")

    fragment_index = shader_content.find("// Call methods")
    destination_node=destination_node.replace(" ", "").replace(".", "")

    destination_name = destination_node + "_" + destination_property
    func_line = f'{prop_type} {destination_name} = {parameter};\n\t\t\t\t'

    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    if destination_name == 'MaterialOutput_Surface' :
        MaterialOutput_Surface_added = True

    return shader_content

def process_property(input_socket, node_name, node_type, shader_content): 
    """ Processes a blender nodes property and adds it to the shader template in the correct format.
    Args:
        input_socket (bpy.types.NodeSocket) : Property to process.
        node_name (str) : name of the node
        node_type (str) : blender type of the node
        shader_content (str) : Shader template content

    Returns:
        str: Updated shader template with the processed property
    """

    prop_name = input_socket.name
    prop_label = input_socket.bl_label

    # Ignore "Shader" properties
    if prop_label == 'Shader' : # These properties will be determined by another node
        return shader_content

    # Ignore specific properties or specific node types
    if node_type == 'OUTPUT_MATERIAL' : 
        return shader_content

    # Convert from Blender types to Unity/HLSL
    prop_label_variable = blender_type_to_hlsl(prop_label)
    prop_label = blender_type_to_properties(prop_label)
    # Get the properties value
    prop_value = input_socket.default_value

    # TODO : operaciones con el valor si es necesario: normalizar, convertir a valores que entienda el shader, etc.
    prop_value = blender_value_to_hlsl(prop_value, input_socket.bl_label)

    node_name = node_name.replace(" ", "")
    node_name = node_name.replace(".", "")
    prop_name = prop_name.replace(" ", "")
    prop_name = prop_name.replace(".", "")

    # Add property to template
    property_line = f'{node_name}_{prop_name}("{prop_name}", {prop_label}) = {prop_value}\n\t\t'
    shader_content = write_property(property_line, shader_content)

    variable_line = f'{prop_label_variable} {node_name}_{prop_name};\n\t\t\t'
    shader_content = write_variable(variable_line, shader_content)

    return shader_content


def write_property(line, shader_content) : 
    """
    Adds a line to the shader templates properties section

    Args:
        line (str) : line that contains the property that must be written
        shader_content (str) : current shader template content

    Returns:
        str: Updated shader template with the written property
    """
    properties_index = shader_content.find("// Add properties")
    shader_content = shader_content[:properties_index] + line + shader_content[properties_index:]

    return shader_content

def write_variable(line, shader_content) : 
    """
    Adds a line to the shader templates variables section

    Args:
        line (str) : line that contains the variable that must be written
        shader_content (str) : current shader template content

    Returns:
        str: Updated shader template with the written variable
    """
    variables_index = shader_content.find("// Add variables")
    shader_content = shader_content[:variables_index] + line + shader_content[variables_index:]

    return shader_content

def assign_variable(line, shader_content) : 

    variables_index = shader_content.find("//Equal Variables")
    shader_content = shader_content[:variables_index] + line + shader_content[variables_index:]

    return shader_content
