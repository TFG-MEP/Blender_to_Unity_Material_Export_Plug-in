from .strategy import Strategy
from ..writing_utils import *

class ValueNode(Strategy):

    def add_custom_properties(self, node, node_properties, shader_content):
        
        node_name = self.node_name(node)

        node_properties.append(node_name + "_Value")
        property_line = f'{node_name}_Value("Value", float) = {node.outputs["Value"].default_value}\n\t\t'

        shader_content = write_property(property_line, shader_content)

        variable_line = f'float {node_name}_Value;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        shader_content = write_struct("HLSLTemplates/Value/struct.txt", shader_content)

        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(self.node_name(node), "Value", "value", all_parameters, shader_content)

        return shader_content
   
    def add_function(self, node, node_properties, shader_content):
        shader_content = write_function("HLSLTemplates/Value/value.txt", shader_content)
        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        
        for exit_connection in node.outputs["Value"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Value", "float", input_node, input_property, shader_content)

        return shader_content

