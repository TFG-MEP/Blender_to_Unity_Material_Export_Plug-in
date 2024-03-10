import bpy
def generate_3dModel(destination_directory):
   objeto = bpy.context.active_object

    # Obtén el nombre del objeto
   nombre_objeto = objeto.name

    # Define la ruta y el nombre de archivo para el archivo FBX de salida, utilizando el nombre del objeto
   ruta_archivo_fbx = destination_directory+'\\' + nombre_objeto + ".fbx"

    # Exporta el objeto como un archivo FBX
   bpy.ops.export_scene.fbx(filepath=ruta_archivo_fbx, use_selection=True, axis_forward='-Z', axis_up='Y', object_types={'MESH'})