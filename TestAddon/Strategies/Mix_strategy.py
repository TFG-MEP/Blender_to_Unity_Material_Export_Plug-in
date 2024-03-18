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

            struct_prop='Result'
            struct_type='float4'

            if data_type == 'RGBA':
                struct_name='Mix_color'
                node_name=node_name+'_color'
                function_name='mix_color'
                shader_content = write_struct("HLSLTemplates/Mix/struct_color.txt", shader_content)
                shader_content = write_function("HLSLTemplates/Mix/mix_color.txt", shader_content)
                
                blending_mode = node.blend_type
                #print(f"Blending mode is... {blending_mode}")

                clamp_result = node.clamp_result
                #print(f"Clamp result is... {clamp_result}")

            elif data_type == 'VECTOR':
                #struct_prop='Result'
                struct_name='Mix_vector'
                node_name=node_name+'_vector'
                function_name='mix_vector'
                struct_type='float3'
                shader_content = write_struct("HLSLTemplates/Mix/struct_vector.txt", shader_content)
                shader_content = write_function("HLSLTemplates/Mix/mix_vector.txt", shader_content)
                
                factor_mode = node.factor_mode
                #print(f"Factor Mode is... {factor_mode}")

            elif data_type == 'VALUE':
                struct_name='Mix_float'
                node_name=node_name+'_float'
                function_name='mix_float'
                shader_content = write_struct("HLSLTemplates/Mix/struct_float.txt", shader_content)
                shader_content = write_function("HLSLTemplates/Mix/mix_float.txt", shader_content)
            
            all_parameters = ', '.join(node_properties) #Revisar si es necesario
            shader_content = write_struct_node(node_name, struct_name, function_name, all_parameters, shader_content)
            
            for link in output.links :
                input_node = link.to_node
                input_property = link.to_socket
                shader_content = write_struct_property(node_name, struct_prop, struct_type, input_node, input_property, shader_content)
                
        return shader_content

# Add the struct 
        #shader_content = write_struct("HLSLTemplates/RGB/struct.txt", shader_content)

        # Add the function to the shader template
        #shader_content = write_function("HLSLTemplates/RGB/rgb.txt", shader_content)


