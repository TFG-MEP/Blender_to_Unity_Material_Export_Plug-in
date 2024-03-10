from .strategy import Strategy
from ..writing_utils import *

class CheckerNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
        
            shader_content = write_node("HLSLTemplates/color_ramp.txt", node_properties, input_node, input_property, shader_content)

        return shader_content