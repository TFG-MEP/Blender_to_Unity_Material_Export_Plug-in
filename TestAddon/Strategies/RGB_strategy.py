from .strategy import Strategy
from ..writing_utils import *

class RGBNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        node_properties.append(node_name + "_Color")

        node_color = blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")

        property_line = f'{node_name}_Color("Color", Color) = {node_color}\n\t\t'

        shader_content = write_property(property_line, shader_content)

        variable_line = f'float4 {node_name}_Color;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        for link in node.outputs["Color"].links :
            input_node = link.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = link.to_socket
            shader_content = write_node("HLSLTemplates/rgb.txt", node_properties, input_node, input_property, shader_content)

        return shader_content