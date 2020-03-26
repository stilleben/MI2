function ueb09a02()

    close all;
    clear all;

    data = load('cluster.dat');
    no_points = size(data,2);
    K = 4;

    % initialization

    data_mean = mean(data,2);
    for k = 1:K
        prototypes{k} = (-1+(2)*rand(2,1)) + data_mean;
    end
    epsilon = 0.1;
    tau = 0.98;
    t_max = size(data,2);
    assignment = randi(3,1,size(data,2));

    % optimization

    error = size(t_max+1,1);

    for t = 0:t_max-1

        % visualization a)

        visualize_prototypes(K,t,data,assignment,data_mean,prototypes);

        % assign datapoint to its closest prototype

        dists = [];
        for l = 1:K
            dists = [ dists norm(data(:,t+1)-prototypes{l}(:,end)) ];
        end
        [~,index] = min(dists);
        assignment(t+1) = index;

        % re-compute the new positions of the prototype for this assignment

        prototype_new = prototypes{index}(:,end) + (epsilon.*(data(:,t+1)-prototypes{index}(:,end)));
        if ~(isequal(prototype_new,prototypes{index}(:,end)))
            prototypes{index} = [ prototypes{index} prototype_new ];
        end

        % re-compute the new positions of the prototypes for this assignment

        if t > t_max/4
            epsilon = epsilon*tau;
        end

        % compute error
        
        temp = 0;
        for l = 1:K
            data_l = data(:,find(assignment==l));
            if ~isempty(data_l)
                temp = temp + sum(norm(data_l-repmat(prototypes{l}(:,end),1,size(data_l,2))).^2);
            end
        end

        error(t+1) = (1/2*no_points)*temp;

    end

    % visualization a)

    visualize_prototypes(K,t_max+1,data,assignment,data_mean,prototypes);

    % visualization b)

    figure;
    plot(0:1:t_max-1,error,'-k');
    xlabel('Iteration');
    ylabel('Error');
    title([ 'Plot of error function for K = ' num2str(K) ]);
    save_fig([ 'ueb09a02_' num2str(K) '_error' ]);

end

function save_fig(name)

    print([ name '.pdf'],'-dpdf');

end

function visualize_prototypes( K, iteration, data, assignment, data_mean, prototypes )

    cmap = cool(K);
    np_points = size(data,2);

    if iteration == 0

        figure;
        hold on;

        plot(data(1,:),data(2,:),'xk');
        plot(data_mean(1),data_mean(2),'ok','MarkerFaceColor','k','MarkerSize',7);
        legend_entries{1} = 'Original Data';
        legend_entries{2} = 'Mean of Original Data';

        for l = 1:K
            plot(prototypes{l}(1,end),prototypes{l}(2,end),'o','Color',cmap(l,:),'MarkerFaceColor',cmap(l,:),'MarkerSize',7);
            legend_entries{l+2} = [ 'Mean of Cluster ' num2str(l) ];
        end

        legend(legend_entries);
        title([ 'Visualization of Data and Prototypes for iteration ' num2str(iteration) ' with K = ' num2str(K) ]);
        save_fig([ 'ueb09a02_' num2str(K) '_iteration_' num2str(iteration) ]);

    elseif ( mod(floor(np_points/4),iteration) == 0 | iteration == np_points-1 )

        figure;
        hold on;

        plot(data_mean(1),data_mean(2),'ok','MarkerFaceColor','k','MarkerSize',7);
        legend_entries{1} = 'Mean of Original Data';

        for l = 1:K
            plot(prototypes{l}(1,end),prototypes{l}(2,end),'o','Color',cmap(l,:),'MarkerFaceColor',cmap(l,:),'MarkerSize',7);
            legend_entries{l+1} = [ 'Mean of Cluster ' num2str(l) ];
        end

        data_0 = data(:,find(assignment==0));
        plot(data_0(1,:),data_0(2,:),'xk');

        for l = 1:K
            data_l = data(:,find(assignment==l));
            plot(data_l(1,:),data_l(2,:),'x','Color',cmap(l,:));
            if iteration == np_points-1
                line(prototypes{l}(1,:),prototypes{l}(2,:),'Color',[ cmap(l,:) 0.8 ]);
            end
        end

        legend(legend_entries);
        title([ 'Visualization of Data and Prototypes for iteration ' num2str(iteration) ' with K = ' num2str(K) ]);
        save_fig([ 'ueb09a02_' num2str(K) '_iteration_' num2str(iteration) ]);

    end

end
