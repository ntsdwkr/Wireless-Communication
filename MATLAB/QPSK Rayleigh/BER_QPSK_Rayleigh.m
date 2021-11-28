clear;
close all;
clc;
% QPSK BER Simulation over Rayleigh Channel
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
    noise = sqrt(1/2).*sqrt(1/SNR).*(randn(1, length(transSymbls)) + sqrt(-1)*randn(1, length(transSymbls))); % complex noise
    h = sqrt(0.5*((randn(1,length(transSymbls))).^2 + (randn(1,length(transSymbls))).^2)); % Rayleigh channel coefficient
    receivedSymblsRayleigh = (transSymbls.*h) + noise;

    symblRealPart = (real(receivedSymblsRayleigh)>0);
    symblImgPart = (imag(receivedSymblsRayleigh)>0);

    detectedBits = [];
    % detection
    for i = 1:length(receivedSymblsRayleigh)
        detectedBits = [detectedBits symblRealPart(i) symblImgPart(i)]; % array of detected bits with errors
    end

    noOfErrors = sum(inputBits ~= detectedBits);
    BER = noOfErrors/N;
    simulatedBER = [simulatedBER BER];
end

SNR_dB = -5:2:25;
SNR = 10.^(SNR_dB/10);
semilogy(SNR_dB, simulatedBER, 'bo-', 'Linewidth', 1.5);
title('BER of QPSK in Rayleigh');
xlabel('SNR(dB)');
ylabel('BER');
legend('BER of QPSK in Rayleigh')
grid on
