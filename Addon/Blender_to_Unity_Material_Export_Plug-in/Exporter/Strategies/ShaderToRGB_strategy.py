from .strategy import Strategy
from ..Utils.writing_utils import *

class ShaderToRgbNode(Strategy):

    function_path = "HLSLTemplates/Shader_to_RGB/Shader_to_RGB.txt"
    function_name = "shader_to_RGB"

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)

        for exit_connection in node.outputs["Color"].links  :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)

        for exit_connection in node.outputs["Alpha"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Alpha", "float", input_node, input_property, shader_content)
           

        return shader_content