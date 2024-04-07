from .strategy import Strategy
from ..writing_utils import *

class MixNode(Strategy) : # TODO : revisar esta estrategia, se repiten muchos FOR


    mix_node_properties = {
        'VALUE':{
            'function_path' : "HLSLTemplates/Mix/mix_float.txt",
            'function_name' : 'mix_float',
            'struct_path' : "HLSLTemplates/Mix/struct_float.txt",
            'struct_name' : 'Mix_float',
            'struct_type' : 'float',
            'node_name_suffix' : '_float'
        },
        'VECTOR':{
            'function_path' : "HLSLTemplates/Mix/mix_vector.txt",
            'function_name' : 'mix_vector',
            'struct_path' : "HLSLTemplates/Mix/struct_vector.txt",
            'struct_name' : 'Mix_vector',
            'struct_type' : 'float3',
            'node_name_suffix' : '_vector'
        },
        'RGBA':{
            'function_path' : "HLSLTemplates/Mix/mix_color.txt",
            'function_name' : 'mix_color',
            'struct_path' : "HLSLTemplates/Mix/struct_color.txt",
            'struct_name' : 'Mix_color',
            'struct_type' : 'float4',
            'node_name_suffix' : '_color'
        }
    }
    
    blending_function_paths = {
        'MIX' : "HLSLTemplates/Mix/Blending_Functions/mix.txt",
        'ADD' : "HLSLTemplates/Mix/Blending_Functions/add.txt"
    }
    
    def write_blending_function(self, blending_mode, shader_content):
        file_path = self.blending_function_paths.get(blending_mode)
        with open(file_path, "r") as func_file:
            blending_function = func_file.read()

        index = shader_content.find("// Add blending function")
        shader_content = shader_content[:index] + blending_function + shader_content[index:]

        return shader_content


    def add_custom_properties(self, node, node_properties, shader_content):
        node_name = self.node_name(node)

        for output in node.outputs :
            if output.is_linked:
                data_type = output.type

                clamp_factor = blender_value_to_hlsl(node.clamp_factor, "Bool")
                node_properties.append(node_name + "_Clamp_Factor")

                property_line = f'{node_name}_Clamp_Factor("Clamp_Factor", Int) = {clamp_factor}\n\t\t'

                shader_content = write_property(property_line, shader_content)

                variable_line = f'bool {node_name}_Clamp_Factor;\n\t\t\t'
                shader_content = write_variable(variable_line, shader_content)

                if data_type == 'RGBA':
                    clamp_result = blender_value_to_hlsl(node.clamp_result, "Bool")
                    node_properties.append(node_name + "_Clamp_Result")

                    property_line = f'{node_name}_Clamp_Result("Clamp_Result", Int) = {clamp_result}\n\t\t'
                    shader_content = write_property(property_line, shader_content)

                    variable_line = f'bool {node_name}_Clamp_Result;\n\t\t\t'
                    shader_content = write_variable(variable_line, shader_content)

                elif data_type == 'VECTOR':
                    factor_mode = node.factor_mode
                    print(node.factor_mode)
                    if (factor_mode == "UNIFORM") : # If factor mode is Uniform, set bool to true
                        factor_mode = 1
                    else : # False otherwise
                        factor_mode = 0

                    node_properties.append(node_name + "_Factor_Mode_Uniform")

                    property_line = f'{node_name}_Factor_Mode_Uniform("Uniform Vector Mix", Int) = {factor_mode}\n\t\t'
                    shader_content = write_property(property_line, shader_content)

                    variable_line = f'bool {node_name}_Factor_Mode_Uniform;\n\t\t\t'
                    shader_content = write_variable(variable_line, shader_content)


        return node_properties, shader_content
    
    def add_struct(self, node, node_properties, shader_content):
        node_name = self.node_name(node)
        all_parameters = ', '.join(node_properties) #Revisar si es necesario

        print(all_parameters)
        for output in node.outputs :
            if output.is_linked:
                struct_prop='Result'

                # Get the data type
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)

                # Check if the properties for this data type are added
                if (mix_properties) :
                    struct_name = mix_properties['struct_name']
                    node_name = self.node_name(node)
                    node_name = node_name + mix_properties['node_name_suffix']
                    function_name = mix_properties['function_name']
                    struct_type = mix_properties['struct_type']
                    struct_path = mix_properties['struct_path']
                    function_path = mix_properties['function_path']

                    shader_content = write_struct(struct_path, shader_content)

                    shader_content = write_struct_node(node_name, struct_name, function_name, all_parameters, shader_content)
                else:
                    raise SystemExit("mix_properties not defined for this type of Mix mode")

        return shader_content
   
    def add_function(self, node, node_properties, shader_content):

        for output in node.outputs :
            if output.is_linked:
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)

                if mix_properties:
                    function_path = mix_properties.get('function_path')
                    if function_path:
                        shader_content = write_function(function_path, shader_content)

                        if data_type == 'RGBA' :
                            print("Blending Mode: ", node.blend_type)
                            shader_content = self.write_blending_function(node.blend_type, shader_content)

                    else:
                        raise SystemExit("function_path not defined for this type of Mix mode")
                else:
                    raise SystemExit("mix_properties not defined for this type of Mix mode")

        return shader_content
    
    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        for output in node.outputs :
            if output.is_linked:
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)

                struct_prop = 'Result'
                struct_type = mix_properties['struct_type']
                node_name = node_name + mix_properties['node_name_suffix']

                for link in output.links :
                    input_node = link.to_node
                    input_property = link.to_socket
                    shader_content = write_struct_property(node_name, struct_prop, struct_type, input_node, input_property, shader_content)
                
        return shader_content

    #TODO: comprobar funcionamiento para casos que no son color