from .strategy import Strategy
from ..writing_utils import *

class CheckerNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
         ## add struct 
        struct_index = shader_content.find("// Add structs")
        with open("HLSLTemplates/Checker/struct.txt", "r") as struct_file:
            struct = struct_file.read()
        shader_content = shader_content[:struct_index] + struct + "\n\t\t\t" + shader_content[struct_index:]

        # Add the function to the shader template,METER MAPP
        with open("HLSLTemplates/Checker/checker.txt", "r") as node_func_file:
            node_function = node_func_file.read()
        methods_index = shader_content.find("// Add methods")
        shader_content = shader_content[:methods_index] + node_function + "\n\t\t\t" + shader_content[methods_index:]
        

         # Add the function call to the shader template
        fragment_index = shader_content.find("// Call methods")
        all_parameters = ', '.join(node_properties)

        func_line = f'Checker {node_name} = checker({all_parameters});\n\t\t\t\t'
        shader_content = shader_content[:fragment_index] + func_line + shader_content[fragment_index:]
        
        for exit_connection in node.outputs["Color"].links  :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            fragment_index = shader_content.find("// Call methods")
            destination_node = input_node.name.replace(" ", "").replace(".", "")
            destination_name = destination_node + "_" + input_property.identifier
            line = f'float4 {destination_name} = {node_name}.Color;\n\t\t\t\t'
            shader_content = shader_content[:fragment_index] + line + shader_content[fragment_index:]
        return shader_content