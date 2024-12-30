import random
import subprocess
import math

from golden_model import Attention_golden_model

# 生成一个 4x4 的 16 位二进制矩阵
def generate_matrix(rows, cols, bit_width):
    return [[format(random.randint(0, 2**bit_width - 1), f'0{bit_width}b') for _ in range(cols)] for _ in range(rows)]

# 展平矩阵为向量
def flatten_matrix(matrix):
    return [bit for row in matrix for bit in row]

def fixed_point_to_float(binary_str,frac_bits=8):
    """
    convert fixed point binary to float
    """
    if len(binary_str) <= frac_bits:
        int_part = 0
        frac_part = int(binary_str, 2)
    else:
        int_part = int(binary_str[:-frac_bits], 2)
        frac_part = int(binary_str[-frac_bits:], 2)
    return int_part + frac_part / (2** frac_bits)

def fixed_point_quantization(float_num,int_bit,frac_bit):
    """
    quantize float number to fixed point, the same way as in verilog
    """
    if float_num > (2**(int_bit+frac_bit-1)/2**frac_bit):
        return (2**(int_bit+frac_bit)-1)/2**frac_bit
    elif math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit > (2**(int_bit+frac_bit-1)/2**frac_bit):
        return (2**(int_bit+frac_bit)-1)/2**frac_bit
    else :
        return math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit

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



matrix_Q = generate_matrix(8, 4, 11)
matrix_K = generate_matrix(8, 4, 11)
matrix_V = generate_matrix(8, 4, 11)

# 展平矩阵为向量
vector_Q = flatten_matrix(matrix_Q)
vector_K = flatten_matrix(matrix_K)
vector_V = flatten_matrix(matrix_V)


#print("\nFlattened Vector 1:", vector_1)
#print("Flattened Vector 2:", vector_2)





float_matrix_Q = [[fixed_point_to_float(bit) for bit in row] for row in matrix_Q]
float_matrix_K = [[fixed_point_to_float(bit) for bit in row] for row in matrix_K]
float_matrix_V = [[fixed_point_to_float(bit) for bit in row] for row in matrix_V]


#print("\nFloat Matrix Q:")
#for row in float_matrix_Q:
#    print(row)

A1_matrix = matrix_multiply(float_matrix_Q, transpose_matrix(float_matrix_K))
A_matrix = [[fixed_point_quantization(bit, 8, 8) for bit in row] for row in A1_matrix]

S1_matrix = softmax_simple(A_matrix)
S_matrix = [[fixed_point_quantization(bit, 8, 8) for bit in row] for row in S1_matrix]

output1_matrix = matrix_multiply(S_matrix, float_matrix_V)
output_matrix = [[fixed_point_quantization(bit, 8, 8) for bit in row] for row in output1_matrix]

print("\nFloat Matrix A:")
for row in A_matrix:
    print(row)

print("\nFloat Matrix S:")
for row in S_matrix:
    print(row)

print("\nFloat Matrix Output:")
for row in output_matrix:
    print(row)


#result = subprocess.run(["vlog.exe -quiet testbench/top/top_tb.v;vsim.exe -quiet -c -voptargs=+acc +test_times=1 top_tb -do \"run -all\""], shell=True)


golden_model = Attention_golden_model()

new_out=golden_model.attention_compute(matrix_Q, matrix_K, matrix_V)

print("\nnew Float Matrix Output:")
for row in new_out:
    print(row)

print(new_out == output_matrix)
