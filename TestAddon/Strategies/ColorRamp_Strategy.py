from .strategy import Strategy
from ..writing_utils import *

class ColorRampNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            color_ramp = node.color_ramp
            positions = [color.position for color in color_ramp.elements]
            colors = [ blender_value_to_hlsl(color.color, 'Color') for color in color_ramp.elements]
            colors_rgb = [(color[0], color[1], color[2]) for color in colors]
            property_line = f'{node_name}_Size("Int", Size) = {colors.len()}\n\t\t'
            shader_content = write_property(property_line, shader_content)

            variable_line = f'int {node_name}_Size;\n\t\t\t'
            shader_content = write_variable(variable_line, shader_content)
            for i in range(colors.len()):
                property_line = f'{node_name}_Color{i}("Color", Color{i}) = {colors[i]}\n\t\t'
                shader_content = write_property(property_line, shader_content)
                variable_line = f'float4 {node_name}_Color{i};\n\t\t\t'
                shader_content = write_variable(variable_line, shader_content)

           
            print("Colors (RGB):", colors_rgb)
            print("Colors :", colors)
            # blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")
            # Imprimir las posiciones y los colores
            print("Positions:", positions)
            ##shader_content = write_node("HLSLTemplates/color_ramp.txt", node_properties, input_node, input_property, shader_content)

        return shader_content