# Blender to Unity Material Export Add-On
Blender add-on created by Paula Morillas Alonso, Elisa Todd Rodríguez y Miriam Martín Sánchez.
This addon is used for exporting Blender materials and objects to Unity.
You will find the add-on  [here](Addon/dist/Blender_to_Unity_Material_Export_Plug-in-v1.0.0.zip).

#### Installation Guide
-   Open Blender.
-   Go to "Edit" -> "Preferences".
-   Select "Add-ons".
-   Choose the "Install..." option and navigate to the directory where you downloaded the repository's content.
-   Select the downloaded folder and click on "Install Add-on".
-   Activate the add-on by selecting the checkbox next to its name.

#### Using the Add-On
-   Select an object from your Blender scene layout.
-   You should see a tab labeled ``Generate Material'' in the vertical toolbar. Click on that tab.
-   In this tab, you will see a checkbox. Check it or uncheck it in order to choose whether to generate just the material and shader files, or these files along with the prefab and FBX files.
-   Click on the button labeled ``Generate Material''.
-   A new window will pop up for you to select a directory in your file system. This path will be where all the files are generated.


## Development Guide
In the __init__.py file, you will find all the components related to the interface of the add-on, such as the creation of the button and the methods that are called when the button is clicked.

### ./Exporter
This folder contains all the source code of the add-on.

-  ./exporter is the file where all the assets needed for Unity are generated. This file calls the methods of the files contained in ./Exporter/FileGenerator. In this folder, you will find the generators for materials, FBX, prefabs, .meta files, and most importantly, the .shader files.
  
- To create a new node to translate to HLSL, you must create a new strategy. All the nodes that we have implemented are in the ./Exporter/Strategies folder. Additionally, you need to update the map in the ./strategies_importer file, adding the name of the add-on used in Blender as the key and the strategy class as the value. Also, the function in HLSL has to be written in the ./FileTemplate/nameOfNode folder, including any necessary includes or defines.
