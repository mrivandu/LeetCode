# -*- coding:utf-8 -*-
import os

configuration = r'H:\automatic-ops\oasr\Offline_System_Client\conf\cfg.ini'

env = []
ini = []

for line in open(configuration, 'r', encoding='utf-8'):
    if '=' in line and not line.startswith('#'):
        var = line.split('=')
        env.append('    '+var[0].upper().replace(".","_")+'='+'"'+var[1].strip()+'" \\'+'\n')
        var[1] = "${"+var[0].upper().replace(".","_")+"}\n"
        ini.append(var[0] + '=' + var[1])
    else:
        ini.append(line)

env[len(env)-1] = env[len(env)-1][:-3]

with open('env.conf','w',encoding='utf-8') as ob:
    ob.writelines(env)
    print("The path of environment variable file is:" + os.path.join(os.getcwd(), 'env.conf'))

with open('ini.conf','w',encoding='utf-8') as ob:
    ob.writelines(ini)
    print("The path of configuration file is:" + os.path.join(os.getcwd(), 'env.conf'))