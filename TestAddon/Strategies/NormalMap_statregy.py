from .strategy import Strategy
from ..writing_utils import *

class NormalMapNode(Strategy):

    function_path = "HLSLTemplates/Normal_Map/normal_map.txt"
    struct_path = "HLSLTemplates/Normal_Map/struct.txt"

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        shader_content = write_struct(struct_path, shader_content)
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(self.node_name(node), "Normal_map", "normal_map", all_parameters, shader_content)

        return shader_content
   
    def add_function(self, node, node_properties, shader_content):
        shader_content = write_function(function_path, shader_content)
        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        
        for link in node.outputs["Normal"].links :
            input_node = link.to_node
            # la propiedad específica del nodo que lo recibe
            input_property = link.to_socket
            shader_content = write_struct_property(node_name, "Normal", "float3", input_node, input_property, shader_content)

        return shader_content