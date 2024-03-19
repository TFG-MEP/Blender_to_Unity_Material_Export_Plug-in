from .strategy import Strategy
from ..writing_utils import *

class NormalMapNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
        shader_content = write_struct("HLSLTemplates/Normal_Map/struct.txt", shader_content)

        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/Normal_Map/normal_map.txt", shader_content)
        
        # Add the function call to the shader template
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "Normal_map", "normal_map", all_parameters, shader_content)
        
        for link in node.outputs["Normal"].links :
            input_node = link.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = link.to_socket
            shader_content = write_struct_property(node_name, "Normal", "float3", input_node, input_property, shader_content)

        return shader_content