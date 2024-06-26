from .strategy import Strategy
from ..Utils.writing_utils import *


class ColorRampNode(Strategy):

    function_path = "HLSLTemplates/Color_Ramp/color_ramp.txt"
    function_name = "color_ramp"
    struct_path = "HLSLTemplates/Color_Ramp/struct.txt"

    def add_custom_properties(self, node, node_properties, shader_content):
        MAX_COLORS=32
        node_name = self.node_name(node)
     
        color_ramp = node.color_ramp
        positions = [color.position for color in color_ramp.elements]
        colors = [ blender_value_to_hlsl(color.color, 'Color') for color in color_ramp.elements]
        node_properties.append( str(len(colors)))

        type_interpolation = color_ramp.interpolation
        interpolation=-1
        if type_interpolation == 'LINEAR':
            interpolation=1
        elif type_interpolation == 'CONSTANT':
            interpolation=0
        node_properties.append(str(interpolation))

        ##Create the arrays 
        fragment_index = shader_content.find("// Call methods")
        color_line = f'float4 {node_name}_ramp[30];\n\t\t\t\t'
        shader_content = shader_content[:fragment_index] + color_line + shader_content[fragment_index:]
        node_properties.append(node_name + "_ramp")
        pos_line = f'float {node_name}_pos[30];\n\t\t\t\t'
        shader_content = shader_content[:fragment_index] + pos_line + shader_content[fragment_index:]
        node_properties.append(node_name + "_pos")

        for i in range(len(colors)):
            property_line = f'{node_name}_Color{i}("{node_name}_Color{i}", Color) = {colors[i]}\n\t\t'
            shader_content = write_property(property_line, shader_content)
            variable_line = f'float4 {node_name}_Color{i};\n\t\t\t'
            shader_content = write_variable(variable_line, shader_content)
            color_line = f'{node_name}_ramp[{i}]={node_name}_Color{i};\n\t\t\t\t'
            fragment_index = shader_content.find("// Call methods")
            shader_content = shader_content[:fragment_index] + color_line + shader_content[fragment_index:]

            property_line = f'{node_name}_Pos{i}("{node_name}_Pos{i}", Float) = {positions[i]}\n\t\t'
            shader_content = write_property(property_line, shader_content)
            variable_line = f'float {node_name}_Pos{i};\n\t\t\t'
            shader_content = write_variable(variable_line, shader_content)
            pos_line = f'{node_name}_pos[{i}]={node_name}_Pos{i};\n\t\t\t\t'
            fragment_index = shader_content.find("// Call methods")
            shader_content = shader_content[:fragment_index] + pos_line + shader_content[fragment_index:]
        
        return node_properties, shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :

        node_name = self.node_name(node)
        
        for exit_connection in node.outputs["Color"].links  :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)

        for exit_connection in node.outputs["Alpha"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Alpha", "float", input_node, input_property, shader_content)
           
        return shader_content