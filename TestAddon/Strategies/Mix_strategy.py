from .strategy import Strategy
from ..writing_utils import *

class MixNode(Strategy) :
    def write_node(self, node, node_properties, shader_content) :
        node_name = node.name.replace(" ", "")
        node_name = node_name.replace(".", "")
        #print(node_name)

        clamp_factor = node.clamp_factor
        #print(f"Clamp factor is... {clamp_factor}")

        for output in node.outputs :

            data_type = output.type

            template = "HLSLTemplates/mix_color.txt"

            if data_type == 'RGBA':
                template = "HLSLTemplates/mix_color.txt"
                
                blending_mode = node.blend_type
                #print(f"Blending mode is... {blending_mode}")

                clamp_result = node.clamp_result
                #print(f"Clamp result is... {clamp_result}")

            elif data_type == 'VECTOR':
                template = "HLSLTemplates/mix_vector.txt"

                factor_mode = node.factor_mode
                #print(f"Factor Mode is... {factor_mode}")

            elif data_type == 'VALUE':
                template = "HLSLTemplates/mix_float.txt"


            for link in output.links :
                input_node = link.to_node
                input_property = link.to_socket

                shader_content = write_node(template, node_properties, input_node , input_property, shader_content)

        return shader_content



