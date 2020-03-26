function ueb03a04()

    clear all;

    color_selection = [0.9412 0.4706 0 ; 0 0 0 ; 0.251 0 0.502 ; 0.502 0.251 0 ; 0 0.251 0 ; 0.502 0.502 0.502 ; 0.502 0.502 1 ; 0 0.502 0.502 ; 0.502 0 0 ; 1 0.502 0.502];

    % 1.

    data = dlmread('data-onlinePCA.txt',',',1,1);

    plot_data(data,color_selection);

    % 2.

    plot_vectors(data,color_selection);

    % 3.

    learning_rate = [.002 ; .04 ; .45];
    w = [1 , 1];
    output = zeros(size(data));

    for k = 1:size(learning_rate)

        eta = learning_rate(k);

        plot_data(data,color_selection);
        title(sprintf('learning rate %f',eta));

        for l = 1:size(data,1)

            s = w * data(l,:)';
            w = w + eta * s * (data(l,:) - (s * w));

            % if (mod(l,200) == 0)
                % plot_arrow(w,color_selection(l/200,:));
                plot_arrow(w,'k');
            % end

        end

    end

end

function [vectors,values] = pca_selfmade(data)

    [d,v] = eigs(cov(data));

    vectors = fliplr(d);
    values = fliplr(v);

end

function plot_data(data,color_selection)

    figure;
    hold on;

    for k = 1:10
        block = data(((k-1)*200+1):(k*200),:);
        plot(block(:,1),block(:,2),'Color',color_selection(k,:),'Marker','x','LineStyle','none');
    end

    legend('1-200 seconds', '201-400 seconds', '401-600 seconds', '601-800 seconds', '801-1000 seconds', '1001-1200 seconds', '1201-1400 seconds', '1401-1600 seconds', '1601-1800 seconds', '1801-2000 seconds');

end

function plot_vectors(data,color_selection)

    for k = 1:10
        [vectors,values] = pca_selfmade(data(((k-1)*200+1):(k*200),:));
        plot_arrow(vectors,color_selection(k,:));
    end

end

function plot_arrow(vector,color)

    ursprung = [0;0];
    quiver(ursprung(1),ursprung(2),vector(1),vector(2),0,'Color',color,'LineWidth',1.5);

end
