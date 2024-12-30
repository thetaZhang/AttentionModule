import random
import subprocess
import math

# 生成一个 4x4 的 16 位二进制矩阵
def generate_matrix(rows, cols, bit_width):
    return [[format(random.randint(0, 2**bit_width - 1), f'0{bit_width}b') for _ in range(cols)] for _ in range(rows)]

# 展平矩阵为向量
def flatten_matrix(matrix):
    return [bit for row in matrix for bit in row]

# 将定点数转换为浮点数
def fixed_point_to_float(binary_str):
    int_part = int(binary_str[:-8], 2)
    frac_part = int(binary_str[-8:], 2)
    return int_part + frac_part / (2**8)

# 矩阵乘法
def matrix_multiply(matrix_a, matrix_b):
    result = [[0.0 for _ in range(len(matrix_b[0]))] for _ in range(len(matrix_a))]
    for i in range(len(matrix_a)):
        for j in range(len(matrix_b[0])):
            for k in range(len(matrix_b)):
                result[i][j] += matrix_a[i][k] * matrix_b[k][j]
    return result

def fixed_point_quantization(float_num,int_bit,frac_bit):
  if float_num > (2**(int_bit+frac_bit-1)/2**frac_bit):
    return 2**(int_bit+frac_bit)-1
  elif math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit > (2**(int_bit+frac_bit-1)/2**frac_bit):
    return 2**(int_bit+frac_bit)-1
  else :
    return math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit
# 生成两个 4x4 的 16 位二进制矩阵
matrix_1 = generate_matrix(4, 4, 10)
matrix_2 = generate_matrix(4, 2, 10)

# 展平矩阵为向量
vector_1 = flatten_matrix(matrix_1)
vector_2 = flatten_matrix(matrix_2)

print("Matrix 1:")
for row in matrix_1:
    print(row)

print("\nMatrix 2:")
for row in matrix_2:
    print(row)

#print("\nFlattened Vector 1:", vector_1)
#print("Flattened Vector 2:", vector_2)

# 将数据写入文件
with open("test_data1.txt", "w") as f:
    for num in vector_1:
        f.write(f"{num}\n")

with open("test_data2.txt", "w") as f:
    for num in vector_2:
        f.write(f"{num}\n")

float_matrix_1 = [[fixed_point_to_float(bit) for bit in row] for row in matrix_1]
float_matrix_2 = [[fixed_point_to_float(bit) for bit in row] for row in matrix_2]

print("\nFloat Matrix 1:")
for row in float_matrix_1:
    print(row)

print("\nFloat Matrix 2:")
for row in float_matrix_2:
    print(row)


# 计算两个矩阵的乘积
mat_matrix = matrix_multiply(float_matrix_1, float_matrix_2)

print("\nMatrix Multiplication:")
for row in mat_matrix:
    print(row)

result_matrix = [[fixed_point_quantization(bit, 8, 8) for bit in row] for row in mat_matrix]

print("\nResult Matrix:")
for row in result_matrix:
    print(row)

result = subprocess.run(["iverilog -o tb.out FPMatMul_tb.v -I ../..; vvp -n tb.out"], shell=True)
