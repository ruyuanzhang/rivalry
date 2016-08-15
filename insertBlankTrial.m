function new_order = insertBlankTrial(order,nblank)
% Insert some blank trials(0) into a stimulus order.
%
%[new_order] = insertBlankTrial(order,nblank)
%Input:
%   order: a vector that indexing the stimulus order
%   nblank(optional): a integer indexing number of blank trials
%
%output:
%   new_order: randomized order including all stimulus and blank trials and
%              fulfill two constraints below.
%
%We randominzed all stimulus order (including blank trials) but two
% constraint here.
%   1. Blank trials should not be at the very begining and the very end
%   2. Blank trials should not be consecutive.
%
% i.e.
% order=insertBlankTrial(1:10,3,[2 3 4]);
% history.
% 02/24/16, RZ create this function

if ~exist('order','var')||isempty(order)
    error('please input a correct stimulus order');
end

if ~exist('nblank','var')||isempty(nblank)
    nblank = 0;
end

tmp = horzcat(order, zeros(1,nblank));

% check the two constraints 
exitflag = 0;
while ~exitflag
    tmp=Shuffle(tmp);
    blankidx = find(tmp==0);
    if firstel(tmp)~=0 && lastel(tmp)~=0 && ~any(diff(blankidx)==1) 
        exitflag=1; 
    else
        continue;
    end        
end
new_order=insertel(order,zeros(1,nblank),find(tmp==0));



