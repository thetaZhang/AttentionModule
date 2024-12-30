import random
import math
import subprocess
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

for i in range(test_num):
    Q = generate_matrix(8, 4, 9)
    K = generate_matrix(8, 4, 9)
    V = generate_matrix(8, 4, 9)

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

    attention_golden_model = Attention_golden_model(8,4,16)
    OUT=attention_golden_model.attention_compute(Q, K, V)

    print("Test data set", i+1)
    print("Golden model output:")
    for row in OUT:
        print(row)
    
    with open("./generate/OUT_data_model.txt", "w" if first_write_V else "a") as f:
        for num in V_vector:
            f.write(f"{num}\n")
    first_write_V = False  


result = subprocess.run(["cd rtl;vlog.exe -quiet testbench/top/top_tb.v;vsim.exe -quiet -c -voptargs=+acc +test_times=%d top_tb -do \"run -all\";cd .."% test_num], shell=True)



