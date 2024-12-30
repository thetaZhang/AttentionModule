import torch
import random
import math
from functools import partial

class Attention_golden_model:
    def __init__(self, token_dim=4, token_num=8, data_width=16):
        """
        init Attention golden model

        Args:
        token_dim: the dimension of token
        token_num: the number of token
        data_width: the data width in fixed point, half for integer part, half for fraction part
        """
        self.token_dim = token_dim
        self.token_num = token_num
        self.data_width = data_width

    def __fixed_point_to_float__(self,binary_str,frac_bits=8):
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

    def __fixed_point_quantization__(self,float_num,*y):
        """
        quantize float number to fixed point, the same way as in verilog
        """
        int_bit = self.data_width/2
        frac_bit = self.data_width/2
        if float_num > (2**(int_bit+frac_bit-1)/2**frac_bit):
            return 2**(int_bit+frac_bit)-1
        elif math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit > (2**(int_bit+frac_bit-1)/2**frac_bit):
            return 2**(int_bit+frac_bit)-1
        else :
            return math.floor(float_num*(2**frac_bit)+0.5) /2**frac_bit

    def __softmax_simple__(self,x):
        """
        simpl softmax function 
        """
        def softmax_simple_row(row):
            return (row - torch.min(row)) ** 2
        return torch.stack([softmax_simple_row(row) for row in x])

    def attention_compute(self, matrix_Q, matrix_K, matrix_V):
        """
        compute attention

        Args:
        matrix_Q: input Q matrix
        matrix_K: input K matrix
        matrix_V: input V matrix

        Returns:

        """
        matrix_Q_tensor = torch.tensor([[self.__fixed_point_to_float__(bit) for bit in row] for row in matrix_Q],dtype=torch.float64)
        matrix_K_tensor = torch.tensor([[self.__fixed_point_to_float__(bit) for bit in row] for row in matrix_K],dtype=torch.float64)
        matrix_V_tensor = torch.tensor([[self.__fixed_point_to_float__(bit) for bit in row] for row in matrix_V],dtype=torch.float64)

        quantization = partial(self.__fixed_point_quantization__)
  

        # matrix multiplication Q*K^T and quantization
        matrix_A_tensor = torch.matmul(matrix_Q_tensor, matrix_K_tensor.transpose(-2,1));
        matrix_A_tensor.map_(matrix_A_tensor,quantization);

        # softmax and quantization
        matrix_S_tensor = self.__softmax_simple__(matrix_A_tensor)
        matrix_S_tensor.map_(matrix_S_tensor,quantization);

        # matrix multiplication S*V and quantization
        matrix_O_tensor = torch.matmul(matrix_S_tensor, matrix_V_tensor);
        matrix_O_tensor.map_(matrix_O_tensor,quantization);
        
        return matrix_O_tensor.tolist()







