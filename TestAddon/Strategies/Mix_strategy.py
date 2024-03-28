from .strategy import Strategy
from ..writing_utils import *

class MixNode(Strategy) : # TODO : revisar esta estrategia, se repiten muchos FOR

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        node_name = self.node_name(node)
        all_parameters = ', '.join(node_properties) #Revisar si es necesario

        for output in node.outputs :

            data_type = output.type

            struct_prop='Result'
            struct_type='float4'

            if data_type == 'RGBA':
                struct_name='Mix_color'
                node_name=node_name+'_color'
                function_name='mix_color'
                shader_content = write_struct("HLSLTemplates/Mix/struct_color.txt", shader_content)
                
                blending_mode = node.blend_type

                clamp_result = node.clamp_result

            elif data_type == 'VECTOR':
                struct_name='Mix_vector'
                node_name=node_name+'_vector'
                function_name='mix_vector'
                struct_type='float3'
                shader_content = write_struct("HLSLTemplates/Mix/struct_vector.txt", shader_content)
                
                factor_mode = node.factor_mode

            elif data_type == 'VALUE':
                struct_name='Mix_float'
                node_name=node_name+'_float'
                function_name='mix_float'
                shader_content = write_struct("HLSLTemplates/Mix/struct_float.txt", shader_content)
            
            shader_content = write_struct_node(node_name, struct_name, function_name, all_parameters, shader_content)
            
        return shader_content
   
    def add_function(self, node, node_properties, shader_content):

        for output in node.outputs :

            data_type = output.type
            if data_type == 'RGBA':
                shader_content = write_function("HLSLTemplates/Mix/mix_color.txt", shader_content)
            elif data_type == 'VECTOR':
                shader_content = write_function("HLSLTemplates/Mix/mix_vector.txt", shader_content)
            elif data_type == 'VALUE':
                shader_content = write_function("HLSLTemplates/Mix/mix_float.txt", shader_content)

        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)

        clamp_factor = node.clamp_factor

        for output in node.outputs :

            data_type = output.type

            struct_prop='Result'
            struct_type='float4'

            if data_type == 'RGBA':
                struct_name='Mix_color'
                node_name=node_name+'_color'
                function_name='mix_color'
                
                blending_mode = node.blend_type

                clamp_result = node.clamp_result

            elif data_type == 'VECTOR':
                #struct_prop='Result'
                struct_name='Mix_vector'
                node_name=node_name+'_vector'
                function_name='mix_vector'
                struct_type='float3'
                
                factor_mode = node.factor_mode

            elif data_type == 'VALUE':
                struct_name='Mix_float'
                node_name=node_name+'_float'
                function_name='mix_float'
            
            for link in output.links :
                input_node = link.to_node
                input_property = link.to_socket
                shader_content = write_struct_property(node_name, struct_prop, struct_type, input_node, input_property, shader_content)
                
        return shader_content

    #TODO: comprobar funcionamiento para casos que no son color