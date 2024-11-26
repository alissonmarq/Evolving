clear
clc

% Define o diretório atual onde as pastas estão localizadas
pasta_raiz = pwd; % Obtém o diretório atual

% Lista de pastas com seus nomes específicos
pastas = {'ALMMO', 'eFCMG', 'eGNN', 'eOGS', 'FBEM', 'IBEM'};

% Inicializa uma célula para armazenar os resultados
resultados_matriz = [];

% Percorre cada pasta da lista
for i = 1:length(pastas)
    pasta_atual = fullfile(pasta_raiz, pastas{i}); % Caminho completo da pasta
    
    % Verifica se a pasta existe
    if isfolder(pasta_atual)
        % Nomes dos arquivos .mat que precisamos abrir
        arquivos = {
            [pastas{i}, '_05abrupt.mat'],
            [pastas{i}, '_05gradual.mat'],
            [pastas{i}, '_05normal.mat'],
            [pastas{i}, '_05outlier.mat']
        };

        % Inicializa um vetor para armazenar a média e desvio padrão da pasta
        resultados_pasta = NaN(1, 8); % 4 arquivos x 2 valores (média e desvio)

        % Percorre os arquivos para carregar e processar os dados
        for j = 1:length(arquivos)
            % Carrega o arquivo .mat correspondente
            arquivo_atual = fullfile(pasta_atual, arquivos{j});
            if exist(arquivo_atual, 'file') == 2
                load(arquivo_atual); % Carrega o arquivo .mat
                
                % Verifica se a variável 'final' existe
                if exist('final', 'var')
                    % Calcula a média e o desvio padrão da primeira coluna de 'final'
                    media = mean(final(:, 1));
                    desvio_padrao = std(final(:, 1));
                    
                    % Armazena os resultados na matriz para esta pasta
                    col = (j - 1) * 2 + 1; % Define a coluna para média
                    resultados_pasta(col) = media;
                    resultados_pasta(col + 1) = desvio_padrao;
                else
                    % Caso a variável 'final' não esteja presente no arquivo
                    resultados_pasta((j - 1) * 2 + 1) = NaN;
                    resultados_pasta((j - 1) * 2 + 2) = NaN;
                end
            else
                % Caso o arquivo não exista
                resultados_pasta((j - 1) * 2 + 1) = NaN;
                resultados_pasta((j - 1) * 2 + 2) = NaN;
            end
        end
        
        % Adiciona os resultados da pasta à matriz final
        resultados_matriz = [resultados_matriz; resultados_pasta];
    else
        warning(['A pasta ' pastas{i} ' não foi encontrada.']);
    end
end

% Salva os resultados em um arquivo .mat
save('resultados_matriz.mat', 'resultados_matriz');
