from .strategy import Strategy

class DefaultNode(Strategy):
    def write_node(self, node, node_properties, shader_content):
        print("You haven't set a strategy for this node type. Default Node doesn't write anything")
        return shader_content