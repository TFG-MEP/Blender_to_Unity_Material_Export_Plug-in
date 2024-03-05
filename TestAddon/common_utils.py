
class CommonValues() :
    def __init__(self) -> None:

        self.visited_nodes = set()
        self.imagesMap = {}
        self.added_functions = set()
        self.added_includes = set()
        self.added_tags= set()
        self.MaterialOutput_Surface_added = False

    def clear_common_variables(self) : 

        self.visited_nodes = set()
        self.imagesMap = {}
        self.added_functions = set()
        self.added_includes = set()
        self.added_tags= set()
        self.MaterialOutput_Surface_added = False


def get_common_values() : 
    return common_values

common_values = CommonValues()
