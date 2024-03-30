from .strategy import Strategy

class DefaultNode(Strategy):

    def add_custom_properties(self, node, node_properties, shader_content):
        return node_properties, shader_content

    def add_struct(self, node, node_properties, shader_content):
        return shader_content

    def add_function(self, node, node_properties, shader_content):
        return shader_content

    def write_outputs(self, node, node_properties, shader_content) :
        print("You haven't set a strategy for this node type. Default Node doesn't write anything")
        return shader_content