import os
path_to_java = 'Rendu\JavaJDBC\src\main\java\sql3'

res_folder = 'Rendu'

if not os.path.exists(res_folder):
    os.mkdir(res_folder)
with open(
        os.path.join(res_folder, '4Script_Mapping_objet_Relationnel_avec_Jdbc_BERNIGAUD_FISSORE_VENTURELLI.sql'), 'w') as out:
    files = os.listdir(path_to_java)
    files.remove('Main.java')
    files.insert(0, 'Main.java')
    for f in files:
        with open(os.path.join(path_to_java, f)) as inp:
            out.write(f"\n/*\n\tThe {f} file\n*/\n")
            out.write(inp.read())
        out.write('\n')
