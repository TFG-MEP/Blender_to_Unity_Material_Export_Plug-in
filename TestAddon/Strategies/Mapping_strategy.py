from .strategy import Strategy
from ..writing_utils import *

class MappingNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        # Se buscan las propiedades específicas de este tipo de nodo...
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        # Se identifica el nodo conectado a la salida RGB
        exit_connection = node.outputs["Vector"].links[0]
        input_node = exit_connection.to_node
        # y la propiedad específica de dicho nodo que lo recibe
        input_property = exit_connection.to_socket
        #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
        shader_content = write_node("HLSLTemplates/mapping.txt", node_properties, input_node, input_property, shader_content)

        return shader_content