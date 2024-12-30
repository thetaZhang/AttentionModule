import math
import torch

class Quantizer:
    def __init__(self, data_width):
        self.data_width = data_width

    def __fixed_point_quantization__(self, float_num,*y):
        """
        quantize float number to fixed point, the same way as in verilog
        """
        int_bit = self.data_width / 2
        frac_bit = self.data_width / 2
        if float_num > (2**(int_bit + frac_bit - 1) / 2**frac_bit):
            return 2**(int_bit + frac_bit) - 1
        elif math.floor(float_num * (2**frac_bit) + 0.5) / 2**frac_bit > (2**(int_bit + frac_bit - 1) / 2**frac_bit):
            return 2**(int_bit + frac_bit) - 1
        else:
            return math.floor(float_num * (2**frac_bit) + 0.5) / 2**frac_bit

quantizer = Quantizer(data_width=16)

torch.set_printoptions(precision=10)
# 示例浮点数
float_num = torch.rand(3,3,dtype=torch.float64)

print(float_num)
print(float_num.dtype)

float_num.map_(float_num, quantizer.__fixed_point_quantization__)

print(float_num)
print(float_num.dtype)
