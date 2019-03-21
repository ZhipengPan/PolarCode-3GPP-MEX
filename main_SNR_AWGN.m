% polar encoder according to the 3GPP latest TSG version "GPP TS 38.212 V15.3.0 (2018-09)"
% 3rd Generation Partnership Project; Technical Specification Group Radio Access Network; NR;
% Multiplexing and channel coding (Release 15)
% panzhipeng18@hotmail.com,panzhipeng10@nudt.edu.cn
% copyright by Zhipeng Pan, National University of Defense Technology
% =====================================================
% polar encoder function:
% codewords = polar_encoder(a,A,E,CRC_size);
% a --> binary information bits, row vector;
% A --> length of the binary information bits, scalar number;
% E --> length of the binary codeword bits, scalar number;
% CRC_size --> 
%               0: No CRC, 
%               6: crc_polynomial_pattern = D^6 + D^5 + 1 
%              11: crc_polynomial_pattern = D^11 + D^10 + D^9 + D^5 + 1
%              16: crc_polynomial_pattern = D^16 + D^12 + D^5 + 1
%              24: crc_polynomial_pattern = D^24 + D^23 + D^21 + D^20 + D^17 + D^15 + D^13 + D^12 + D^8 + D^4 + D^2 + D + 1
% codewords --> returned codewords whose length is E;
%---------------------------------------------------------
% polar decoder function:
% a_hat = polar_decoder(LLR, A, E, L, min_sum,CRC_size);
% LLR --> soft information Logarithmic Likelihood Ratios (LLRS), 
%         each having a value obtained as LLR = ln(P(bit=0)/P(bit=1)
% A --> the length of the decoded information bits;
% E --> the length of the codeword bits;
% L --> List size of the SCL decoding algorithm
% CRC_size --> 
%               0: No CRC, 
%               6: crc_polynomial_pattern = D^6 + D^5 + 1 
%              11: crc_polynomial_pattern = D^11 + D^10 + D^9 + D^5 + 1
%              16: crc_polynomial_pattern = D^16 + D^12 + D^5 + 1
%              24: crc_polynomial_pattern = D^24 + D^23 + D^21 + D^20 + D^17 + D^15 + D^13 + D^12 + D^8 + D^4 + D^2 + D + 1
% a_hat --> returned decoded information bits whose length is A;
clear;
tic

A = 30;
E = 100;
CRC_size = 6;
M = 2;%modulation type
L = 4;
SNR = 0:1:10;
if M==2 %BPSK EsN0 = SNR-3(dB)
    EsN0 = SNR-3;
else
    EsN0 = SNR;
end
N0 = 1./10.^(EsN0/10); % Noise variance
switch (M)
    case 2
        constellation = [-1;1];
    case 4
        constellation = 1/sqrt(2)*[1 + 1i;1 - 1i;-1 + 1i;-1 - 1i];
    case 8
        constellation = 1/sqrt(6)*[-3 + 1i;-3 - 1i;-1 + 1i;-1 - 1i;
                                    3 + 1i; 3 - 1i; 1 + 1i; 1 - 1i];
    case 16
        constellation = 1/sqrt(10)*[-3 + 3i;-3 + 1i;-3 - 3i;-3 - 1i;
                                    -1 + 3i;-1 + 1i;-1 - 3i;-1 - 1i;
                                     3 + 3i; 3 + 1i; 3 - 3i; 3 - 1i;
                                     1 + 3i; 1 + 1i; 1 - 3i; 1 - 1i];
    otherwise
        constellation = [sqrt(2)/2 + 1i*sqrt(2)/2;-sqrt(2)/2 - 1i*sqrt(2)/2];
end

BER   = zeros(1, length(SNR));
BLER = zeros(1, length(SNR));
mento = 1e4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iter_snr = 1:length(SNR)
    
    ESC = 0;
    blk_err = 0;
    bit_err = 0;
    tic
    for ii = 1:mento
        a = randi([0 1],1,A); %source information bits 
        codewords = polar_encoder(a,A,E,CRC_size);
        symbols = constellation(codewords'+1);
        symbols = symbols.';
        ESC = ESC+mean(mean(symbols.*conj(symbols)));%统计空口中每个符号能量，应当归一化为1
        noise = sqrt(N0(iter_snr)/2)*randn(1,E);
        y = symbols + noise;
        LLR = -4*y/N0;
        a_hat = polar_decoder(LLR, A, E, L ,CRC_size);
        bit_err = bit_err+sum(a_hat~=a);
        if sum(a_hat~=a)>0
            blk_err = blk_err + 1;
        end
        if( bit_err>500&&ii*A>1e4 || ii*A > 1e7) 
            break;
        end
    end
    toc
    disp([' Average symbol energy (Es) = ',num2str(ESC/(ii))]);
    BER(iter_snr) = bit_err/(ii*A);
    BLER(iter_snr) = blk_err/(ii);
    disp(['SNR = ',num2str(SNR(iter_snr)),'dB','   BER = ',num2str(BER(iter_snr)),'    BLER = ',num2str(BLER(iter_snr))]);
    if (BER(iter_snr) < 1e-5)
        break;
    end
    toc
end


semilogy(SNR(1:iter_snr),BER(1:iter_snr),'r-o','LineWidth',1 );
hold on;
semilogy(SNR(1:iter_snr),BLER(1:iter_snr),'b-s' );
xlabel('SNR');
ylabel('BER,BLER');
title(['polar code (',num2str(E), ',', num2str(A),') AWGN Channel']);
legend('BER','BLER');
grid on;
