clear;
close all;
clc;

% QPSK BER Simulation
N = 1e5; % no of samples
inputBits = randi([0 1], 1, N); % random 1's and 0's
transSymbls = []; % empty array of transmitted symbols

for i = 1:2:length(inputBits)
    if inputBits(i) == 0 && inputBits(i+1) ==0
        transSymbl = cosd(225) + sqrt(-1)*sind(225);
    elseif inputBits(i) == 0 && inputBits(i+1) ==1
        transSymbl = cosd(135) + sqrt(-1)*sind(135);
    elseif inputBits(i) == 1 && inputBits(i+1) ==1
        transSymbl = cosd(45) + sqrt(-1)*sind(45);
    elseif inputBits(i) == 1 && inputBits(i+1) ==0
        transSymbl = cosd(-45) + sqrt(-1)*sind(-45);
    end
    transSymbls = [transSymbls transSymbl]; % array of transmitted symbols
end

simulatedBER = []; % empty array of Simulated BER
for SNR_dB = -5:2:25
    SNR = 10.^(SNR_dB/10); % dB to linear
    noise = (sqrt(2/SNR)).*(randn(1, length(transSymbls)) + sqrt(-1)*randn(1, length(transSymbls))); % complex noise
    receivedSymbls = transSymbls + noise;

    symblRealPart = (real(receivedSymbls)>0);
    symblImgPart = (imag(receivedSymbls)>0);

    detectedBits = [];
    for i = 1:length(receivedSymbls)
        % array of detected bits with errors
        detectedBits = [detectedBits symblRealPart(i) symblImgPart(i)];
    end

    noOfErrors = sum(inputBits ~= detectedBits);
    BER = noOfErrors/N;
    simulatedBER = [simulatedBER BER];
end

SNR_dB = -5:2:25;
SNR = 10.^(SNR_dB/10);
semilogy(SNR_dB, simulatedBER, 'bo-','LineWidth',2);
title('BER of QPSK in AWGN');
xlabel('SNR(dB)');
ylabel('BER');
legend('Simulated BER for QPSK')
grid on
