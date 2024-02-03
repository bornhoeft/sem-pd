function spearwrite(F,M,T,FN)
% spearwrite(F,M,T,FN)
%    Write a SPEAR-format sinusoidal parameter file.
%    F is a matrix of frequency values (each row is a sinusoid)
%    M is a matrix of corresponding magnitudes
%    T gives the time indices associated with each column.
%    FN is the file name to write to.
% 2011-02-16 Dan Ellis dpwe@ee.columbia.edu

fp = fopen(FN,'w');
if fp == 0
  error(['Unable to write file ',FN]);
else

  % write SPEAR header
  fprintf(fp,'par-text-frame-format\n');
  fprintf(fp,'point-type index frequency amplitude\n');
  fprintf(fp,'partials-count %d\n',size(F,1));
  fprintf(fp,'frame-count %d\n',size(F,2));
  fprintf(fp,'frame-data\n');
  % write out all the data frames
  for i = 1:length(T)
    nz = find(F(:,i)>0);
    fprintf(fp, '%.6f %d', T(i), length(nz));
    for rx = 1:length(nz)
      r = nz(rx);
      fprintf(fp, ' %d %.6f %.6f', r-1, F(r,i), M(r,i));
    end
    fprintf(fp, '\n');
  end
  % finish
  fclose(fp);
end  
