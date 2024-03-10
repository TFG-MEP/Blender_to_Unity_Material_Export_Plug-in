from .strategy import Strategy
from ..writing_utils import *


class ColorRampNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        MAX_COLORS=32
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")

        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            color_ramp = node.color_ramp
            positions = [color.position for color in color_ramp.elements]
            colors = [ blender_value_to_hlsl(color.color, 'Color') for color in color_ramp.elements]
    
            # property_line = f'{node_name}_Size("Int", Size) = {len(colors)}\n\t\t'
            # shader_content = write_property(property_line, shader_content)

            variable_line = f'int {node_name}_Size={len(colors)};\n\t\t\t'
            shader_content = write_variable(variable_line, shader_content)
            node_properties.append(node_name + "_Size")

            ##Create the arrays 
            fragment_index = shader_content.find("// Call methods")
            color_line = f'float4 {node_name}_ramp[30];\n\t\t\t\t'
            shader_content = shader_content[:fragment_index] + color_line + shader_content[fragment_index:]
            node_properties.append(node_name + "_ramp")
            pos_line = f'float {node_name}_pos[30];\n\t\t\t\t'
            shader_content = shader_content[:fragment_index] + pos_line + shader_content[fragment_index:]
            node_properties.append(node_name + "_pos")

            for i in range(len(colors)):
                property_line = f'{node_name}_Color{i}("{node_name}_Color{i}", Color{i}) = {colors[i]}\n\t\t'
                shader_content = write_property(property_line, shader_content)
                variable_line = f'float4 {node_name}_Color{i};\n\t\t\t'
                shader_content = write_variable(variable_line, shader_content)
                color_line = f'{node_name}_ramp[{i}]=float4{colors[i]};\n\t\t\t\t'
                fragment_index = shader_content.find("// Call methods")
                shader_content = shader_content[:fragment_index] + color_line + shader_content[fragment_index:]

                property_line = f'{node_name}_Pos{i}("{node_name}_Pos{i}", Float) = {positions[i]}\n\t\t'
                shader_content = write_property(property_line, shader_content)
                variable_line = f'float {node_name}_Pos{i};\n\t\t\t'
                shader_content = write_variable(variable_line, shader_content)
                pos_line = f'{node_name}_pos[{i}]={positions[i]};\n\t\t\t\t'
                fragment_index = shader_content.find("// Call methods")
                shader_content = shader_content[:fragment_index] + pos_line + shader_content[fragment_index:]

           

            print("Colors :", colors)
            # blender_value_to_hlsl(node.outputs["Color"].default_value, "Color")
            # Imprimir las posiciones y los colores
            print("Positions:", positions)
            shader_content = write_node("HLSLTemplates/color_ramp.txt", node_properties, input_node, input_property, shader_content)

        return shader_content