function ueb02a03()

    clear all;

    data = dlmread('expDat.txt',',',1,1);

    % a)

    [coeffs,score,latent] = pca(data);

    % b) i)

    % plot(score(:,1),score(:,2),'xk');

    figure;
    scatter(score(:,1),score(:,2),[],linspace(1,100,length(score(:,1))),'filled');
    colormap(summer);
    c = colorbar;
    c.Label.String = 'Time Index';
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    % b) ii)

    data_dummy = zeros(size(data,1),1);

    figure;
    hold on;

    X = 1:100;
    scatter(X,-score(:,1),[],linspace(1,100,length(score(:,1))),'o','filled');
    scatter(X,-score(:,2),[],linspace(1,100,length(score(:,2))),'o');

    colormap(summer);
    c = colorbar;
    c.Label.String = 'Time Index';
    legend('1st Principal Component','2nd Principal Component');

    % c)

    data_shuffled = zeros(size(data));

    for j = 1:size(data,2)
        data_shuffled(:,j) = datasample(data(:,j),size(data,1),'Replace',false);
    end

    % d)

    % original data

    figure;
    heatmap(cov(data));
    colormap(summer);

    X = 1:20;
    Xi = 1:.1:20;
    Y = pchip(X,latent,Xi);

    figure;
    plot(X,latent,'xk',Xi,Y,'-k');
    xlabel('Principal Component');
    ylabel('Eigenvalue');
    axis([1 20 0 160]);

    % scrambled data

    figure;
    heatmap(cov(data_shuffled));
    colormap(summer);

    [coeffs_shuffled,score_shuffled,latent_shuffled] = pca(data_shuffled);
    Y_shuffled = pchip(X,latent_shuffled,Xi);

    figure;
    plot(X,latent_shuffled,'xk',Xi,Y_shuffled,'-k');
    xlabel('Principal Component');
    ylabel('Eigenvalue');
    axis([1 20 0 35]);

end
