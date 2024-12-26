import random
import subprocess


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

def softmax_simple(x):
  def softmax_simple_row(row):
    return [(i-min(row))*(i-min(row)) for i in row]

  return [softmax_simple_row(row) for row in x]


#转置
def transpose_matrix(matrix):
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]



matrix_Q = generate_matrix(8, 4, 9)
matrix_K = generate_matrix(8, 4, 9)
matrix_V = generate_matrix(8, 4, 9)

# 展平矩阵为向量
vector_Q = flatten_matrix(matrix_Q)
vector_K = flatten_matrix(matrix_K)
vector_V = flatten_matrix(matrix_V)


#print("\nFlattened Vector 1:", vector_1)
#print("Flattened Vector 2:", vector_2)

# 将数据写入文件
with open("./testbench/top/Q_data.txt", "w") as f:
    for num in vector_Q :
        f.write(f"{num}\n")

with open("./testbench/top/K_data.txt", "w") as f:
    for num in vector_K :
        f.write(f"{num}\n")

with open("./testbench/top/V_data.txt", "w") as f:
    for num in vector_V :
        f.write(f"{num}\n")



float_matrix_Q = [[fixed_point_to_float(bit) for bit in row] for row in matrix_Q]
float_matrix_K = [[fixed_point_to_float(bit) for bit in row] for row in matrix_K]
float_matrix_V = [[fixed_point_to_float(bit) for bit in row] for row in matrix_V]


#print("\nFloat Matrix Q:")
#for row in float_matrix_Q:
#    print(row)

A_matrix = matrix_multiply(float_matrix_Q, transpose_matrix(float_matrix_K))
S_matrix = softmax_simple(A_matrix)

output_matrix = matrix_multiply(S_matrix, float_matrix_V)

print("\nFloat Matrix A:")
for row in A_matrix:
    print(row)

print("\nFloat Matrix S:")
for row in S_matrix:
    print(row)

print("\nFloat Matrix Output:")
for row in output_matrix:
    print(row)


result = subprocess.run(["vlog.exe testbench/top/top_tb.v;vsim.exe -c -voptargs=+acc top_tb -do \"run -all\""], shell=True)


print("\nFloat Matrix Output:")
for row in output_matrix:
    print(row)
