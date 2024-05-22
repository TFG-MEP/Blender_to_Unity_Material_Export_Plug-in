from .strategy import Strategy
from ..Utils.writing_utils import *

class VaronoiNode(Strategy):

    function_path = "HLSLTemplates/Voronoi/"
    external_function_path="HLSLTemplates/Voronoi/External_functions/"
    struct_path = "HLSLTemplates/Voronoi/struct.txt"
    defines_path = "HLSLTemplates/Voronoi/voronoi_defines.txt"
    function_name="voronoi_f1_3D_function"
    def add_custom_properties(self, node, node_properties, shader_content):
        voronoi_distance=node.distance
      
        voronoi_distance_mapping = {
            'EUCLIDEAN': 0,
            'MANHATTAN': 1,
            'CHEBYCHEV': 2,
            'MINKOWSKI': 3
        }
        id_distance = voronoi_distance_mapping.get(voronoi_distance, -1)
        node_properties.append(str(id_distance))
        return node_properties, shader_content
    def add_defines(self, node, node_properties, shader_content):
        shader_content = write_defines(self.defines_path, shader_content)
        return shader_content
    
    def add_function(self, node, node_properties, shader_content):
    
        #functions for 3D
        functions=[]      
        voronoi_dimensions=node.voronoi_dimensions
        voronoi_feature=node.feature
        
        if voronoi_dimensions=='3D':
             functions = ["hash_uint4","hash_uint3","hashnoisef3", "hashnoisef4", "hash_vector4_to_float",
                       "hash_vector3_to_float","hash_vector3_to_color","hash_vector3_to_vector3","voronoi_distance_f3"]
        elif voronoi_dimensions=='2D':
            functions = ["hash_uint2","hash_uint3","hashnoisef3", "hashnoisef2", "hash_vector2_to_float",
                       "hash_vector3_to_float","hash_vector2_to_color","hash_vector2_to_vector2","voronoi_distance_f2"]
        
        for function in functions:
             shader_content = write_function(self.external_function_path+""+function+".txt", shader_content)
        self.function_name="voronoi_"+voronoi_dimensions+"_"+voronoi_feature+"_function"
        shader_content = write_function(self.function_path+ self.function_name+".txt", shader_content)
        return shader_content
    
    # def add_struct(self, node, node_properties, shader_content):
    #     shader_content = write_struct(self.struct_path, shader_content)

    #     all_parameters = ', '.join(node_properties)
    #     shader_content = write_struct_node(self.node_name(node), "Voronoi_Texture_struct",self.function_name, all_parameters, shader_content)
    #     return shader_content
   
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)        
        for exit_connection in node.outputs["Color"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)
        for exit_connection in node.outputs["Position"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Position", "float3", input_node, input_property, shader_content)
        for exit_connection in node.outputs["Distance"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket
            shader_content = write_struct_property(node_name, "Distance", "float", input_node, input_property, shader_content)
        return shader_content

