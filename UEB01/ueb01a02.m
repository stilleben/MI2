function ueb01a02()

    clear all;

    % a)

    data = dlmread('pca-data-3d.txt',',',1,0);

    % b)

    plotmatrix(data);

    % c)

    figure;
    scatter3(data(:,1),data(:,2),data(:,3),'.','k')
    xlabel('Column 1');
    ylabel('Column 2');
    zlabel('Column 3');

    % d)

    truncated_data = data(:,1:2);

    figure;
    plot(truncated_data(:,1),truncated_data(:,2),'Marker','.','LineStyle','none');

    max_angle = 180;
    min_angle = 0;
    inkrement_angle = 15;
    no_angles = max_angle/inkrement_angle+1;

    projections = zeros(no_angles,size(truncated_data,1));
    angles = zeros(no_angles,1);

    counter = 1;
    for angle = min_angle:inkrement_angle:max_angle
        e = [cosd(angle); sind(angle)];
        projections(counter,:) = truncated_data*e;
        angles(counter) = angle;
        counter = counter+1;
    end

    variance = [var(projections,1,2)];

    figure;
    plot(angles,variance,'Marker','o','LineStyle','none');
    xlabel('degree');
    ylabel('variance');

end
