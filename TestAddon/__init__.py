bl_info = {
    "name": "OVADILLO",
    "blender": (2, 80, 0),
    "category": "Object",
}

import bpy

class GenerarCuboEnOrigen(bpy.types.Operator):
    bl_idname = "object.generar_cubo_en_origen"
    bl_label = "Generar Cubo en Origen"
    
    def execute(self, context):
        bpy.ops.mesh.primitive_cube_add(location=(0, 0, 0))
        return {'FINISHED'}

class OVADILLO_PT_Panel(bpy.types.Panel):
    bl_label = "OVAashdsak"
    bl_idname = "OVADILLO_PT_Panel"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = 'Tool'
    
    def draw(self, context):
        layout = self.layout
        layout.operator("object.generar_cubo_en_origen")

def menu_func(self, context):
    self.layout.operator(GenerarCuboEnOrigen.bl_idname)

def register():
    bpy.utils.register_class(GenerarCuboEnOrigen)
    bpy.utils.register_class(OVADILLO_PT_Panel)

def unregister():
    bpy.utils.unregister_class(GenerarCuboEnOrigen)
    bpy.utils.unregister_class(OVADILLO_PT_Panel)

if __name__ == "__main__":
    register()
