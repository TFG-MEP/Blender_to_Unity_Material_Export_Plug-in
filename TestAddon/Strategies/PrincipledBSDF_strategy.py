from .strategy import Strategy
from ..writing_utils import *

class PrincipledBSDFNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        node_name=node.name.replace(".", "")
        exit_connection = node.outputs["BSDF"].links[0]
        input_node = exit_connection.to_node
        input_property = exit_connection.to_socket
        node_properties.insert(0, 'i')
        shader_content = write_node("HLSLTemplates/principled_bsdf.txt", node_properties, input_node , input_property, shader_content)

        return shader_content