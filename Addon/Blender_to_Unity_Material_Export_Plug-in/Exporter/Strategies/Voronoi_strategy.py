from .strategy import Strategy
from ..writing_utils import *

class VaronoiNode(Strategy):

    function_path = "HLSLTemplates/Voronoi/"
    external_function_path="HLSLTemplates/Voronoi/External_functions/"
    struct_path = "HLSLTemplates/Voronoi/struct.txt"
    defines_path = "HLSLTemplates/Voronoi/voronoi_defines.txt"
    function_name="voronoi_f1_3D_fuction"
    def add_defines(self, node, node_properties, shader_content):
        shader_content = write_defines(self.defines_path, shader_content)
        return shader_content
    
    def add_function(self, node, node_properties, shader_content):
        functions3D = ["hash_uint4","hash_uint3","hashnoisef3", "hashnoisef4", "hash_vector4_to_float",
                       "hash_vector3_to_float","hash_vector3_to_color","hash_vector3_to_vector3"]

        for function in functions3D:
             shader_content = write_function(self.external_function_path+""+function+".txt", shader_content)
        shader_content = write_function(self.function_path+""+"voronoi_f1_3D_function.txt", shader_content)
        return shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        shader_content = write_struct(self.struct_path, shader_content)

        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(self.node_name(node), "Voronoi_texture",self.function_name, all_parameters, shader_content)
        return shader_content
   
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)        
        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)

        return shader_content

