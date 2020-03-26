function ueb08()

    close all;
    clear all;

    N = 6;
    t_max = 40;
    Ms = [ 1 500 ];
    betas = [ .001 .01 .05 .1 .5 .9 ];

    for beta = betas

        for M = Ms

            W = ueb08a01(M,t_max,beta,1.1);
            probabilities = probabilities_for_all_possible_states(W,beta);

            figure;
            bar(probabilities,'k');
            xlim([0 2^N+1]);
            xlabel('State');
            ylabel('Probability');
            title([ 'Simulated Annealing: Probabilities for all possible states with M = ' num2str(M) ' and \beta = ' num2str(beta) ]);
            save_fig([ 'sim_probabilities_for_all_states_' int2str(M) '_' num2str(beta) ]);

            ueb08a02(W,M,t_max,beta,1.1);

        end

    end

end

function W = ueb08a01( M, t_max, beta, tau )

    N = 6;
    cmap = cool(N);
    beta_org = beta;

    % initialization

    state_possibilities = [ -1 1 ];
    states = state_possibilities(randi(length(state_possibilities),1,N));

    % create symmetric matrix
    W = randn(N);
    W = (W + W')/2;
    % set diagonal to zero
    W(1:N+1:N*N) = 0;

    % optimization

    temperature = zeros(t_max,1);
    energy = zeros(t_max,1);

    iterations = 0;
    tic;

    for k = 2:t_max

        for l = 1:M

            % select states randomly
            i = randi([1 N],1,1);

            E_pos = -.5*states(i)*W(i,:)*states';
            E_neg = -E_pos;
            E_dif = E_neg-E_pos;

            % flip states i
            if ((1+exp(beta*E_dif))^(-1)) > .5
                states(i) = -states(i);
            end

            iterations = iterations+1;

        end

        beta = beta*tau;
        temperature(k) = 1/beta;
        energy(k,1) = e(W,states);

    end

    % plotting

    figure;
    plot(1:t_max-1,temperature(2:end),'k-');
    xlim([1 t_max-1]);
    ylim([ min(temperature(2:end))-1 max(temperature(2:end))+1 ]);
    xlabel('Timestep');
    ylabel('Temperature');
    title([ 'Simulated Annealing: Temperature over time with M = ' int2str(M) ' and \beta = ' num2str(beta_org) ]);
    save_fig([ 'sim_temperature_over_time_' int2str(M) '_' num2str(beta_org) ]);

    figure;
    hold on;
    plot(1:t_max,energy,'k-');
    xlim([1 t_max]);
    ylim([ min(energy)-1 max(energy)+1 ]);
    xlabel('Timestep');
    ylabel('Energy');
    title({[ 'Simulated Annealing: Energy over time with M = ' int2str(M) ' and \beta = ' num2str(beta_org) ],[ 'Iterations: ' num2str(iterations) ', Time: ' num2str(toc) 's' ]});
    save_fig([ 'sim_energy_over_time_' int2str(M) '_' num2str(beta_org) ]);

    energies = energies_for_all_possible_states(W);

    figure;
    bar(energies,'k');
    xlim([0 2^N+1]);
    xlabel('State');
    ylabel('Energy');
    title([ 'Simulated Annealing: Energy for all possible states with M = ' int2str(M) ' and \beta = ' num2str(beta_org) ]);
    save_fig([ 'sim_energy_for_all_states_' int2str(M) '_' num2str(beta_org) ]);

end

function save_fig(name)

    path = 'plots';
    if exist(path) == 0
        mkdir(path);
    end
    print([ path filesep name '.pdf'],'-dpdf');

end

function energies = energies_for_all_possible_states( W )

    N = 6;
    state_possibilities = [ -1 1 ];
    energies = [];

    for s1 = state_possibilities
        for s2 = state_possibilities
            for s3 = state_possibilities
                for s4 = state_possibilities
                    for s5 = state_possibilities
                        for s6 = state_possibilities

                            states = [ s1 s2 s3 s4 s5 s6 ];
                            energies = [ energies e(W,states) ];

                        end
                    end
                end
            end
        end
    end

end

function energy = e( W, states )

    energy = -0.5*states*W*states';

end

function probabilities = probabilities_for_all_possible_states( W, beta )

    state_possibilities = [ -1 1 ];
    probabilities = [];

    for s1 = state_possibilities
        for s2 = state_possibilities
            for s3 = state_possibilities
                for s4 = state_possibilities
                    for s5 = state_possibilities
                        for s6 = state_possibilities

                            states = [ s1 s2 s3 s4 s5 s6 ];
                            probabilities = [ probabilities P(W,states,beta) ];

                        end
                    end
                end
            end
        end
    end

end

function probability = P( W, states, beta )

    state_possibilities = [ -1 1 ];
    Z = 0;

    for s1 = state_possibilities
        for s2 = state_possibilities
            for s3 = state_possibilities
                for s4 = state_possibilities
                    for s5 = state_possibilities
                        for s6 = state_possibilities

                            states_temp = [ s1 s2 s3 s4 s5 s6 ];
                            Z = Z + exp(-beta*e(W,states_temp));

                        end
                    end
                end
            end
        end
    end

    probability = (1/Z)*(exp(-beta*e(W,states)));

end

function ueb08a02( W, M, t_max, beta, tau )

    N = 6;
    cmap = cool(N);
    beta_org = beta;

    % initialization

    epsilon = 0.01;

    state_possibilities = [ -1 1 ];
    states = state_possibilities(randi(length(state_possibilities),1,N));

    % optimization

    convergence = false;
    e = zeros(N,1);
    temperature = zeros(t_max,1);
    energy = zeros(t_max,N);

    iterations = 0;
    tic;

    for k = 2:t_max

        while ~convergence

            e_old = e;

            for l = 1:N
                e(l) = -W(l,:)*states';
                states(l) = tanh(-beta*e(l));
            end

            if abs(e-e_old) < epsilon
                convergence = true;
            end

            iterations = iterations+1;

        end

        beta = beta*tau;
        temperature(k) = 1/beta;
        energy(k,1) = -0.5*states*W*states';

    end

    % plotting

    figure;
    plot(1:t_max-1,temperature(2:end),'k-');
    xlim([1 t_max-1]);
    ylim([ min(temperature(2:end))-1 max(temperature(2:end))+1 ]);
    xlabel('Timestep');
    ylabel('Temperature');
    title([ 'Mean-Field Annealing: Temperature over time with M = ' int2str(M) ' and \beta = ' num2str(beta_org) ]);
    save_fig([ 'mean_temperature_over_time_' int2str(M) '_' num2str(beta_org) ]);

    figure;
    hold on;
    plot(1:t_max,energy,'k-');
    xlim([1 t_max]);
    % ylim([ min(energy)-1 max(energy)+1 ]);
    xlabel('Timestep');
    ylabel('Energy');
    title({[ 'Mean-Field Annealing: Energy over time with M = ' int2str(M) ' and \beta = ' num2str(beta_org) ],[ 'Iterations: ' num2str(iterations) ', Time: ' num2str(toc) 's' ]});
    save_fig([ 'mean_energy_over_time_' int2str(M) '_' num2str(beta_org) ]);


end
