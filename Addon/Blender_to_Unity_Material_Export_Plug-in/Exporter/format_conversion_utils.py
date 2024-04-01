import bpy

def gamma_correction(rgb) :
    """Applies gamma correction of 2.2 to the given RGB color.

    Args:
        rgb (tuple): A tuple containing the red, green, and blue components of the color.

    Returns:
        tuple: A tuple containing the gamma corrected red, green, and blue components.
    """
    return tuple(channel ** (1.0 / 2.2) for channel in rgb)
    

def blender_value_to_hlsl(blender_input, input_type) : 
    """Transforms a Blender value to HLSL-compatible format.

    Args:
        blender_input: The input value from Blender.
        input_type (str): The type of the input value.

    Returns:
        str: The input value converted to HLSL-compatible format.
    """
    if (input_type == 'Float') :
        return blender_input
    elif (input_type == 'Color') :
        # Apply gamma correction to colors
        blender_color = (blender_input[0], blender_input[1], blender_input[2])
        unity_color = gamma_correction(blender_color)
        return f'({unity_color[0]},{unity_color[1]},{unity_color[2]}, 1.0)'
        #return f'({blender_input[0]},{blender_input[1]},{blender_input[2]}, 1.0)'
    elif(input_type == 'Vector') :
        return f'({blender_input[0]}, {blender_input[1]}, {blender_input[2]})'
    else : 
        return blender_input

def blender_type_to_hlsl(blender_input):
    """Transforms a Blender data type to HLSL-compatible data type.

    Args:
        blender_input (str): The Blender data type.

    Returns:
        str: The equivalent HLSL data type.
    """
    if blender_input == 'Float':
        output = 'float'
    elif blender_input == 'Color' :
        output = 'float4'
    elif blender_input == 'Vector' :
        output = 'float3'
    elif blender_input == 'Shader' :
        output = 'float4'
    else : 
        output = blender_input
    # TODO : completar con todos los tipos de datos posibles
    return output

def blender_type_to_properties(blender_input):
    """Transforms a Blender data type to a shader properties-compatible data type.

    Args:
        blender_input (str): The Blender data type.

    Returns:
        str: The equivalent data type in shader properties.
    """
    if blender_input == 'Float':
        output = 'float'
    elif blender_input == 'Color' :
        output = 'Color'
    elif blender_input == 'Vector' :
        output = 'Vector'
    elif blender_input == 'Shader' :
        output = 'Color'
    else : 
        output = blender_input
    # TODO : completar con todos los tipos de datos
    return output