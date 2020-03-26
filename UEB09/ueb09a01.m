function ueb09a01()

    close all;
    clear all;

    data = load('cluster.dat');
    no_points = size(data,2);
    K = 2:8;

    for k = K

        % initialization

        data_mean = mean(data,2);
        prototypes = (-1+(2)*rand(2,k)) + repmat(data_mean,1,k);
        t_max = 5;
        assignment = zeros(1,size(data,2));

        % optimization

        error = size(t_max,1);

        for t = 0:t_max-1

            % visualization a)

            visualize_prototypes(k,t,data,assignment,data_mean,prototypes);

            % assign all datapoints to their closest prototype

            for p = 1:no_points
                dists = [];
                for l = 1:k
                    dists = [ dists norm(data(:,p)-prototypes(:,l)) ];
                end
                [~,index] = min(dists);
                assignment(p) = index;
            end

            % re-compute the new positions of the prototypes for this assignment

            for l = 1:k
                data_l = data(:,find(assignment==l));
                if ~isempty(data_l)
                    prototypes(:,l) = mean(data_l,2);
                end
            end

            % compute error

            temp = 0;
            for l = 1:k
                data_l = data(:,find(assignment==l));
                if ~isempty(data_l)
                    temp = temp + sum(norm(data_l-repmat(prototypes(:,l),1,size(data_l,2))).^2);
                end
            end

            error(t+1) = (1/2*no_points)*temp;

        end

        % visualization a)

        visualize_prototypes(k,t_max,data,assignment,data_mean,prototypes);

        % visualization b)

        figure;
        plot(0:1:t_max-1,error,'-k');
        xlabel('Iteration');
        ylabel('Error');
        title([ 'Plot of error function for K = ' num2str(k) ]);
        save_fig([ 'ueb09a01_' num2str(k) '_error' ]);

        % visualization c)

        if k ~= 2

            visualize_prototypes(k,t_max,data,assignment,data_mean,prototypes);
            for l = 1:k
                if size(data_l,2) > 0
                    voronoi(prototypes(1,:),prototypes(2,:),'k');
                    alpha(.8);
                end
            end
            save_fig([ 'ueb09a01_' num2str(k) '_voronoi' ]);

        end

    end


end

function save_fig(name)

    print([ name '.pdf'],'-dpdf');

end

function visualize_prototypes( K, iteration, data, assignment, data_mean, prototypes )

    cmap = cool(K);

    figure;
    hold on;

    if iteration == 0

        plot(data(1,:),data(2,:),'xk');
        plot(data_mean(1),data_mean(2),'ok','MarkerFaceColor','k','MarkerSize',7);
        legend_entries{1} = 'Original Data';
        legend_entries{2} = 'Mean of Original Data';

        for l = 1:K
            plot(prototypes(1,l),prototypes(2,l),'o','Color',cmap(l,:),'MarkerFaceColor',cmap(l,:),'MarkerSize',7);
            legend_entries{l+2} = [ 'Mean of Cluster ' num2str(l) ];
        end

    else

        plot(data_mean(1),data_mean(2),'ok','MarkerFaceColor','k','MarkerSize',7);
        legend_entries{1} = 'Mean of Original Data';

        for l = 1:K
            plot(prototypes(1,l),prototypes(2,l),'o','Color',cmap(l,:),'MarkerFaceColor',cmap(l,:),'MarkerSize',7);
            legend_entries{l+1} = [ 'Mean of Cluster ' num2str(l) ];
        end

        for l = 1:K
            data_l = data(:,find(assignment==l));
            plot(data_l(1,:),data_l(2,:),'x','Color',cmap(l,:));
        end

    end

    legend(legend_entries);
    title([ 'Visualization of Data and Prototypes for iteration ' num2str(iteration) ' with K = ' num2str(K) ]);
    save_fig([ 'ueb09a01_' num2str(K) '_iteration_' num2str(iteration) ]);

end
