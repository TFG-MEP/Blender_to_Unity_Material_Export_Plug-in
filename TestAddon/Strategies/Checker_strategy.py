from .strategy import Strategy
from ..writing_utils import *

class CheckerNode(Strategy):
    def write_node(self, node, node_properties, shader_content):

        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
      
        # Add the struct (TODO : llevar la cuenta de structs ya añadidos)
        shader_content = write_struct("HLSLTemplates/Checker/struct.txt", shader_content)

        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/Checker/checker.txt", shader_content)

        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "Checker", "checker", all_parameters, shader_content)  
        
        for exit_connection in node.outputs["Color"].links  :
            input_node = exit_connection.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Color", "float4", input_node, input_property, shader_content)
        
        #TODO: Tener en cuenta el parámetro Fac-> Aun no hay nodos que permitan comprobar el funcionamiento de esto
        for exit_connection in node.outputs["Fac"].links :
            input_node = exit_connection.to_node
            # y la propiedad específica de dicho nodo que lo recibe
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Fac", "float", input_node, input_property, shader_content)
        return shader_content