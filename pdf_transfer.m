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
function [DR] = pdf_transferND(D0, D1, Rotations, varargin)

nb_dims = size(D0,1);
nb_iterations = length(Rotations);

numvarargs = length(varargin);
if numvarargs > 1
    error('pdf_transfer:TooManyInputs', ...
        'requires at most 1 optional input');
end

optargs = {1};
optargs(1:numvarargs) = varargin;
[relaxation] = optargs{:};

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

    D0 = relaxation * (R \ (D0R_ - D0R)) + D0;
end

fprintf(repmat('\b',[1, length(verb)]))


DR = D0;

end

%%
% 1D - PDF Transfer
%
function f = pdf_transfer1D(pX,pY)
    nbins = max(size(pX));

    eps = 1e-6;
    PX = cumsum(pX + eps);
    PX = PX/PX(end);

    PY = cumsum(pY + eps);
    PY = PY/PY(end);

    % inversion

    %PX = [0 PX nbins] + small_damping;
    %PY = [0 PY nbins] + small_damping;

    f = interp1(PY, 0:nbins-1, PX, 'linear');
    f(PX<=PY(1)) = 0;
    f(PX>=PY(end)) = nbins-1;
    if sum(isnan(f))>0
        error('colour_transfer:pdf_transfer:NaN', ...
              'pdf_transfer has generated NaN values');
    end   
end

