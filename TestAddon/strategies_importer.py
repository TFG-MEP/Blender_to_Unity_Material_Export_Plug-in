# Abstract Class
from .Strategies.strategy import Strategy

# Implementations
from .Strategies.RGB_strategy import RGBNode
from .Strategies.Checker_strategy import CheckerNode
from .Strategies.PrincipledBSDF_strategy import PrincipledBSDFNode
from .Strategies.ImageTexture_strategy import ImageTextureNode
from .Strategies.Mapping_strategy import MappingNode
from .Strategies.Value_strategy import ValueNode
from .Strategies.TextureCoordinate_strategy import TextureCoordinateNode
from .Strategies.Default_strategy import DefaultNode

# Import all new strategies implemented in the Strategies Directory

from .Strategies import *

# Node type to strategy map
node_type_strategy_map = {
    'VALUE': ValueNode(),
    'RGB': RGBNode(),
    'BSDF_PRINCIPLED': PrincipledBSDFNode(),
    'TEX_IMAGE': ImageTextureNode(),
    'TEX_COORD': TextureCoordinateNode(),
    'MAPPING': MappingNode(),
    'TEX_CHECKER': CheckerNode()
}