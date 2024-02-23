from abc import ABC, abstractmethod

class Strategy(ABC):
    """
    The Strategy interface declares operations common to all supported versions
    of some algorithm.

    The Context uses this interface to call the algorithm defined by Concrete
    Strategies.
    """

    @abstractmethod
    def write_node(self, node, node_properties, shader_content): # TODO : Podemos mirar meter esta info en un "struct"
        pass