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

