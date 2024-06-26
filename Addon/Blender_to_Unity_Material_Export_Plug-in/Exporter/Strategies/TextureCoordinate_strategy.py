from .strategy import Strategy
from ..Utils.writing_utils import *

class TextureCoordinateNode(Strategy):

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        return shader_content
   
    def add_function(self, node, node_properties, shader_content):
        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        parameter=''

        # Check if the UV node is connected
        if node.outputs.get('UV').is_linked:
            parameter='float3(i.uv,0)'
            exit_connections = node.outputs["UV"].links

        elif node.outputs.get('Object').is_linked:         
            exit_connections = node.outputs["Object"].links

        elif node.outputs.get('Generated').is_linked:            
            exit_connections = node.outputs["Generated"].links
            parameter='(i.worldPos - _BoundingBoxMin) /( _BoundingBoxMax - _BoundingBoxMin);'
        elif node.outputs.get('Normal').is_linked:          
            exit_connections = node.outputs["Normal"].links
            parameter='normalize(i.normalOS);'

        for exit_connection in exit_connections :
        
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_root(parameter, input_node, input_property, shader_content)

        return shader_content

