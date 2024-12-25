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

#转置
def transpose_matrix(matrix):
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]


# 生成两个 4x4 的 16 位二进制矩阵
matrix_1 = generate_matrix(4, 8, 4)


# 展平矩阵为向量
vector_1 = flatten_matrix(matrix_1)


print("Matrix 1:")
for row in matrix_1:
    print(row)


#print("\nFlattened Vector 1:", vector_1)
#print("Flattened Vector 2:", vector_2)

# 将数据写入文件
with open("test_data1.txt", "w") as f:
    for num in vector_1:
        f.write(f"{num}\n")

transposed_matrix = transpose_matrix(matrix_1)

print("transposed_matrix:")
for row in transposed_matrix:
    print(row)



result = subprocess.run(["iverilog -o tb.out Transpose_tb.v -I ../..; vvp -n tb.out"], shell=True,capture_output=True, text=True)

print(result.stdout)
