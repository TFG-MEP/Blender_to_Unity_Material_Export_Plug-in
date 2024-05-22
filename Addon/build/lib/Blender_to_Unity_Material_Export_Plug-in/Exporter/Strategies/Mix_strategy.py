from .strategy import Strategy
from ..Utils.writing_utils import *
from ..Utils.common_utils import *

class MixNode(Strategy) : # TODO : revisar esta estrategia, se repiten muchos FOR
    
    mix_node_properties = {
        'VALUE':{
            'function_path' : "HLSLTemplates/Mix/mix_float.txt",
            'function_name' : 'mix_float',
            'struct_type' : 'float',
            'struct_suffix' : "_value"
        },
        'VECTOR':{
            'function_path' : "HLSLTemplates/Mix/mix_vector.txt",
            'function_name' : 'mix_vector',
            'struct_type' : 'float3',
            'struct_suffix' : "_vector"
        },
        'RGBA':{
            'function_path' : "HLSLTemplates/Mix/mix_color.txt",
            'function_name' : 'mix_color',
            'struct_type' : 'float3',
            'struct_suffix' : "_color"
        }
    }
    
    blending_function_paths = {
        'MIX' : "HLSLTemplates/Mix/Blending_Functions/blending_mix.txt",
        'ADD' : "HLSLTemplates/Mix/Blending_Functions/blending_add.txt"
    }
    
    def write_blending_function(self, blending_mode, shader_content):
        file_path = self.blending_function_paths.get(blending_mode)
        shader_content = write_function(file_path, shader_content)
        return shader_content

    def write_blending_function_call(self, blending_mode, shader_content) :
        file_path = self.blending_function_paths.get(blending_mode)
        shader_content = shader_content.replace("// Add blend function", get_function_name_from_path(file_path))
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

                    self.function_name = "mix_color"

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
                    
                    self.function_name = "mix_vector"
                
                else :
                    self.function_name = "mix_float"


        return node_properties, shader_content
   
    def add_function(self, node, node_properties, shader_content):

        for output in node.outputs :
            if output.is_linked: # write function for the connected output type
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)

                if mix_properties:
                    function_path = mix_properties.get('function_path')
                    if function_path:

                        if data_type == 'RGBA' : # For Color Mix, add the blending function
                            #print("Blending Mode: ", node.blend_type)
                            shader_content = self.write_blending_function(node.blend_type, shader_content)

                        shader_content = write_function(function_path, shader_content)

                        if data_type == 'RGBA' : # For Color Mix, call the blending function
                            shader_content = self.write_blending_function_call(node.blend_type, shader_content)

                    else:
                        raise SystemExit("function_path not defined for this type of Mix mode")
                else:
                    raise SystemExit("mix_properties not defined for this type of Mix mode")

        return shader_content
    
    # The Mix node has to implement its own version of add_struct because of how it's built in Blender
    def add_struct(self, node, node_properties, shader_content):

        for output in node.outputs :
            if output.is_linked:
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)
                struct_suffix = mix_properties.get('struct_suffix')

                struct_name = node.bl_label.replace(" ", "_") + struct_suffix + "_struct"

                if struct_name not in get_common_values().added_structs :
                    get_common_values().added_structs.add(struct_name)
                    with open(self.basic_struct_path, "r") as struct_file:
                        basic_struct = struct_file.read()

                    # name the struct accordingly
                    basic_struct = basic_struct.replace("Struct_name", struct_name)
                    
                    # add all of the nodes exits as struct members
                    members_index = basic_struct.find("// add members")

                    output_type = blender_type_to_hlsl(output.bl_label)
                    output_name = output.name.replace(" ", "_")
                    
                    line = output_type + " " + output_name + ";\n\t\t\t"
                    basic_struct = basic_struct[:members_index] + line + basic_struct[members_index:]

                    struct_index = shader_content.find("// Add structs")
                    shader_content = shader_content[:struct_index] + basic_struct + "\n\t\t\t" + shader_content[struct_index:]
                
                all_parameters = ', '.join(node_properties)
                shader_content = write_struct_node(self.node_name(node), struct_name, self.function_name, all_parameters, shader_content)

        return shader_content



    def write_outputs(self, node, node_properties, shader_content) :
        node_name = self.node_name(node)
        for output in node.outputs :
            if output.is_linked:
                data_type = output.type
                mix_properties = self.mix_node_properties.get(data_type)
                struct_type = mix_properties['struct_type']

                for link in output.links :
                    input_node = link.to_node
                    input_property = link.to_socket
                    shader_content = write_struct_property(node_name, "Result", struct_type, input_node, input_property, shader_content)
                
        return shader_content

    #TODO: comprobar funcionamiento para casos que no son color