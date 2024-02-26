from .strategy import Strategy
from ..writing_utils import *

class TextureCoordinateNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        # Se buscan las propiedades específicas de este tipo de nodo...
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
        parameter=''
        # Verificar si el nodo UV está conectado
        if node.outputs.get('UV').is_linked:
            print("El nodo UV de Texture Coordinate está conectado a otro nodo.")
            exit_connection = node.outputs["UV"].links[0]
            parameter='float3(i.uv,0)'
        elif node.outputs.get('Object').is_linked:
            print("El nodo UV de Texture Coordinate no está conectado a otro nodo.")
            exit_connection = node.outputs["Object"].links[0]
        elif node.outputs.get('Generated').is_linked:
            print("El nodo UV de Texture Coordinate no está conectado a otro nodo.")
            exit_connection = node.outputs["Generated"].links[0]
            parameter='i.worldPos'

        # Se identifica el nodo conectado a la salida RGB

        input_node = exit_connection.to_node
        # y la propiedad específica de dicho nodo que lo recibe
        input_property = exit_connection.to_socket
        #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
        shader_content = write_root(parameter, input_node, input_property, shader_content)

        return shader_content