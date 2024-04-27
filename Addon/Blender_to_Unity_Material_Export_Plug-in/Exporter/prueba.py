
# strings = [
#     "Type:Mesh->Suzanne0",
# ]

# for s in strings:
#     buffer = s.encode('utf-8')  # Convertir la cadena a bytes en UTF-8
#     hash_result = xxhash.xxh64(buffer, seed=0).intdigest()
#     print(f"{s} = {hash_result}")


try:

    import ctypes

    # Carga la DLL
    xxhash_lib = ctypes.WinDLL("./XxHashLibrary.dll")

    # Define la firma de la función XxHash64
    xxhash_lib.XxHash64.restype = ctypes.c_int  # Define el tipo de retorno de la función

    # Llama a la función XxHash64
    result = xxhash_lib.XxHash64()
    print(result)

except Exception as e:
    print("An error occurred:", e)

# try : 
#     import clr
#     clr.AddReference("./XxHashLibrary.dll")
#     from XxHashLibrary import XxHashLibrary

#     obj = XxHashLibrary()
#     result = obj.XxHash64()
#     print(result)

# except Exception as e:
#     print("An error occurred:", e)
