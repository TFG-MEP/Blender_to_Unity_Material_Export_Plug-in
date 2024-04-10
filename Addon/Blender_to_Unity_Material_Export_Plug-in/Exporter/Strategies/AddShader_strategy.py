from .strategy import Strategy
from ..writing_utils import *

class AddShaderNode(Strategy) :

    function_path = "HLSLTemplates/Add_Shader/add_shader.txt"
    function_name = "add_shader"

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content

    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        
        for link in node.outputs["Shader"].links :
            input_node = link.to_node
            input_property = link.to_socket

            shader_content = write_struct_property(node_name, "Shader", "float4", input_node, input_property, shader_content)

        return shader_content



