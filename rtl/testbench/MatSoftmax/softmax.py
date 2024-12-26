import torch
import random
import math

def softmax_torch(x):
  x_tensor = torch.tensor(x)
  res_tensor = torch.nn.functional.softmax(x_tensor, dim=-1)
  return res_tensor.tolist()

def softmax_list(x):
    def softmax_row(row):
        exp_row = [math.exp(i) for i in row]
        sum_exp_row = sum(exp_row)
        return [i / sum_exp_row for i in exp_row]
    
    return [softmax_row(row) for row in x]

def softmax_simple(x):
  def softmax_simple_row(row):
    return [(i-min(row))*(i-min(row)) for i in row]

  return [softmax_simple_row(row) for row in x]

def generate_matrix(rows, cols, bit_width):
    return [[format(random.randint(0, 2**bit_width - 1), f'0{bit_width}b') for _ in range(cols)] for _ in range(rows)]


# 将定点数转换为浮点数
def fixed_point_to_float(binary_str):
    int_part = int(binary_str[:-8], 2)
    frac_part = int(binary_str[-8:], 2)
    return int_part + frac_part / (2**8)


matrix_1 = generate_matrix(8, 8, 10)


matrix = [[round(fixed_point_to_float(bit), 4)  for bit in row] for row in matrix_1]

print("Matrix:", matrix)
print("Softmax_torch:", softmax_torch(matrix))
print("Softmax_list:", softmax_list(matrix))
print("Softmax_simple:", softmax_simple(matrix))


