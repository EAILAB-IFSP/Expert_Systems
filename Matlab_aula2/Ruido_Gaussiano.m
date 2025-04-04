% Programa de Ruído Branco (ou Gaussiano)
% Por: Dr. Arnaldo de Carvalho Junior - 2025
% Ref.: https://www.gaussianwaves.com/2013/11/simulation-and-analysis-of-white-noise-in-matlab/

clear all; close all; clc;

% Gera Ruido Gaussiano de Banda L
L=100000; % Comprimento da amostra para o sinal aleatório
mu=0; % Média de cada realização do processo de ruído
sigma=2; % desvio padrão (variância = sigma^2) de cada realização do processo de ruído
X=sigma*randn(L,1)+mu; % noise

figure(1);
plot(X);
title(['Ruído Branco : \mu_x=',num2str(mu),' \sigma^2=',num2str(sigma^2)])
xlabel('Ammostras')
ylabel('Valores das Amostras')
grid on;
hold on;

% Plot do histograma do ruído gerado
figure(2);
n=100; % número de raias (bins) do histograma
[f,x]=hist(X,n);
bar(x,f/trapz(x,f)); 
hold on;

% PDF teórico da variável gaussiana aleatória
g=(1/(sqrt(2*pi)*sigma))*exp(-((x-mu).^2)/(2*sigma^2));

plot(x,g);
hold off; 
grid on;
title('PDF teórico e histograma simulado de ruído gaussiano branco');
legend('Histograma','PDF Teórico');
xlabel('Bins');
ylabel('PDF f_x(x)');
hold on;

% Calcula a função de auto-correlação
Rxx=1/L*conv(flipud(X),X);
lags=(-L+1):1:(L-1);

% Método alternativo
% [Rxx,lags] =xcorr(X,'biased'); 
% O argumento 'biased' é usado para escalar 1/L corretamente
% Normalizar correlação automática com comprimento da amostra para escala adequada

figure(3);
plot(lags,Rxx); 
title('Função de auto-correlação de Ruído Branco');
xlabel('Lags')
ylabel('Correlação')
grid on;
hold on;

% Simulando o ruído branco gaussian como um vetor aleatório gaussiano
% multivariável
% Verificando o PSD constante do processo de ruído gaussiano branco
% com média arbitrária e desvio padrão sigma

% L=1000; % Diminua L para acelerar o cálculo
N = 1024; % Comprimento da amostra para cada conjunto de realização como 
% potência de 2 para FFT

% Gerando o processo aleatório - Processo de ruído gaussiano branco
MU=mu*ones(1,N); % Vetor de média de todas as realizações
Cxx=(sigma^2)*diag(ones(N,1)); % Matriz de covariância para o processo 
% aleatório
R = chol(Cxx); % Cholesky da Matriz de Covariância
% Gerando uma distribuição gaussiana multivariada com dado vetor médio e 
% matriz de covariância CXX
z = repmat(MU,L,1) + randn(L,N)*R;

% Calcula a PSD do processo multidimensional gerado e a média
% Por definição, FFT é feita através de cada coluna
% commando normal fft(z)
% Encontrando a FFT da distribuição multivariável através de cada linha
% Comando - fft(z,[],2)
Z = 1/sqrt(N)*fft(z,[],2); % Escalando por sqrt(N);
Pzavg = mean(Z.*conj(Z)); % Calculando a potência média da FFT

normFreq=[-N/2:N/2-1]/N;
Pzavg=fftshift(Pzavg); % Mudar componente de frequência zero para o centro 
% do espectro

figure(4)
plot(normFreq,10*log10(Pzavg),'r');
axis([-0.5 0.5 0 10]); grid on;
ylabel('Densidade Espectral de Potência (PSD) (dB/Hz)');
xlabel('Frequência Normalizada');
title('PSD do Ruído Branco');
grid on;
hold on;
