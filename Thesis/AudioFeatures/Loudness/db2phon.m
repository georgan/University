function [ ph ] = db2phon( dbspl, eqlcon, phonlevels )
%DB2PHON Compute phon from db
%   PH = DB2PHON(DBSPL,EQLCON,PHONLEVELS) estimates the loudness PH in phons
%   of a signal, from its energy DBSPL measured in decibells. DBSPL is a
%   DxN matrix containing in each row the energy of the signal at a
%   frequency band, and columns correspond to time instances of the short
%   time analysis. EQLCON is a DxP matrix of equal loudness contours as a
%   function of frequency. Each column represents a
%   different loudness level with value given from the corresponding
%   element in PHONLEVELS vector, which has P elements.




[nbands, nframes] = size(dbspl);

if size(eqlcon,1)~=nbands
    error('dbspl and eqlcon must have the same number of rows.');
end


ph = zeros(nbands, nframes);


conmax = max(eqlcon,[],2);
conmin = min(eqlcon,[],2);
for i = 1:nbands
    a = dbspl(i,:);
    a(a<conmin(i)) = conmin(i);
    ind = a>conmax(i);
    if sum(ind)>0
        fprintf(1,'Large values of loudness are observed.\n');
    end
    a(ind) = conmax(i);
    ph(i,:) = interp1(eqlcon(i,:), phonlevels, a); % interpolate the curves
end


end

