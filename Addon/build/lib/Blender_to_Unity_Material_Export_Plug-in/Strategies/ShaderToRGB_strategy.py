from .strategy import Strategy
from ..writing_utils import *

class ShaderToRgbNode(Strategy):

    function_path = "HLSLTemplates/Shader_to_RGB/shader_to_RGB.txt"
    struct_path = "HLSLTemplates/Shader_to_RGB/struct.txt"

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        shader_content = write_struct(self.struct_path, shader_content)
        
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(self.node_name(node), "Shader_to_RGB", "shader_to_RGB", all_parameters, shader_content)

        return shader_content
   
    def add_function(self, node, node_properties, shader_content):
        shader_content = write_function(self.function_path, shader_content)
        return shader_content
    
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