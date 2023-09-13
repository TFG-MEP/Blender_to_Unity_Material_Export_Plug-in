import bpy

# Selecciona el objeto que tiene el material que te interesa
#bpy.ops.mesh.primitive_monkey_add(size=2, enter_editmode=False, align='WORLD', location=(0, 0, 0), scale=(1, 1, 1))

obj = bpy.context.active_object
print("hola")
# Asegúrate de que el objeto tenga un material
if len(obj.data.materials) > 0:
    # Obtiene el primer material asignado al objeto (puedes modificar el índice si necesitas otro material)
    material = obj.data.materials[0]

    # Comprueba si el material tiene un Principled BSDF shader
    if material.node_tree:
        for node in material.node_tree.nodes:
            if node.type == 'BSDF_PRINCIPLED':
                # Obtiene el color base del shader Principled BSDF
                base_color = node.inputs["Base Color"].default_value
                print("RED Color:", base_color[0])
                print("GREEN Color:", base_color[1])
                print("BLUE Color:", base_color[2])
                print("ALPHA Color:", base_color[3])