function ueb31a02()

    clear all;

    % a)

    data = dlmread('pca4.csv',',',1,0);

    % mean and deviation method

    outlierIndexes = [];

    for k = 1:size(data,2)

        variable = data(:,k);

        % compute the mean
        meanValue = mean(variable);
        % compute the absolute differences
        diff = abs(variable - meanValue);
        % compute the standard deviation
        stdValue = std(variable);

        % if the absolute difference is more than some factor times the std value it's an outlier
        threshold = 5;
        outlierIndexes = [outlierIndexes ; find(diff > threshold * stdValue)];

    end

    size(outlierIndexes)

    % median absolute deviation method

    outlierIndexes = [];

    for k = 1:size(data,2)

        variable = data(:,k);

        % compute the median
        medianValue = median(variable);
        % compute the absolute differences
        diff = abs(variable - medianValue);
        % compute the median absolute deviation
        mad = median(diff);

        % if the absolute difference is more than some factor times the mad value it's an outlier
        threshold = 6;
        outlierIndexes = [outlierIndexes ; find(diff > threshold * mad)];

    end

    size(outlierIndexes)

    % interquartile deviation method

    outlierIndexes = [];

    for k = 1:size(data,2)

        variable = data(:,k);

        % compute q1
        q1 = prctile(variable,25);
        % compute q3
        q3 = prctile(variable,75);
        % compute the interquartile range
        iqr = abs(q1-q3);

        % if the data point lies outside a specific range it is an outlier
        outlierIndexes = [outlierIndexes ; find(variable < (q1 - 2.22 * iqr) | variable > (q3 + 2.22 * iqr))];

    end

    size(outlierIndexes)

    % b)

    data_truncated = data;
    sort(outlierIndexes,'descend');

    for k = 1:size(outlierIndexes)

        % remove outliers
        data_truncated = data_truncated([1:(outlierIndexes(k)-1),(outlierIndexes(k)+1):end],:);

    end

    [vectors,values] = pca_selfmade(data_truncated);
    screeplot(values);

    % c)

    data_truncated_centered = data_truncated-repmat(mean(data_truncated),[size(data_truncated,1),1]);
    [vectors,values] = pca_selfmade(data_truncated_centered);

    data_whitened = data_truncated_centered*vectors*diag(values.^(-1/2));

    % d) i)

    figure;
    colormap(summer);
    heatmap(cov(data_truncated_centered));
    colorbar;

    % d) ii)

    data_translated = data_truncated_centered*vectors;

    figure;
    colormap(summer);
    heatmap(cov(data_translated));
    colorbar;

    % d) iii)

    figure;
    colormap(summer);
    heatmap(cov(data_whitened));
    colorbar;

end

function [vectors,values] = pca_selfmade(data)

    [d,v] = eigs(cov(data));

    vectors = fliplr(d);
    values = nonzeros(fliplr(v));

end

function screeplot(values)

    X = 0:3;
    Xi = 0:.1:3;
    Y = pchip(X,values,Xi);

    figure;
    plot(Xi,Y,'-k');
    xlabel('Principal Component');
    ylabel('Eigenvalue');

end
