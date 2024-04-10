from .strategy import Strategy
from ..writing_utils import *

class NormalMapNode(Strategy):

    function_path = "HLSLTemplates/Normal_Map/normal_map.txt"
    function_name = "normal_map"

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        
        for link in node.outputs["Normal"].links :
            input_node = link.to_node
            # la propiedad específica del nodo que lo recibe
            input_property = link.to_socket
            shader_content = write_struct_property(node_name, "Normal", "float3", input_node, input_property, shader_content)

        return shader_content