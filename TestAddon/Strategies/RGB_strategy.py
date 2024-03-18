from .strategy import Strategy
from ..writing_utils import *

class RGBNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        node_properties.append(node_name + "_Color")

        node_color = blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")

        property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'

        shader_content = write_property(property_line, shader_content)

        variable_line = f'float4 {node_name}_Color;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        # Add the struct (TODO : llevar la cuenta de structs ya añadidos)
        shader_content = write_struct("HLSLTemplates/RGB/struct.txt", shader_content)

        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/RGB/rgb.txt", shader_content)

        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "RGB_output", "rgb", all_parameters, shader_content)
        
        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Color", "float4", input_node, input_property, shader_content)

        return shader_content
    