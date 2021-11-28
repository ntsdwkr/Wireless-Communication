% BER of AWGN channels for BPSK
clc; 
clear; 
close all; 
clf;

%% 
SNR_DB    = -5:2:14;           % SNR in dB.
SNR       = 10.^(0.1*SNR_DB);  % linear SNR.
NBits     = 1e8;               % number of samples
Pow_BPSK  = 1;

% Generate BPSK signal, +1,-1
% Input_bits = round(rand(1,NBits));  % generate 0's and 1's randomly
Input_bits = randi([0 1],1,NBits);    % generate 0's and 1's randomly
BPSK_signal = 2*Input_bits-1;         % generate BPSK signals
%% AWGN Channel
for snr = 1:length(SNR_DB)
    Noise_var = Pow_BPSK/SNR(snr);
    Noise     = sqrt(Noise_var)*(randn(1,NBits));
    Received_signal = BPSK_signal + Noise;
    for b=1:NBits
        if Received_signal(b) > 0 % threshold
            Detect_sig(b) = 1;
        else
            Detect_sig(b) = -1;
        end
    end

    Err_count = sum(Detect_sig ~= BPSK_signal); % sum of incorrect received bits
    BER_BPSK(snr)=Err_count/NBits;
end

%%
figure(1);
semilogy(SNR_DB,BER_BPSK,'r','LineWidth',2);
title('BER of BPSK in AWGN CHANNEL');
xlabel('SNR(dB)');
ylabel('BER');
hold on;
grid on;
BER_BPSK_Theoretical = qfunc(sqrt(SNR));    
semilogy(SNR_DB,BER_BPSK_Theoretical,'bo','LineWidth',2);
hold off;
legend('Simulation','Theoretical')
%%

