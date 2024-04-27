
# strings = [
#     "Type:Mesh->Suzanne0",
# ]

# for s in strings:
#     buffer = s.encode('utf-8')  # Convertir la cadena a bytes en UTF-8
#     hash_result = xxhash.xxh64(buffer, seed=0).intdigest()
#     print(f"{s} = {hash_result}")


# try:

#     import ctypes

#     # Carga la DLL
#     xxhash_lib = ctypes.WinDLL("./XxHashLibrary.dll")

#     # Define la firma de la función XxHash64
#     xxhash_lib.XxHash64.restype = ctypes.c_int  # Define el tipo de retorno de la función

#     # Llama a la función XxHash64
#     result = xxhash_lib.XxHash64()
#     print(result)

# except Exception as e:
#     print("An error occurred:", e)

# try : 
#     import clr
#     clr.AddReference("./Exporter/XxHashLibrary.dll")
#     from XxHashLibrary import XxHashLibrary

#     obj = XxHashLibrary()
#     result = obj.XxHash64()
#     print(result)

# except Exception as e:
#     print("An error occurred:", e)
import clr
import sys

assemblypath = r"C:\Users\miria\OneDrive\Documentos\UNIVERSIDAD\4º\TFG\TFG\Addon\Blender_to_Unity_Material_Export_Plug-in\Exporter\XxHashLibrary.dll"
clr.FindAssembly("System.Runtime")
clr.AddReference("System.Runtime")
clr.FindAssembly(assemblypath)
clr.AddReference(assemblypath)

from System.Text import Encoding
from HashDepot import XXHash

s = "Type:Mesh->Suzanne0"
buffer = Encoding.UTF8.GetBytes(s)
result = XXHash.Hash64(buffer, 0)
print(f"{s} = {result}")

##