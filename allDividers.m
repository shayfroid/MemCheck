function x = allDividers(num)
% ALLDIVIDERS create an array of all the dividers of 'num'
% x = ALLDIVIDERS(num) returns a 1XN array of all of num's dividers as x

% first lets get the factorization of the number
fact = factor(num);

% subsets wll contain all the possible combinations of factors of num
subsets = combnk(fact,1);

res = subsets';

% for every possible length, generate all the possible subsets of factors of
% that length
for i = 2:size(fact,2)
    subsets = combnk(fact,i);
    res = [res,prod(subsets')];
end

x = unique(res);


