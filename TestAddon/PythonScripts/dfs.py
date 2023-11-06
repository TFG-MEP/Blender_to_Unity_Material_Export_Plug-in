import bpy

def dfs(node, visited):
    visited.add(node)
    print("Nombre del nodo:", node.name)

    # Recorre los nodos conectados
    for input_socket in node.inputs:
        for link in input_socket.links:
            next_node = link.from_node
            if next_node not in visited:
                dfs(next_node, visited)

obj = bpy.context.active_object

# Asegúrate de que el objeto tenga un material
if obj.data.materials:
    # Accede al primer material asignado al objeto (índice 0)
    material = obj.data.materials[0]
    # Accede al nodo del material en el Shader Editor
    material.use_nodes = True
    node_tree = material.node_tree
    nodes = node_tree.nodes

    # Nodo raíz (puedes cambiarlo según tus necesidades)
    root_node = nodes.get("Material Output")
    if root_node:
        visited = set()
        dfs(root_node, visited)

# Guarda los cambios
bpy.ops.wm.save_mainfile(filepath=bpy.data.filepath)