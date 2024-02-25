from .strategy import Strategy
from ..writing_utils import *

class ValueNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        # Se buscan las propiedades específicas de este tipo de nodo...
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
        node_properties.append(node_name + "_Value")
        property_line = f'{node_name}_Value("Value", float) = {node.outputs["Value"].default_value}\n\t\t'
        # ... y se añaden al shader
        shader_content = write_property(property_line, shader_content)

        variable_line = f'float {node_name}_Value;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        # Se identifica el nodo conectado a la salida Value
        exit_connection = node.outputs["Value"].links[0]
        input_node = exit_connection.to_node
        # y la propiedad específica de dicho nodo que lo recibe
        input_property = exit_connection.to_socket
        #print("Value conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
        shader_content = write_node("HLSLTemplates/value.txt", node_properties, input_node, input_property, shader_content)
        return shader_content