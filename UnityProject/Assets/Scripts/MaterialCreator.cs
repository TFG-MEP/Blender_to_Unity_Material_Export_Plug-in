using UnityEngine;
using UnityEditor;

public class MaterialGenerator : EditorWindow
{
    // Nombres por defecto
    private string shaderPath = "Custom/GeneratedShader";
    private string materialName = "GeneratedMaterial";
    private string destinationFolder = "Assets/";

    [MenuItem("Tools/Generate Material")] // acceso al script bajo la ventana tools
    static void Init()
    {
        MaterialGenerator window = (MaterialGenerator)EditorWindow.GetWindow(typeof(MaterialGenerator));
        window.Show();
    }

    void OnGUI()
    {
        GUILayout.Label("Material Generator", EditorStyles.boldLabel);

        materialName = EditorGUILayout.TextField("Material Name", materialName);
        shaderPath = EditorGUILayout.TextField("Shader Location", shaderPath);
        destinationFolder = EditorGUILayout.TextField("Destination Folder", destinationFolder);

        if (GUILayout.Button("Generate Material"))
        {
            GenerateMaterial();
        }
    }

    void GenerateMaterial()
    {
        string materialPath = $"{destinationFolder}/{materialName}.mat";
        shaderPath = $"{shaderPath}.shader";

        // Extraer el nombre del shader de la ruta --> presupone que el shader tiene el mismo nombre que el archivo donde está guardado
        string shaderName = "Custom/" + System.IO.Path.GetFileNameWithoutExtension(shaderPath);
        
        // Crear el material con el shader asociado
        Material material = new Material(Shader.Find(shaderName));

        // Guardar el material en disco
        AssetDatabase.CreateAsset(material, materialPath);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Nuevo material '" + materialName + "' generado en: " + materialPath);
    }
}
