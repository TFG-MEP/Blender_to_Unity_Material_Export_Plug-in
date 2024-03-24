from .strategy import Strategy
from ..writing_utils import *

class AddShaderNode(Strategy) :
    def write_node(self, node, node_properties, shader_content) :
        node_name = node.name.replace(" ", "")
        node_name = node_name.replace(".", "")

        shader_content = write_struct("HLSLTemplates/Add_Shader/struct.txt", shader_content)
        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/Add_Shader/add_shader.txt", shader_content)
        
        # Add the function call to the shader template
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "Add_shader", "add_shader", all_parameters, shader_content)
        
        for link in node.outputs["Shader"].links :
            input_node = link.to_node
            input_property = link.to_socket

            shader_content = write_struct_property(node_name, "Shader", "float4", input_node, input_property, shader_content)

        return shader_content



