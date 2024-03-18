from .strategy import Strategy
from ..writing_utils import *

class PrincipledBSDFNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        
        #node_name = node.name.replace(" ", "")
        node_name=node.name.replace(".", "_")
        node_name = node_name.replace(" ", "_") #Caso único para el nodo principled bsdf
        
        node_properties.insert(0, 'i')
      
        shader_content = write_struct("HLSLTemplates/BSDF/struct.txt", shader_content)

        # Add the function to the shader template
        shader_content = write_function("HLSLTemplates/BSDF/principled_bsdf.txt", shader_content)
        
        # Add the function call to the shader template
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(node_name, "BSDF", "principled_bsdf", all_parameters, shader_content)
        print(f"node_name: {node_name}")
        for link in node.outputs["BSDF"].links :

            input_node = link.to_node
            input_property = link.to_socket

            shader_content = write_struct_property(node_name, "BSDF_output", "float4", input_node, input_property, shader_content)
                
        if get_common_values().blending_mode == 'BLEND' or get_common_values().blending_mode == 'CLIP':
                if node.inputs['Alpha'].default_value < 1:
                    shader_content=write_tags("HLSLTemplates/BSDF/principled_bsdf_tags.txt", shader_content)
        else:
            shader_content=shader_content.replace("clamp(PrincipledBSDF_Alpha,0,1)", "1")
        
        return shader_content