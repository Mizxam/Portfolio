## MAVD + OVERFLOW
## AutoEdit for mtl FILES!!!

import os
from os import listdir
from os.path import isfile, join

path = os.path.dirname(os.path.abspath(__file__))
files = [f for f in listdir(path) if isfile(join(path, f))]

def remove_prefix(prefix:str, extention = 'ignore') -> None:
	global files
	if extention != 'ignore':
		print(extention)
		files = [file for file in files if file.endswith(extention)]
		print(files)
	plg = len(prefix)
	for i,file in enumerate(files):
		if file.startswith(prefix):
			c_new_name = file[plg:]
			cache = 0
			for c in c_new_name:
				if c.isalpha():
					break
				else:
					cache += 1
			new_name = c_new_name[cache:]
			file_path = path + '/' + file
			newfile_path = path + '/' + new_name
			
			## DUBUG PORPUSES
			#print(file_path)
			
			print(i,newfile_path)
			os.rename(file_path, newfile_path)

def change_material(material:str) -> None:
	for mtl_file in mtl_files:	
		c_data = [] ## current data
		with open(mtl_file, 'r') as file:
			c_data = file.readlines()
			#data.append(file.readlines())
			file.close()
		
		for i,line in enumerate(c_data):
			#print(i,line)
			if i == 7:
				c_data[i] = material 
		
		#c_data[7] = "map_Kd palette.png" ## IDK WHY THIS DOESN'T WORK!!!
		with open(mtl_file, 'w') as file:
			file.writelines(c_data)

## -- ## Start ## -- ##

remove_prefix("Cosa",".obj")

files = [f for f in listdir(path) if isfile(join(path, f))]
mtl_files = [mtl_file for mtl_file in files if mtl_file.endswith('.mtl')]

change_material("map_Kd palette.png")

