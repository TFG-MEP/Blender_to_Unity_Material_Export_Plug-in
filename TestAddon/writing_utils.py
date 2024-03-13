import bpy
import re
from .format_conversion_utils import *
from .common_utils import *

def write_include(include_file_path, shader_content):
    """ Add an HLSL include 

    Args:
        include_file_path (str) :  Path where it contains the includes needed for the shader 
        shader_content (str) : Current template content
    Returns:
        str: Updated shader template with the HLSL method and its call.
    """
    with open(include_file_path, "r") as include_file:
     
        includes = re.findall(r'#include\s*"[^"]+"', include_file.read())

        #Clean every include and assure that ther are not two equal
        includes = [re.sub(r'\s+', ' ', include.strip().replace('\n', '')) for include in includes]
        includes = [include.replace(' ', '') for include in includes]
        for include in includes:
            if include not in get_common_values().added_includes:
                get_common_values().added_includes.add(include)
                include_index = shader_content.find("//Add includes ")
                shader_content = shader_content[:include_index] + include + "\n\t\t\t" + shader_content[include_index:]
        pragmas = re.findall(r'#pragma\s*"[^"]+"', include_file.read())

       #Clean every pragma and assure that ther are not two equal
        pragmas = [re.sub(r'\s+', ' ', define.strip().replace('\n', '')) for define in pragmas]
        pragmas = [pragma.replace(' ', '') for pragma in pragmas]
        for define in pragmas:
            if define not in get_common_values().added_includes:
                get_common_values().added_includes.add(define)
                pragma_index = shader_content.find("//Add includes ")
                shader_content = shader_content[:pragma_index] + define + "\n\t\t\t" + shader_content[pragma_index:]
    return shader_content
          
def write_function(function_file_path, shader_content) :

    """ Add an HLSL function to the shader template
    Args:
        function_file_path (str) :  Path to the file that contains the HLSL function
        shader_content (str) : Current template content
    Returns:
        str: Updated shader template with the HLSL method.
    """

    # Check if the HLSL function has already been added to the shader
    if function_file_path not in get_common_values().added_functions:

        # Read the file that contains the required HLSL function
        with open(function_file_path, "r") as node_func_file:
            node_function = node_func_file.read()

        # Add the function to the shader template
        methods_index = shader_content.find("// Add methods")
        shader_content = shader_content[:methods_index] + node_function + "\n\t\t\t" + shader_content[methods_index:]
        
        # Add the function to the written functions group
        get_common_values().added_functions.add(function_file_path)

    return shader_content

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

    shader_content = write_function(function_file_path, shader_content)

    prop_type = blender_type_to_hlsl(destination_property.bl_label)
    
    # Remove any possible blanks from the name
    destination_node = destination_node.name.replace(" ", "")
    destination_property = destination_property.identifier.replace(" ", "")

    # Name of the file minus extension (must be the same as the name of the hlsl function)
    function_name = function_file_path.rsplit('/', 1)[-1]
    dot_index = function_name.find('.')
    if dot_index != -1:
        function_name = function_name[:dot_index]

    # Get returned type from function name

    # If types are different, add call to conversion method

    

    # Add the function call to the shader template
    fragment_index = shader_content.find("// Call methods")
    destination_node = destination_node.replace(" ", "").replace(".", "")
    destination_name = destination_node + "_" + destination_property

    all_parameters = ', '.join(function_parameters)

    func_line = f'{prop_type} {destination_name} = {function_name}({all_parameters});\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    # Check when the MeterialOutput node has been added to ensure correct shaders
    if destination_name == 'MaterialOutput_Surface' :
        MaterialOutput_Surface_added = True

    return shader_content

def write_root( parameter, destination_node, destination_property, shader_content) : 

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

    prop_name = input_socket.identifier
    prop_label = input_socket.bl_label

    # Ignore specific properties or specific node types
    if node_type == 'OUTPUT_MATERIAL' : 
        return shader_content

    node_name = node_name.replace(" ", "")
    node_name = node_name.replace(".", "")
    prop_name = prop_name.replace(" ", "")
    prop_name = prop_name.replace(".", "")

    # Manage "Shader" properties
    if prop_label == 'Shader' : # These properties will be determined by another node
        name = f'float4 {node_name}_{prop_name}'
        value = " = float4(0.0, 0.0, 0.0, 1.0);"
        line = name + value
        shader_content = write_variable(line, shader_content)
        return shader_content

    # Convert from Blender types to Unity/HLSL
    prop_label_variable = blender_type_to_hlsl(prop_label)
    prop_label = blender_type_to_properties(prop_label)
    # Get the properties value
    prop_value = input_socket.default_value
    
    # TODO : operaciones con el valor si es necesario: normalizar, convertir a valores que entienda el shader, etc.
    prop_value = blender_value_to_hlsl(prop_value, input_socket.bl_label)

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

def write_tags(tag_file_path, shader_content) : 
    """
    Adds a line to the shader templates tags section
    """
 
    with open(tag_file_path, "r") as tag_file:
        tags = re.findall(r'Tags\{\s*"[^"]*"\s*=\s*"[^"]*"\s*\}', tag_file.read())
        
        for tag in tags:
            if tag not in get_common_values().added_tags:
                get_common_values().added_tags.add(tag)
                tags_index = shader_content.find("// Add tags")
                shader_content = shader_content[:tags_index] + tag + "\n\t\t" + shader_content[tags_index:]
        
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

def write_struct(struct_file_path, shader_content) :

    struct_index = shader_content.find("// Add structs")
    with open(struct_file_path, "r") as struct_file:
        struct = struct_file.read()

    # TODO : revisar tabulación
    shader_content = shader_content[:struct_index] + struct + "\n\t\t\t" + shader_content[struct_index:]
    return shader_content

def write_struct_node(node_name, struct_name, function_name, function_parameters, shader_content) : 

    fragment_index = shader_content.find("// Call methods")

    func_line = f'{struct_name} {node_name} = {function_name}({function_parameters});\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]

    return shader_content

def write_struct_property(struct_name, struct_property, struct_property_type, input_node, input_property, shader_content) :

    fragment_index = shader_content.find("// Call methods")
    destination_node = input_node.name.replace(" ", "").replace(".", "")
    destination_name = destination_node + "_" + input_property.identifier

    line = f'{struct_property_type} {destination_name} = {struct_name}.{struct_property};\n\t\t\t\t'
    shader_content = shader_content[:fragment_index] + line + shader_content[fragment_index:]

    return shader_content