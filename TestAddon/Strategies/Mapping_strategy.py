from .strategy import Strategy
from ..writing_utils import *

class MappingNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        for link in node.outputs["Vector"].links :
            input_node = link.to_node

            input_property = link.to_socket
            
            shader_content = write_node("HLSLTemplates/mapping.txt", node_properties, input_node, input_property, shader_content)

        return shader_content