function ueb03a01()

    clear all;

    % a)

    data = dlmread('pca2.csv',',',1,0);

    [vectors,values] = pca_selfmade(data);
    data_translated = data*vectors;

    figure;
    plot(data_translated(:,1),data_translated(:,2),'xk');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    % b)

    data_truncated = data([1:16,18:156,158:end],:);

    [vectors,values] = pca_selfmade(data_truncated);
    data_truncated_translated = data_truncated*vectors;

    figure;
    plot(data_truncated_translated(:,1),data_truncated_translated(:,2),'xk');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

end

function [vectors,values] = pca_selfmade(data)

    [d,v] = eigs(cov(data));

    vectors = fliplr(d);
    values = fliplr(v);

end
