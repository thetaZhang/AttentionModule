import subprocess
import platform

current_platform = platform.system()

if current_platform == "Windows":
    result = subprocess.run(['powershell', '-Command', 'mkdir generate;ni generate/OUT_data_module_binary.txt;ni generate/OUT_data_module_float.txt;cd ./rtl;vlib.exe work;vmap.exe work work; cd ..'], shell=True)
elif current_platform == "Linux":
    result = subprocess.run(["mkdir generate;touch generate/OUT_data_module_binary.txt generate/OUT_data_module_float.txt;cd rtl;vlib.exe work;vmap.exe work work;cd .. "], shell=True)
else:
    print(f"Unsupported platform: {current_platform}")


