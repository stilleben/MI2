function ueb02a04()

    clear all;

    % a)

    N = 5000;

    % building pictures

    no_building = 10;

    for j = 1:no_building
        data = imread(['imgpca/b',num2str(j),'.jpg']);
        sample_image_building = patch(data,N,no_building,j);
    end

    % nature pictures

    no_nature = 13;

    for j = 1:no_nature
        data = imread(['imgpca/n',num2str(j),'.jpg']);
        sample_image_nature = patch(data,N,no_nature,j);
    end

    % b)

    [coeffs_building,score_building,latent_building] = pca(sample_image_building);
    [coeffs_nature,score_nature,latent_nature] = pca(sample_image_nature);

    plot_pcs(coeffs_building);
    plot_pcs(coeffs_nature);

    % c)

    X = 1:256;
    Xi = 1:.1:256;
    Y_building = pchip(X,latent_building,Xi);

    figure;
    plot(Xi,Y_building,'-k');
    xlabel('Principal Component');
    ylabel('Eigenvalue');

    Y_nature = pchip(X,latent_nature,Xi);

    figure;
    plot(Xi,Y_nature,'-k');
    xlabel('Principal Component');
    ylabel('Eigenvalue');

    % d)

    colormap(gray);

    % process_image('imgpca/b6.jpg',coeffs_building);
    % process_image('imgpca/b2.jpg',coeffs_building);
    % process_image('imgpca/b1.jpg',coeffs_building);

    process_image('imgpca/n10.jpg',coeffs_nature);
    process_image('imgpca/n9.jpg',coeffs_nature);
    process_image('imgpca/n2.jpg',coeffs_nature);

end

function plot_pcs(coeffs)

    for j = 1:24

        matrix_rebuilt = reshape(coeffs(:,j),16,16)';

        subplot(4, 6, j);
        heatmap(matrix_rebuilt);
        caption = sprintf('Principal Component %d',j);
        title(caption,'FontWeight','normal','FontSize',8);

    end

end

function sample_image = patch(data,N,no,j)

    n = ceil(N/no);
    sample_image = zeros(N,256);

    for k = 1:n
        x = randsample(size(data,1)-15,1);
        y = randsample(size(data,2)-15,1);
        for l = 1:16
            sample_image(n*(j-1)+k,16*(l-1)+1:16*l) = data(x+(l-1),y:y+15);
        end
    end

end

function  process_image(file,coeffs)

    n = [1 2 4 8 16 100];

    image = imread(file);
    [image_n,image_m] = size(image);

    figure;
    colormap(gray);

    c = 1;
    for x = n

        image_patched = patch_image(image_n,image_m,image);
        image_patched_projected = project_patched_image(x,image_patched,coeffs);
        image_reconstructed = reconstruct_image(image_n,image_m,image_patched_projected);

        subplot(3,2,c);
        heatmap(image_reconstructed);

        c = c+1;

    end

end

function image_patched = patch_image(image_n,image_m,image)

    image_patched = zeros(512,256);

    c = 1;
    for k = 1:16:image_n-1
        for l = 1:16:image_m-1
            image_patched(c,:) = reshape(image(k:k+15,l:l+15)',[],1)';
            c = c+1;
        end
    end

end

function image_patched_projected = project_patched_image(n,image_patched, coeffs)

    [image_patched_n,image_patched_m] = size(image_patched);
    image_patched_projected = zeros(image_patched_n,image_patched_m);

    for k = 1:image_patched_n
        for l = 1:n
            image_patched_projected(k,:) = image_patched_projected(k,:) + coeffs(:,l)' * (image_patched(k,:) * coeffs(:,l));
        end
    end

end

function image_reconstructed = reconstruct_image(image_n,image_m,image_patched_projected)

    image_reconstructed = zeros(image_n,image_m);

    c = 1;
    for k = 1:16:image_n-1
        for l = 1:16:image_m-1
            image_reconstructed(k:k+15,l:l+15) = reshape(image_patched_projected(c,:)',16,16)';
            c = c+1;
        end
    end

end
