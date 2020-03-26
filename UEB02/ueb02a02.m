function ueb02a02()

    clear all;

    % a)

    data = dlmread('pca-data-3d.txt',',',1,0);

    data_centered = data-repmat(mean(data),[size(data,1),1]);

    plotmatrix(data,'.k');

    % b)

    [coeffs,score] = pca(data_centered);

    data_temp1 = [score(:,1),score(:,2)];
    data_temp2 = [score(:,1),score(:,3)];
    data_temp3 = [score(:,2),score(:,3)];

    figure;
    plotmatrix(data_temp1,'.k');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    figure;
    plotmatrix(data_temp2,'.k');
    xlabel('1st Principal Component');
    ylabel('3rd Principal Component');

    figure;
    plotmatrix(data_temp3,'.k');
    xlabel('2nd Principal Component');
    ylabel('3rd Principal Component');

    % c) i)

    data_dummy = zeros(size(data_centered,1),1);

    figure;
    plot(score(:,1),data_dummy,'xk');
    xlabel('1st Principal Component');

    % c) ii)

    figure;
    plot(score(:,1),score(:,2),'xk');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    % c) iii)

    figure;
    scatter3(score(:,1),score(:,2),score(:,3),'xk');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');
    zlabel('3rd Principal Component');

end
