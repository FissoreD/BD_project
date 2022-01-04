import os

order = [
    (
        '/*\n\t2.1 LES TYPES\n*/\n',
        'ProjetBDtypes.sql'
    ),
    (
        '/*\n\t2.2.1 LES TABLES\n*/\n',
        'ProjetBDtables.sql'
    ),
    (
        '/*\n\t2.2.2 LES INDEX\n*/\n',
        'ProjetBDindex.sql'
    ),
    (
        '/*\n\t2.X LES TRIGGERS\n*/\n',
        'ProjetBDtrigger.sql'
    ),
    (
        '/*\n\t2.5 LES INMPLEMENTATIONS DES METHODES\n*/\n',
        'ProjetBDimplem.sql'
    ),
    (
        '/*\n\t2.3 LES INSERT\n*/\n',
        'ProjetBDinsert.sql'
    ),
    (
        '/*\n\t2.4 LES REQUETES\n*/\n',
        'ProjetBDrequetes.sql'
    ),
    (
        '/*\n\t2.X OTHER\n*/\n',
        'ProjetBDdeclare.sql'
    ), ]
res_folder = 'Rendu'
if not os.path.exists(res_folder):
    os.mkdir(res_folder)
with open(
        os.path.join(res_folder, '3Script_Implementation_type_tables_objet_BERNIGAUD_FISSORE_VENTURELLI.sql'), 'w') as out:
    for a, b in order:
        out.write(a)
        with open(b) as inp:
            out.write(inp.read())
        out.write('\n')
