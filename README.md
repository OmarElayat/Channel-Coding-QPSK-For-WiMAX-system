
**Phase 2 Top Module** 

**Ports:**



|**Signal**  |**In /Out**  |**Width** |**Description** |
| - | :- | - | - |
|Clk\_50mhz |In  |1 |Input clock to the block of frequency 50MHz |
|Data\_in |In  |1 |Input data |
|Ready\_in |In  |1 |Signal to identify that input is ready |
|Rst |In |1 |Reset |
|Valid\_out |In |1 |Signal to identify that output is valid |
|Q |Out |1 |Output data |
|I |Out |1 |Output data |
**Block Diagram:****  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.033.jpeg)

**RTL:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.034.jpeg)

1-  The data are processed in the four blocks 

2-  The output stream is valid and continuous as long as the input stream is ready and 

continuous. 

**Waveform:**  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.035.jpeg)

**Results:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.036.jpeg)

**PRBS** 

**Ports:**



|**Signal**  |**In /Out**  |**Width** |**Description** |
| - | :- | - | - |
|Clk\_50mhz |In  |1 |Input clock to the block of frequency 50MHz |
|rst |In  |1 |Reset |
|Ready\_in |In |1 |Signal to identify that input is ready |
|Data\_in |In |1 |Input data |
|Valid\_out |Out |1 |Signal to identify that output is valid |
|Data\_out |Out |1 |Output data |
**Block Diagram:****  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.002.png)

**Timing and functionality:** 

- The handshaking signals are in phase with the input data 
- No warmup cycles 
- Total timing of the block = n cycles. 

**RTL**: 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.003.png)

**Waveform**: 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.004.png)

**Results**: 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.005.jpeg)

**Modulator** 

**Ports:**



|**Signal**  |**In /Out**  |**Width** |**Description** |
| - | :- | - | - |
|Clk\_50mhz |In  |1 |Input clock to the block of frequency 50MHz |
|Clk\_100mhz |In  |1 |Input clock to the block of frequency 100MHz |
|rst |In  |1 |Reset |
|ready\_in |In |1 |Signal to identify that input is ready |
|Data\_in |In |1 |Input data |
|Valid\_out |Out |1 |Signal to identify that output is valid |
|Q |Out |16 |Output data Q |
|I |Out |16 |Output data  I |
**Block Diagram:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.006.png)

**Timing and functionality:** 

- Output frequency is double the input frequency. 
- Output bits and handshaking signals is late by two cycles (smaller clock frequency) due to the serialization of the input bits. 
- Thus, total timing of the block = n + 2 cycles, where n is the number of bits. 

**Wavefom:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.007.png)

**RTL** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.008.jpeg)

**Results:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.009.jpeg)

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.010.jpeg)

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.011.jpeg)

**Interleaver** 

**Ports:**



|**Signal**  |**In /Out**  |**Width** |**Description** |
| - | :- | - | - |
|Clk\_100mhz |In  |1 |Input clock to the block of frequency 100MHz |
|rst |In  |1 |Reset |
|Ready\_in |In |1 |Signal to identify that input is ready |
|Data\_in |In |1 |Input data |
|Valid\_out |Out |1 |Signal to identify that output is valid |
|Data\_out |Out |1 |Output data |
**Block Diagram:****  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.012.png)

**Timing and functionality** 

- The data are made parallel, then the wires were permuted and serialized 
- Delay of serialization = n, where n is the number of bits 
- Delay of interleaving = 0, it just wires re-ordering 
- Delay of serialization = 2, one cycle for loading and one cycle for shifting. Since, the input is parallel. Thus, there is no output warmup cycles wasted 
- Total delay of the block = n+2 

**Waveform:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.013.png)

**RTL:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.014.jpeg)

**1-  Parallelization** 

- Serial in Parallel output shift register 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.015.jpeg)

**2-  Permuting** 

- Simple rewiring between registers 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.016.jpeg)

**3-  Serializing** 

- Parallel in Serial shift register 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.017.jpeg)

**Results:** 

parallelizin Permuti Serializing  ![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.018.jpeg)![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.019.png)![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.020.png)![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.021.png)![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.022.png)![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.023.png)g   ng 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.024.jpeg)

**FEC** 

**Ports:**



|**Signal**  |**In /Out**  |**Width** |**Description** |
| - | :- | - | - |
|Clk\_50mhz |In  |1 |Input clock to the block of frequency 50MHz |
|Clk\_100mhz |In  |1 |Input clock to the block of frequency 100MHz |
|reset |In  |1 |Reset |
|Data\_in\_valid |In |1 |Signal to identify that input is ready |
|Data\_in |In |1 |Input data |
|Data\_out\_valid |Out |1 |Signal to identify that output is valid |
|Data\_out |Out |1 |Output data |
**Block Diagram:****  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.025.png)

**State Machine Diagram:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.026.png)

**RTL:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.027.jpeg)

**Memory interface:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.028.png)

**Timing and Functionality:** 

1-  The data are received and processed in parallel then saved in dual-port RAM. 

2-  The output data is extracted from RAM after receiving and processing all the input bits. 

**Waveform:**  

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.029.png)

**Results:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.030.jpeg)


**PLL** 

**Ports:**



|**Signal**  |**In /Out**  |**Description** |
| - | - | - |
|refclk |In  |Reference clock of frequency 50MHz |
|reset |In  |Reset |
|locked |Out  |Identifies when the signal is valid |
|Outclk\_0 |Out |Signal to identify that output is valid |
|Outclk\_1 |Out |Output data |
**Block Diagram:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.031.png)

**RTL:** 

![](Aspose.Words.0933408b-d74b-4d55-a19c-c0bbb332a315.032.png)

**Timing and Functionality:** 
