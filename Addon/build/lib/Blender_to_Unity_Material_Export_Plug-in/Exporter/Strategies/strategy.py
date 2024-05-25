from abc import ABC, abstractmethod
from ..Utils.writing_utils import *

class Strategy(ABC):
    """
    The Strategy interface declares operations common to all supported versions
    of some algorithm.

    The Context uses this interface to call the algorithm defined by Concrete
    Strategies.
    """

    function_path = None
    function_name = None
    
    struct_path = None
    basic_struct_path = "HLSLTemplates/struct.txt"

    def write_node(self, node, node_properties, shaderContent):
        shaderContent = self.add_includes(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.add_defines(node=node, node_properties=node_properties, shader_content=shaderContent)
        node_properties, shaderContent = self.add_custom_properties(node=node, node_properties=node_properties, shader_content=shaderContent)
        
        shaderContent = self.add_function(node=node, node_properties=node_properties, shader_content=shaderContent)
         
        shaderContent = self.add_struct(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.write_outputs(node=node, node_properties=node_properties, shader_content=shaderContent)

        return shaderContent

    def node_name(self, node) : 
        node_name = node.name.replace(" ", "_")
        node_name = node_name.replace(".", "_")
        return node_name
    
    def add_includes(self, node, node_properties, shader_content):
        return shader_content

    def add_defines(self, node, node_properties, shader_content):
        return shader_content

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content

    def add_struct(self, node, node_properties, shader_content):
        struct_name = node.bl_label.replace(" ", "_") + "_struct"
        shader_content = write_struct_members(self.basic_struct_path, struct_name, node.outputs, shader_content)
        all_parameters = ', '.join(node_properties)
        shader_content = write_struct_node(self.node_name(node), struct_name, self.function_name, all_parameters, shader_content)
        return shader_content

    def add_function(self, node, node_properties, shader_content):
        shader_content = write_function(self.function_path, shader_content)
        return shader_content

    @abstractmethod
    def write_outputs(self, node, node_properties, shader_content) :
        pass