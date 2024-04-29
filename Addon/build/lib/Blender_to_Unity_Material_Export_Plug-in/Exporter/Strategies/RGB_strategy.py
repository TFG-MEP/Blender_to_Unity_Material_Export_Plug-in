from .strategy import Strategy
from ..writing_utils import *

class RGBNode(Strategy):

    function_path = "HLSLTemplates/RGB/rgb.txt"
    function_name = "rgb"

    def add_custom_properties(self, node, node_properties, shader_content):
        node_name = self.node_name(node)

        node_properties.append(node_name + "_Color")

        node_color = blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")

        property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'

        shader_content = write_property(property_line, shader_content)

        variable_line = f'float4 {node_name}_Color;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        return node_properties, shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)

        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)

        return shader_content
