from .strategy import Strategy
from ..writing_utils import *
from ..common_utils import *

class ImageTextureNode(Strategy):

    function_path = "HLSLTemplates/Image_Texture/image_texture.txt"
    function_name = "image_texture"

    def add_custom_properties(self, node, node_properties, shader_content):
        node_name = self.node_name(node)

        node_properties.append(node_name + "_Image")

        imagesMap = get_common_values().imagesMap

        # Add Image to imagesMap to create a copy of it
        image_path = bpy.path.abspath(node.image.filepath)
        print(f'Image Path: {image_path}')
        if image_path not in imagesMap:
            imagesMap[image_path] = []
        imagesMap[image_path].append(f'{node_name}_Image')
        get_common_values().imagesMap = imagesMap

        property_line = f'{node_name}_Image("Texture", 2D) = "white" {{}}\n\t\t'
        shader_content = write_property(property_line, shader_content)

        variable_line = f'sampler2D {node_name}_Image;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)

        return node_properties, shader_content

    def write_outputs(self, node, node_properties, shader_content) :
        
        node_name = self.node_name(node)

        for exit_connection in node.outputs["Color"].links  :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Color", "float3", input_node, input_property, shader_content)

        for exit_connection in node.outputs["Alpha"].links :
            input_node = exit_connection.to_node
            input_property = exit_connection.to_socket

            shader_content = write_struct_property(node_name, "Alpha", "float", input_node, input_property, shader_content)

        return shader_content