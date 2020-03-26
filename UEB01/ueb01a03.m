function ueb01a03()

    clear all;

    % a)

    data = imread('natIMG.jpg');

    % b)

    colormap(gray);
    heatmap(data);

    % c)

    patches = cell(100,1);

    for j = 1:100
        x = ceil((size(data,1)-9).*rand(100,1));
        y = ceil((size(data,2)-9).*rand(100,1));
        patches{j,1} = data(x:x+9,y:y+9);
    end

    % d)

    figure;
    colormap(gray);

    for j = 1:100
        subplot(10, 10, j);
        heatmap(patches{j,1});
    end

    % e)

    figure;
    colormap(flipud(gray));

    for j = 1:100
        subplot(10, 10, j);
        heatmap(patches{j,1});
    end

end
