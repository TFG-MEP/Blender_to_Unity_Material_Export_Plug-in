from .strategy import Strategy
from ..writing_utils import *

class RGBNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        # Se buscan las propiedades específicas de este tipo de nodo...
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        node_properties.append(node_name + "_Color")

        node_color = blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")

        property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'
        # ... y se añaden al shader
        shader_content = write_property(property_line, shader_content)

        variable_line = f'float4 {node_name}_Color;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        # Se identifica el nodo conectado a la salida RGB
        exit_connection = node.outputs["Color"].links[0]
        input_node = exit_connection.to_node
        # y la propiedad específica de dicho nodo que lo recibe
        input_property = exit_connection.to_socket
        #print("RGB conecta con " + nodo_entrada.name + " en su propiedad " + propiedad_entrada.name)
        shader_content = write_node("HLSLTemplates/rgb.txt", node_properties, input_node, input_property, shader_content)

        return shader_content