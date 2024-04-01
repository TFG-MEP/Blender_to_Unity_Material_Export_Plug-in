from .strategy import Strategy
from ..writing_utils import *

class PrincipledBSDFNode(Strategy):

    function_path = "HLSLTemplates/BSDF/principled_bsdf.txt"
    alpha_blend_function_path = "HLSLTemplates/BSDF/principled_bsdf_alpha.txt"
    alpha_clip_function_path = "HLSLTemplates/BSDF/principled_bsdf_alpha_clip.txt"
    struct_path = "HLSLTemplates/BSDF/struct.txt"

    def add_custom_properties(self, node, node_properties, shader_content):

        node_properties.insert(0, 'i')

        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        node_name = node.name.replace(".", "_")
        node_name = node_name.replace(" ", "_") #Caso único para el nodo principled bsdf

        shader_content = write_struct(self.struct_path, shader_content)
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "BSDF", "principled_bsdf", all_parameters, shader_content)

        return shader_content
       
    def add_function(self, node, node_properties, shader_content):
        #self.add_alpha_property(node,self.function_path,shader_content)

        #TODO: metodo que adapte el shader content segun la transparencia/mover de sitio 
        if get_common_values().blending_mode == 'BLEND':
            if node.inputs['Alpha'].default_value < 1:
                self.function_path = self.alpha_blend_function_path
                shader_content=write_tags("HLSLTemplates/BSDF/principled_bsdf_tags.txt", shader_content)
                shader_content=write_pass_properties("HLSLTemplates/BSDF/alpha_pass_properties.txt", shader_content)

        #else if get_common_values().blending_mode == 'CLIP':
            
                
        shader_content = write_function(self.function_path, shader_content)
        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = node.name.replace(".", "_")
        node_name = node_name.replace(" ", "_") #Caso único para el nodo principled bsdf
        
        for link in node.outputs["BSDF"].links :

            input_node = link.to_node
            input_property = link.to_socket

            shader_content = write_struct_property(node_name, "BSDF_output", "float4", input_node, input_property, shader_content)
        return shader_content
    
        
    