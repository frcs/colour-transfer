%
%   simple implementation of N-Dimensional PDF Transfer 
%
%   [DR] = pdf_transferND(D0, D1, rotations);
%
%     D0, D1 = NxM matrix containing N-dimensional features
%     rotations = { {R_1}, ... , {R_n} } with R_i PxN 
%
%     note that we can use more than N projection axes. In this case P > N
%     and the inverse transformation is done by least mean square. 
%     Using more than N axes leads to a more stable (but also slower) 
%     convergence.
%
%  (c) F. Pitie 2007
%
%  see reference:
%  Automated colour grading using colour distribution transfer. (2007) 
%  Computer Vision and Image Understanding.
%
function [DR] = pdf_transferND(D0, D1, Rotations)

nb_dims = size(D0,1);
nb_iterations = length(Rotations);

relaxation = 1;
DR = D0;

verb = '';

for it=1:nb_iterations
    fprintf(repmat('\b',[1, length(verb)]))
    verb = sprintf('IDT iteration %02d / %02d', it, nb_iterations);
    fprintf(verb);
    
    R = Rotations{it};    
    nb_projs = size(R,1);
    
    %% apply rotation
    
    D0R = R * D0;
    D1R = R * D1;

    %% find data range
    for i=1:nb_projs
        datamin(i) = min([D0R(i,:) D1R(i,:)]);
        datamax(i) = max([D0R(i,:) D1R(i,:)]);
    end

    %% get the marginals
    for i=1:nb_projs
        step =  (datamax(i) - datamin(i))/300;
        p0R{i} = hist(D0R(i,:), datamin(i):step:datamax(i));
        p1R{i} = hist(D1R(i,:), datamin(i):step:datamax(i));
    end

    %% match the marginals
    for i=1:nb_projs
        f{i} = pdf_transfer1D(p0R{i}, p1R{i});
        scale = (length(f{i})-1)/(datamax(i)-datamin(i));
        D0R_(i,:) = interp1(0:length(f{i})-1, f{i}', (D0R(i,:) - datamin(i))*scale)/scale + datamin(i);
    end

    D0 = relaxation * R \ (D0R_ - D0R) + D0;
end

fprintf(repmat('\b',[1, length(verb)]))


DR = D0;

end
%% 
%% 1D - PDF Transfer
%%
function f = pdf_transfer1D(pX,pY)
    nbins = max(size(pX));

    PX = cumsum(pX);
    PX = PX/PX(end);

    PY = cumsum(pY);
    PY = PY/PY(end);

    % inversion
    small_damping = (0:nbins+1)/nbins*1e-3;
    PX = [0 PX nbins] + small_damping;
    PY = [0 PY nbins] + small_damping;

    f = interp1(PY, [0 ((0:nbins-1)+1e-16) (nbins+1e-10)], PX,'linear');
    f = f(2:end-1);
end

