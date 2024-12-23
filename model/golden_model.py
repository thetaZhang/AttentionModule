# self-attention golden model
import torch
import torch.nn as nn
import torch.nn.functional as func


class AttentionModule():
    
  def Attention(self, Q, K, V):

    scores = torch.matmul(Q, K.transpose(-2, -1))
    attention = func.softmax(scores, dim=-1)

    output = torch.matmul(attention, V)

    return output, attention
