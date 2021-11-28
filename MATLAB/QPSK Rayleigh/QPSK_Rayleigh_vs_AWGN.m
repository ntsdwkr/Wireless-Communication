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
simulatedBERRayleigh = []; % empty array of Simulated BER for Rayleigh
simulatedBER_AWGN = []; % empty array of Simulated BER for AWGN
for SNR_dB = -5:2:25

    SNR = 10.^(SNR_dB/10); % dB to linear
    noise = (sqrt(2/SNR)).*(randn(1, length(transSymbls)) + sqrt(-1)*randn(1, length(transSymbls))); % complex noise
    h = sqrt(0.5*((randn(1,length(transSymbls))).^2 + (randn(1,length(transSymbls))).^2)); % Rayleigh channel coefficient
    receivedSymblsAWGN = transSymbls + noise;
    receivedSymblsRayleigh = (transSymbls.*h) + noise;

    symblRealPartRayleigh = (real(receivedSymblsRayleigh)>0);
    symblImgPartRayleigh = (imag(receivedSymblsRayleigh)>0);

    symblRealPartAWGN = (real(receivedSymblsAWGN)>0);
    symblImgPartAWGN = (imag(receivedSymblsAWGN)>0);

    detectedBitsRayleigh = [];
    detectedBitsAWGN =[];
    % detection
    for i = 1:length(receivedSymblsRayleigh)
        detectedBitsRayleigh = [detectedBitsRayleigh symblRealPartRayleigh(i) symblImgPartRayleigh(i)]; % array of detected bits with errors
    end

    for i = 1:length(receivedSymblsAWGN)
        detectedBitsAWGN = [detectedBitsAWGN symblRealPartAWGN(i) symblImgPartAWGN(i)]; % array of detected bits with errors
    end

    noOfErrorsRayleigh = sum(inputBits ~= detectedBitsRayleigh);
    BER_Rayleigh = noOfErrorsRayleigh/N;
    simulatedBERRayleigh = [simulatedBERRayleigh BER_Rayleigh];

    noOfErrorsAWGN = sum(inputBits ~= detectedBitsAWGN);
    BER_AWGN = noOfErrorsAWGN/N;
    simulatedBER_AWGN = [simulatedBER_AWGN BER_AWGN];
end

SNR_dB = -5:2:25;
SNR = 10.^(SNR_dB/10);
semilogy(SNR_dB, simulatedBERRayleigh, 'r*-', SNR_dB, simulatedBER_AWGN, 'bo-', 'Linewidth', 1.5);
title('BER of QPSK in Raleigh vs AWGN');
xlabel('SNR(dB)');
ylabel('BER');
legend('BER of QPSK in Rayleigh', 'BER of QPSK in AWGN');
grid on
