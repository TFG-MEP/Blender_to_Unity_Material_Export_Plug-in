from .strategy import Strategy
from ..writing_utils import *

class MappingNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        # Add the struct
        shader_content = write_struct("HLSLTemplates/Mapping/struct.txt", shader_content)

        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/Mapping/mapping.txt", shader_content)
        
        # Add the function call to the shader template
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "Mapping", "mapping", all_parameters, shader_content)

        for link in node.outputs["Vector"].links :
            input_node = link.to_node

            input_property = link.to_socket
            
            shader_content = write_struct_property(node_name, "Vector", "float3", input_node, input_property, shader_content)
            #shader_content = write_node("HLSLTemplates/mapping.txt", node_properties, input_node, input_property, shader_content)

        return shader_content