from .strategy import Strategy
from ..Utils.writing_utils import *

class PrincipledBSDFNode(Strategy):

    function_path = "HLSLTemplates/BSDF/principled_bsdf.txt"
    function_name = "principled_bsdf"
    alpha_blend_function_path = "HLSLTemplates/BSDF/principled_bsdf_alpha.txt"
    alpha_clip_function_path = "HLSLTemplates/BSDF/principled_bsdf_alpha_clip.txt"

    def add_custom_properties(self, node, node_properties, shader_content):

        node_properties.insert(0, 'i')
        return node_properties, shader_content
       
    def add_function(self, node, node_properties, shader_content):
        #self.add_alpha_property(node,self.function_path,shader_content)

        #TODO: metodo que adapte el shader content segun la transparencia/mover de sitio 
        if get_common_values().blending_mode != 'OPAQUE':
            shader_content=write_tags("HLSLTemplates/BSDF/principled_bsdf_tags.txt", shader_content)
            shader_content=write_property_from_file("HLSLTemplates/BSDF/alpha_shader_properties.txt", shader_content)
            shader_content=write_pass_properties("HLSLTemplates/BSDF/alpha_pass_properties.txt", shader_content)
            self.function_path = self.alpha_blend_function_path

        
        if get_common_values().blending_mode == 'CLIP':
            #Agrega la propiedad
            property_line = f"_Cutoff (\"Alpha Cutoff\", Range(0, 1)) = {get_common_values().cutoff}\n\t\t"
            if(property_line not in shader_content):
                shader_content=write_property(property_line, shader_content)
            
            #Agrega la propiedad como variable para poder editarla
            variable_line = f"float _Cutoff;\n\t\t\t"
            if(variable_line not in shader_content):
                shader_content=write_variable(variable_line, shader_content)
            
            #Agrega la comprobacion de transparencia de Material Output
            output_line=f"MaterialOutput_Surface.w = MaterialOutput_Surface.w > _Cutoff ? 1 : 0;\n\t\t\t\t"
            if(output_line not in shader_content):
                variables_index = shader_content.find("// Add cutoff")
                shader_content = shader_content[:variables_index] + output_line + shader_content[variables_index:]
              
        shader_content = write_function(self.function_path, shader_content)

        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = node.name.replace(".", "_")
        node_name = node_name.replace(" ", "_") #Caso único para el nodo principled bsdf
        
        for link in node.outputs["BSDF"].links :

            input_node = link.to_node
            input_property = link.to_socket

            shader_content = write_struct_property(node_name, "BSDF", "float4", input_node, input_property, shader_content)

        return shader_content
    
        
    