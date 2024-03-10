from .strategy import Strategy
from ..writing_utils import *

class NormalMapNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        for link in node.outputs["Normal"].links :
            input_node = link.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = link.to_socket
            shader_content = write_node("HLSLTemplates/normal_map.txt", node_properties, input_node, input_property, shader_content)

        return shader_content