# PolarCode-3GPP-MEX

This code is realized by C programming language, which transformed into the mex function to be called by matlab script.

The Polar encoder and Polad decoder function follows the standard of the 3GPP latest TSG version "3GPP TS 38.212 V15.3.0 (2018-09), Multiplexing and channel coding (Release 15)" 

https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3214

Copyright: Zhipeng Pan, National University of Defense Technology



## polar encoder function:
codewords = polar_encoder(a,A,E,CRC_size);

a --> binary information bits, row vector;

A --> length of the binary information bits, scalar number;

E --> length of the binary codeword bits, scalar number;


CRC_size --> 

Value  | crc_polynomial_pattern
-----|---
0   | No CRC
6   | D^6 + D^5 + 1
11  | D^11 + D^10 + D^9 + D^5 + 1
16  | D^16 + D^12 + D^5 + 1
24  | D^24 + D^23 + D^21 + D^20 + D^17 + D^15 + D^13 + D^12 
`    | + D^8 + D^4 + D^2 + D + 1

codewords --> returned codewords whose length is E;

***Note: A + CRC_size <= E***


## polar decoder function:

a_hat = polar_decoder(LLR, A, E, L, min_sum,CRC_size);

LLR --> soft information Logarithmic Likelihood Ratios (LLRS), 
         each having a value obtained as LLR = ln(P(bit=0)/P(bit=1)
         
A --> the length of the decoded information bits;

E --> the length of the codeword bits;

L --> List size of the SCL decoding algorithm

CRC_size --> 

Value  | crc_polynomial_pattern
-----|---
0   | No CRC
6   | D^6 + D^5 + 1
11  | D^11 + D^10 + D^9 + D^5 + 1
16  | D^16 + D^12 + D^5 + 1
24  | D^24 + D^23 + D^21 + D^20 + D^17 + D^15 + D^13 + D^12 
`    | + D^8 + D^4 + D^2 + D + 1
             
a_hat --> returned decoded information bits whose length is A;


## Result


![image](https://github.com/ZhipengPan/PolarCode-3GPP-MEX/blob/master/result/polar(100%2C30)_AWGN_SNR.png)




## Author:
Zhipeng Pan

Changsha, Hunan

Email: panzhipeng18@hotmail.com,panzhipeng10@nudt.edu.cn