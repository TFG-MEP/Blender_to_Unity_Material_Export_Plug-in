from setuptools import setup, find_packages

setup(
    name='Blender_to_Unity_Material_Export_Plug-in',
    version='1.0.0',
    description='Blender example distutils',
    long_description='Una descripción más detallada de tu paquete',
    url='https://github.com/TFG-MEP/Blender_to_Unity_Material_Export_Plug-in',
    author='Miriam Martín Sánchez, Paula Morillas Alonso, Elisa Todd Rodríguez',
    author_email='',
    license='',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: End Users/Desktop',
        'Topic :: Multimedia :: Graphics :: 3D Modeling',
        'Topic :: Multimedia :: Graphics :: 3D Rendering',
        'Programming Language :: Python :: 3 :: Only'
    ],
    packages=find_packages(),
    keywords='blender',

    # Here are listed first level dependencies needed by the module. Themselves
    # may require dependencies. The actual modules to be shipped with the addon
    # are cherry picked in setup.cfg
    install_requires=['jinja2', 'xxhash']
)


