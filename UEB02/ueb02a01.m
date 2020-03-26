function ueb02a01()

    clear all;

    % a)

    data = dlmread('pca-data-2d.txt');

    data_centered = data-repmat(mean(data),[size(data,1),1]);

    plot(data_centered(:,1),data_centered(:,2),'xk');

    % b)

    % own pca and own translation

    [vectors,values] = eig(cov(data_centered)); % (-0.6779;-0.7352) with value 0.0491 and (-0.7352;0.6779) with value 1.2840 are the pcs

    data_translated = data_centered*vectors;

    figure;
    plot(data_translated(:,2),data_translated(:,1),'xk');

    % in-built pca, data haven't to be centered

    [coeffs,score,latent] = pca(data_centered); % coeffs = (0.7352;-0.6779) and (0.6779;0.7352)

    % using result of in-built pca

    % figure;
    % plot(-score(:,1),-score(:,2),'xk');

    % c)

    data_dummy = zeros(size(data_centered,1),1);

    % c) i)

    figure;
    plot(data_translated(:,1),data_dummy,'xk');

    % c) ii)

    figure;
    plot(data_dummy,data_translated(:,2),'xk');

end
