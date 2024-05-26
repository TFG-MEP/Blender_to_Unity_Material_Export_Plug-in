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
from .Strategies.AddShader_strategy import AddShaderNode
from .Strategies.MixShader_strategy import MixShaderNode
from .Strategies.Mix_strategy import MixNode
from .Strategies.NormalMap_statregy import NormalMapNode
from .Strategies.ColorRamp_Strategy import ColorRampNode
from .Strategies.ShaderToRGB_strategy import ShaderToRgbNode
from .Strategies.Voronoi_strategy import VaronoiNode

from .Strategies import *

# Node type to strategy map
node_type_strategy_map = {
    'VALUE': ValueNode(),
    'RGB': RGBNode(),
    'BSDF_PRINCIPLED': PrincipledBSDFNode(),
    'TEX_IMAGE': ImageTextureNode(),
    'TEX_COORD': TextureCoordinateNode(),
    'MAPPING': MappingNode(),
    'TEX_CHECKER': CheckerNode(),
    'ADD_SHADER': AddShaderNode(),
    'MIX_SHADER': MixShaderNode(),
    'NORMAL_MAP': NormalMapNode(),
    'VALTORGB': ColorRampNode(),
    'SHADERTORGB':ShaderToRgbNode(),
    'MIX' : MixNode(),
    'TEX_VORONOI' : VaronoiNode()
}