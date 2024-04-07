from abc import ABC, abstractmethod

class Strategy(ABC):
    """
    The Strategy interface declares operations common to all supported versions
    of some algorithm.

    The Context uses this interface to call the algorithm defined by Concrete
    Strategies.
    """

    function_path = None
    struct_path = None

    def write_node(self, node, node_properties, shaderContent): # TODO : Podemos mirar meter esta info en un "struct"
        shaderContent = self.add_includes(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.add_defines(node=node, node_properties=node_properties, shader_content=shaderContent)
        node_properties, shaderContent = self.add_custom_properties(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.add_function(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.add_struct(node=node, node_properties=node_properties, shader_content=shaderContent)
        shaderContent = self.write_outputs(node=node, node_properties=node_properties, shader_content=shaderContent)
        return shaderContent

    def node_name(self, node) : 
        node_name = node.name.replace(" ", "")
        node_name = node_name.replace(".", "")
        return node_name
    
    def add_includes(self, node, node_properties, shader_content):
        return shader_content

    def add_defines(self, node, node_properties, shader_content):
        return shader_content

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content

    @abstractmethod
    def add_struct(self, node, node_properties, shader_content):
        pass

    @abstractmethod
    def add_function(self, node, node_properties, shader_content):
        pass

    @abstractmethod
    def write_outputs(self, node, node_properties, shader_content) :
        pass