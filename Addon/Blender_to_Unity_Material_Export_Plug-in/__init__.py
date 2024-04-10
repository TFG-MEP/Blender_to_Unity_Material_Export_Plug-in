
bl_info = {
    "name": "GENERATE UNITY MATERIAL",
    "blender": (2, 80, 0),
    "category": "Object",
}

import os
import bpy
import site
import sys
import pathlib
from bpy.props import StringProperty,BoolProperty

def third_party_modules_sitedir():
    # If we are in a VIRTUAL_ENV, while developing for example, we want the
    # addon to hit the modules installed in the virtual environment
    if 'VIRTUAL_ENV' in os.environ:
        env = pathlib.Path(os.environ['VIRTUAL_ENV'])
        v = sys.version_info
        path = env / 'lib/python{}.{}/site-packages'.format(v.major, v.minor)

    # However outside of a virtual environment, the additionnal modules not
    # shipped with Blender are expected to be found in the root folder of
    # the addon
    else:
        path = pathlib.Path(__file__).parent

    return str(path.resolve())

# The additionnal modules location (virtual env or addon folder) is
# appended here
site.addsitedir(third_party_modules_sitedir())


from Exporter.exporter import export

class GeneraShader(bpy.types.Operator):
   
    bl_idname = "object.generar_unity_material"
    bl_label = "Generate Material"
    filepath: StringProperty(subtype="FILE_PATH")
    export_fbx: BoolProperty(name="Export FBX", default=False)
    # Aqui se determina qué ocurre al seleccionar esta opción del panel
    def execute(self, context):
        
        directory = os.path.dirname(self.filepath)
        print(os.path.dirname(os.path.abspath(__file__)))
        print("Ruta seleccionada:", directory)
        
        try :
            export(directory,self.export_fbx)
        except SystemExit as e:
            error_message = "Execution stopped due to error: " + str(e)
            self.report({'ERROR'}, error_message)

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
