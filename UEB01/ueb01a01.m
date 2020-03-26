function ueb01a01()

    clear all;

    % a)

    data = dlmread('expDat.txt',',',1,1);

    % b)

    plot(data,'Marker','.');
    xlabel('time');

    % c)

    data_truncated = data(:,1:5);

    figure;

    data_length = size(data_truncated,2);
    counter = 1;
    for i = 1:data_length
        for j = 1:data_length
            subplot(data_length, data_length, counter);
            scatter(data_truncated(:,i),data_truncated(:,j),'k','.','LineWidth',0.02);
            caption = sprintf('Process %d vs. Process %d',i,j);
        	title(caption,'FontWeight','normal','FontSize',10);
            counter = counter+1;
        end
    end

    % d)

    n = size(data,1);
    centered_data = data-repmat(mean(data),n,1);
    calculated_cov = ( centered_data' * centered_data ) / (n-1);

    figure;

    heatmap(calculated_cov);

    builtin_cov = cov(data);

    compared = calculated_cov == builtin_cov;
    isequal(calculated_cov,builtin_cov);

    % testing

    cor1 = corrcov(calculated_cov);
    cor2 = corrcov(builtin_cov);

end
