import random
import math
import subprocess
import platform
from golden_model import Attention_golden_model

def generate_matrix(rows, cols, bit_width):
    """
    generate q, k, v matrix with random values in binary
    """
    return [[format(random.randint(0, 2**bit_width - 1), f'0{bit_width}b') for _ in range(cols)] for _ in range(rows)]

first_write_Q= True
first_write_K = True
first_write_V = True

print("Test Attention model")
print("Please enter the number of test data sets:")
test_num = int(input())

print("Type 1 to use the default input data range, type 2 to customize the input data range.")

if int(input()) == 1:
    Q_range = 9
    K_range = 9
    V_range = 9
else:
    print("Please enter the data bit range for the Q matrix(1~16):")
    Q_range = min(int(input()), 16)
    print("Please enter the data bit range for the K matrix(1~16):")
    K_range = min(int(input()), 16)
    print("Please enter the data bit range for the V matrix(1~16):")
    V_range = min(int(input()), 16)

Q_testset = [generate_matrix(8, 4, Q_range ) for _ in range(test_num)]
K_testset = [generate_matrix(8, 4, K_range ) for _ in range(test_num)]
V_testset = [generate_matrix(8, 4, V_range ) for _ in range(test_num)]

for i in range(test_num):
    Q = Q_testset[i]
    K = K_testset[i]
    V = V_testset[i]

    Q_vector = [bit for row in Q for bit in row]
    K_vector = [bit for row in K for bit in row]
    V_vector = [bit for row in V for bit in row]

    with open("./rtl/testbench/top/Q_data.txt", "w" if first_write_Q else "a") as f:
        for num in Q_vector:
            f.write(f"{num}\n")
    first_write_Q = False 


    with open("./rtl/testbench/top/K_data.txt", "w" if first_write_K else "a") as f:
        for num in K_vector:
           f.write(f"{num}\n")
    first_write_K = False 


    with open("./rtl/testbench/top/V_data.txt", "w" if first_write_V else "a") as f:
        for num in V_vector:
            f.write(f"{num}\n")
    first_write_V = False  


current_platform = platform.system()

if current_platform == "Windows":
    result = subprocess.run(['powershell', '-Command', "cd ./rtl;vlog.exe -quiet testbench/top/top_tb.v *.v;vsim.exe -quiet -c -voptargs=+acc +test_times=%d top_tb -do \"run -all\";cd .."% test_num], shell=True)
elif current_platform == "Linux":
    result = subprocess.run(["cd rtl;vlog.exe -quiet testbench/top/top_tb.v *.v;vsim.exe -quiet -c -voptargs=+acc +test_times=%d top_tb -do \"run -all\";cd .."% test_num], shell=True)
else:
    print(f"Unsupported platform: {current_platform}")




print("start golden model verification")


with open("./generate/OUT_data_module_float.txt", 'r') as f:
    lines = f.readlines()

out = [float(line.strip()) for line in lines]

OUT_testset = []
for n in range(test_num):
    matrix = []
    for i in range(8):
        row = out[n * 8 * 4 + i * 4 : n * 8 * 4 + (i + 1) * 4]
        matrix.append(row)
    OUT_testset.append(matrix)

flag = True
oversize_flag = False

for i in range(test_num):

    attention_golden_model = Attention_golden_model(8,4,16)
    OUT=attention_golden_model.attention_compute(Q_testset[i], K_testset[i], V_testset[i])

    print("Test data set", i+1)

    print("Golden model output:")
    for row in OUT:
        print(row)

    print("Module output:")
    for row in OUT_testset[i]:
        print(row)
    
    if OUT == OUT_testset[i]:
        print("Test passed")
    else:
        print("Test failed")
        flag = False
    
    if all(x == 0.0 for row in OUT_testset[i] for x in row):
        oversize_flag = True

if flag:
    print("All tests passed")

    
if oversize_flag:
    print("Your input is too big!")
    print("Too big input make too much data overflow and make all the output saturated")
    print("All saturated output will be the same")
    print("Same output will be 0 after simplified softmax")
    print("Please try smaller input")


