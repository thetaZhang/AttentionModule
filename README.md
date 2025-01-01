# AttentionModule

A simple attention module of Verilog. It takes QKV matrix inputs and outputs the attention computation results.

The default number of tokens is 8, with a dimension of 4. The default data type is fixed-point with 8-bit integers and 8-bit fractions, and quantization is performed during the attention computation.

A pipelined structure is adopted. The QK^T matrix multiplication, softmax, and SV matrix multiplication are each treated as a pipeline stage. Each set of inputs produces results after three cycles.

## Run Simulation

### Dependencies

Modelsim 2019.2 should be added to the system environment variables PATH.

Python 3 with pytorch is also needed for the model verifiction.

### Run simulation script

Make sure you are at the project root directory.

Run the following command to invoke Modelsim to run the module simulation and verify  through Python golden model.

```
python ./model/model_test.py
```

It can generate random data and automatically compare the simulation and model verification results. The output data is located in the generate directory.

## directory structure

```
.
├── README.md
├── generate
├── model
│   ├── golden_model.py
│   ├── model_test.py
├── report
└── rtl
    ├── Attention_top.v
    ├── AttnSoftmax.v
    ├── Dff.v
    ├── FPMac.v
    ├── FPMatMul.v
    ├── MatSoftmax.v
    ├── Min.v
    ├── QKMatMul.v
    ├── Quantization.v
    ├── SVMatMul.v
    ├── Softmax.v
    ├── Transpose.v
    ├── modelsim.ini
    └── testbench
 
```

The verilog module source code is in the `rtl` folder, and the python golden model source code is in the `model` folder.
