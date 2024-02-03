function [F,M,T] = spearread(FN)
% [F,M,T] = spearread(FN)
%    Read in a sinusoidal analysis file written by Michael
%    Klingbeil's SPEAR program, into Frequency and Magnitude
%    matrices suitable for synthtrax.m.  T is the actual time 
%    values for each column.
% 2010-02-14 Dan Ellis dpwe@ee.columbia.edu

%par-text-frame-format
%point-type index frequency amplitude
%partials-count 32
%frame-count 549
%frame-data
%0.124943 1 0 430.064423 0.001209
%0.134943 1 0 429.900024 0.002103
%0.144943 5 0 430.215668 0.003097 4 855.366638 0.002075 3 1742.146851 0.002967 2 2165.423096 0.001978 1 2565.337402 0.001767
%0.154943 9 0 431.365143 0.004033 4 865.541565 0.003474 8 1298.919067 0.001814 3 1743.450806 0.00

% Each line is: time nharmonics indx0 freq0 amp0 indx1 freq1 amp1 ...
% Not sure what indx indices do.. I guess they indicate similar
% tracks

f = fopen(FN);

s = fgetl(f);
if ~strcmp(s, 'par-text-frame-format')
  fclose(f);
  error([FN,' does not look like SPEAR harmonics file']);
end

s = fgetl(f);
assert(strcmp(s, 'point-type index frequency amplitude'));

C = textscan(f,'%s %d',1);
C1 = C(1);
s = C1{1};
assert(strcmp(s,'partials-count'));
C2 = C(2);
partials_count = C2{1};

C = textscan(f,'%s %d',1);
C1 = C(1);
s = C1{1};
assert(strcmp(s,'frame-count'));
C2 = C(2);
frame_count = C2{1};

s = fgetl(f); % blank after textscan
s = fgetl(f);
assert(strcmp(s,'frame-data'));

T = zeros(1,frame_count);
F = zeros(partials_count, frame_count);
M = zeros(partials_count, frame_count);

for frame = 1:frame_count
  s = fgetl(f);
  d = textscan(s,'%f');
  d = d{1};  % textscan returns cell array
  T(frame) = d(1);
  nharm = d(2);
  ii = d(3:3:end);
  ff = d(4:3:end);
  mm = d(5:3:end);
  F(ii+1,frame) = ff;
  M(ii+1,frame) = mm;
end

fclose(f);
