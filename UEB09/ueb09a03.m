function ueb09a03()

    close all;
    clear all;

    data = load('cluster.dat');
    no_points = size(data,2);
    K = 8;

    % a) b)

    data_mean = mean(data,2);
    prototypes = (-1+(2)*rand(2,K)) + repmat(data_mean,1,K);
    prototypes_org = prototypes;
    prototypes_x = [];
    prototypes_y = [];
    betas = .2:2:20;

    for beta = betas

        % calculate probabilities

        [assignment_probabilities,prototypes] = calculate_probabilities(K,beta,data,prototypes);

        % save coordinates of prototypes
        
        prototypes_x = [ prototypes_x prototypes(1,:)' ];
        prototypes_y = [ prototypes_y prototypes(2,:)' ];

        % c)

        visualize_prototypes(K,beta,data,data_mean,assignment_probabilities,prototypes,prototypes_org);
        title([ 'Visualization of Data and Prototypes with K = ' num2str(K) ' and \beta = '  num2str(beta) ' (no annealing)' ]);
        save_fig([ 'ueb09a03_' num2str(K) '_' num2str(beta) ]);

    end

    % d)

    cmap = cool(K);

    figure;

    subplot(1,2,1);
    hold on;
    for k = 1:K
        plot(betas,prototypes_x(k,:),'-','Color',cmap(k,:));
        legend_entries{k} = [ 'K = ' num2str(k) ];
    end
    set(gca,'XTick',betas);
    xlabel('Beta value');
    ylabel('First coordinate of final prototypes');
    legend(legend_entries);
    title({ 'Plot of first coordinate of the final prototypes', 'against \beta' });

    subplot(1,2,2);
    hold on;
    for k = 1:K
        plot(betas,prototypes_y(k,:),'-','Color',cmap(k,:));
        legend_entries{k} = [ 'K = ' num2str(k) ];
    end
    set(gca,'XTick',betas);
    xlabel('Beta value');
    ylabel('Second coordinate of final prototypes');
    legend(legend_entries);
    title({ 'Plot of second coordinate of the final prototypes', 'against \beta' });

    save_fig([ 'ueb09a03_plot_of_coordinates' ]);

    % e)

    K = 2:2:8;
    tau = 1.1;

    for k = K

        beta = .2;

        while beta < 20

            [assignment_probabilities,prototypes] = calculate_probabilities(k,beta,data,prototypes);

            % f)

            visualize_prototypes(k,beta,data,data_mean,assignment_probabilities,prototypes,prototypes_org);
            title([ 'Visualization of Data and Prototypes with K = ' num2str(k) ' and \beta = '  num2str(beta) ' (with annealing)' ]);
            save_fig([ 'ueb09a03_a_' num2str(k) '_' num2str(beta) ]);

            beta = beta*tau;

        end

    end

end

function save_fig(name)

    print([ name '.pdf'],'-dpdf');

end

function [assignment_probabilities,prototypes] = calculate_probabilities( K, beta, data, prototypes )

    no_points = size(data,2);
    convergence = false;
    gamma = .05;

    while ~convergence

        prototypes_old = prototypes;

        assignment_probabilities = [];
        assignment_probabilities_for_all = 0;
        for l = 1:K
            assignment_probability = exp(-beta/2*sum((data-repmat(prototypes(:,l),1,no_points)).^2,1));
            assignment_probabilities_for_all = assignment_probabilities_for_all + assignment_probability;
            assignment_probabilities = [ assignment_probabilities ; assignment_probability ];
        end

        assignment_probabilities = assignment_probabilities./repmat(assignment_probabilities_for_all,K,1);

        for l = 1:K
            assignment_probabilities_l = repmat(assignment_probabilities(l,:),2,1);
            prototypes(:,l) = sum(assignment_probabilities_l.*data,2)./sum(assignment_probabilities_l,2);
        end

        if sqrt(sum((prototypes-prototypes_old).^2,1)) < gamma
            convergence = true;
        end

    end

end

function visualize_prototypes( K, beta, data, data_mean, assignment_probabilities, prototypes, prototypes_org )

    cmap = cool(K);

    figure;
    hold on;

    plot(data_mean(1),data_mean(2),'ok','MarkerFaceColor','k','MarkerSize',7);
    legend_entries{1} = 'Mean of Original Data';

    for l = 1:K
        plot(prototypes_org(1,l),prototypes_org(2,l),'o','Color',cmap(l,:),'MarkerSize',7);
        plot(prototypes(1,l),prototypes(2,l),'o','Color',cmap(l,:),'MarkerFaceColor',cmap(l,:),'MarkerSize',7);
    end
    legend_entries{2} = [ 'Original means of the clusters' ];
    legend_entries{3} = [ 'Final means of the clusters' ];

    [~,assignment] = max(assignment_probabilities);

    for l = 1:K
        data_l = data(:,find(assignment==l));
        assignment_probabilities_l = assignment_probabilities(l,find(assignment==l));
        for m = 1:size(data_l,2)
            scatter(data_l(1,m),data_l(2,m),'x','MarkerEdgeColor',cmap(l,:),'MarkerEdgeAlpha',assignment_probabilities_l(m));
        end
    end

    legend(legend_entries);

end
