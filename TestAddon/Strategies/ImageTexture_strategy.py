from .strategy import Strategy
from ..writing_utils import *
from ..common_utils import *

class ImageTextureNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        
        node_name = node.name.replace(" ", "")
        node_name=node_name.replace(".", "")
        node_properties.append(node_name + "_Image")

        imagesMap = get_common_values().imagesMap

        image_path = bpy.path.abspath(node.image.filepath)
        print(f'Image Path: {image_path}')
        if image_path not in imagesMap:
            imagesMap[image_path] = []
        # Ahora agregamos el nombre del nodo de imagen al diccionario imagesMap
        imagesMap[image_path].append(f'{node_name}_Image')

        property_line = f'{node_name}_Image("Texture", 2D) = "white" {{}}\n\t\t'
        # ... y se añaden al shader
        shader_content = write_property(property_line, shader_content)

        variable_line = f'sampler2D {node_name}_Image;\n\t\t\t'
        shader_content = write_variable(variable_line, shader_content)
        exit_connection = node.outputs["Color"].links[0]
        input_node = exit_connection.to_node
        input_property = exit_connection.to_socket
        #write_node(function_file_path, function_parameters, destination_node, destination_property, shader_content) 
        shader_content = write_node("HLSLTemplates/image_texture.txt", node_properties, input_node, input_property, shader_content)

        get_common_values().imagesMap = imagesMap
        
        return shader_content