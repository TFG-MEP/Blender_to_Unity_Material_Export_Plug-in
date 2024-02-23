import bpy

def gamma_correction(rgb) :
    return tuple(channel ** (1.0 / 2.2) for channel in rgb)
    
# Dado un valor de propiedad de un tipo concreto en blender, devuelve un
# string con el formato adecuado en HLSL
def convertir_valor(blender_input, input_type) : 
    if (input_type == 'Float') :
        return blender_input
    elif (input_type == 'Color') :
        blender_color = (blender_input[0], blender_input[1], blender_input[2])
        unity_color = gamma_correction(blender_color)
        #return f'({blender_input[0]},{blender_input[1]},{blender_input[2]}, 1.0)'
        return f'({unity_color[0]},{unity_color[1]},{unity_color[2]}, 1.0)'
    elif(input_type == 'Vector') :
        return f'({blender_input[0]}, {blender_input[1]}, {blender_input[2]})'
    else : 
        return blender_input

# Convierte un string que determina un tipo de datos usado por blender,
# en un string con el tipo de datos equivalente en HLSL
def convertir_tipos_hlsl(blender_input):
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
    # TO_DO : completar con todos los tipos de datos
    return output

# Convierte un string que determina un tipo de datos usado por blender,
# en un string con el tipo de datos equivalente en las propiedades del shader
def convertir_tipos_propiedad(blender_input):
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
    # TO_DO : completar con todos los tipos de datos
    return output
