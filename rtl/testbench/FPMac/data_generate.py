import random
import subprocess

# 生成随机的 16 位二进制数
data_1 = [format(random.randint(0, 2**10 - 1), '016b') for _ in range(4)]
data_2 = [format(random.randint(0, 2**10 - 1), '016b') for _ in range(4)]

print("data_1:", data_1)
print("data_2:", data_2)

with open("test_data1.txt", "w") as f:
    for num in data_1:
        f.write(f"{num}\n")

with open("test_data2.txt", "w") as f:
    for num in data_2:
        f.write(f"{num}\n")

F_data_1 = []
F_data_2 = []

for binary_str in data_1:
    # 拆分为 8 位整数部分和 8 位小数部分
    int_part = int(binary_str[:8], 2)
    frac_part = int(binary_str[8:], 2)
    
    # 将小数部分转换为浮点数
    float_value = int_part + frac_part / (2**8)
    
    # 存储到浮点数数组中
    F_data_1.append(float_value)

for binary_str in data_2:
    # 拆分为 8 位整数部分和 8 位小数部分
    int_part = int(binary_str[:8], 2)
    frac_part = int(binary_str[8:], 2)
    
    # 将小数部分转换为浮点数
    float_value = int_part + frac_part / (2**8)
    
    # 存储到浮点数数组中
    F_data_2.append(float_value)

print("FP_data_1:", F_data_1)
print("FP_data_2:", F_data_2)


fpout = 0

for i in range(4):
  fpout += F_data_1[i] * F_data_2[i]

print("fpout:", fpout)

result = subprocess.run(["iverilog -o tb.out FPMac_tb.v -I ../..; vvp -n tb.out"], shell=True)
