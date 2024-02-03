bl_info = {
    "name": "GENERATE UNITY MATERIAL",
    "blender": (2, 80, 0),
    "category": "Object",
}

import bpy
from bpy.props import StringProperty
from .PythonScripts.pruebaShaderDirecto import generateShader

class GeneraShader(bpy.types.Operator):
    bl_idname = "object.generar_unity_material"
    bl_label = "Generate Material"
    filepath: StringProperty(subtype="FILE_PATH")
    # Aqui se determina qué ocurre al seleccionar esta opción del panel
    def execute(self, context):
        print("Ruta seleccionada:", self.filepath)
        generateShader(self.filepath)
        return {'FINISHED'}
    def invoke(self, context, event):
        context.window_manager.fileselect_add(self)
        return {'RUNNING_MODAL'}
    



class PT_Panel(bpy.types.Panel):
    bl_label = "Generate Unity Material"
    bl_idname = "PT_Panel"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = 'Tool'
    
    def draw(self, context):
        layout = self.layout
        # Aqui se determina que aparece en el panel
        layout.operator("object.generar_unity_material")

def menu_func(self, context):
    self.layout.operator(GeneraShader.bl_idname)

def register():
    bpy.utils.register_class(GeneraShader)
    bpy.types.Scene.selected_directory = bpy.props.StringProperty()
    bpy.utils.register_class(PT_Panel)
 

def unregister():
    bpy.utils.unregister_class(GeneraShader)
    bpy.utils.unregister_class(PT_Panel)
 

if __name__ == "__main__":
    register()
