from .strategy import Strategy
from ..writing_utils import *

class ValueNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        node_properties.append(node_name + "_Value")
        property_line = f'{node_name}_Value("Value", float) = {node.outputs["Value"].default_value}\n\t\t'

        shader_content = write_property(property_line, shader_content)

        variable_line = f'float {node_name}_Value;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)
        
        for exit_connection in node.outputs["Value"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_node("HLSLTemplates/value.txt", node_properties, input_node, input_property, shader_content)

        return shader_content