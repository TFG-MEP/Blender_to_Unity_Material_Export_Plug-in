from .meta_generator import *
import shutil
def generate_textures(path, imagesMap):
    """Iterates through the images used in tyhe blender Material.
    
    Args:
        path (str): Path where the images will be copied.
        imagesMap (dict): Dictionary mapping image paths to node names.

    Returns:
        dict: Dictionary mapping node names to image GUIDs.
    """
     
    imageVariables = {}
    for image_path, node_names in imagesMap.items():
        # Copy image to the path
        shutil.copy(image_path, path)
        image_name = os.path.basename(image_path)
        image_name, extension = os.path.splitext(image_name)
        # Generate .Meta of the image
        image_guid=generate_meta_file('FileTemplates/template.image.meta',path,image_name,extension)
        # Saving the names and guid for the Material
        for variable in node_names:
            imageVariables[variable] = image_guid
    
    return imageVariables

     