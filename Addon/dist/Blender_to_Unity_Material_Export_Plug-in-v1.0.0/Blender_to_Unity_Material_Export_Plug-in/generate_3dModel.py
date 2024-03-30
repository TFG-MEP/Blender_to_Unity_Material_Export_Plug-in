import bpy
def generate_3dModel(destination_directory):
    objeto = bpy.context.active_object

    # Name of the object
    name_object = objeto.name

    # Appy Transforms to the object
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
    path_fbx = destination_directory+'\\' + name_object + ".fbx"

    # Export object to fbx
    bpy.ops.export_scene.fbx(filepath=path_fbx, use_selection=True, axis_forward='-Z', axis_up='Y', object_types={'MESH'})