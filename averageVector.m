function [X,Y] = averageVector(vect,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize)
% AVERAGEVECTOR Creates the graph data to the average section
% Takes the three parts according to the user preferances and calculate them, then join them together to create the final tuple X,Y
% [X,Y] = AVERAGEVECTOR(...) return the tuple which will be presented in the graph as X,Y
% vect				The data that parsed and reshaped. Send in from the grsph function that the user would like to see
% headIterations	The number of iteration which includes in the "Head" group
% headGroupSize		Number of interations which we should "group" together to one point in the "Head" section
% middleIterations	The number of iteration which includes in the "Middle" group
% middleGroupSize	Number of interations which we should "group" together to one point in the "Middle" section
% tailGroupSize		Number of interations which we should "group" together to one point in the "Tail" section

if ~isrow(vect)
   error('MyComponent:incorrectType',...
       'Error. \nInput must be a row  vector.');
   %return;
end

head_x = [];
head_y = [];

if(headIterations > 0)
    head_y = mean(reshape(vect(1,1:headIterations),headGroupSize,headIterations/headGroupSize),1);
    head_x = headGroupSize:headGroupSize:headIterations;
end

middle_x = [];
middle_y = [];

if (middleIterations > 0)
    middle_y = mean(reshape(vect(1,1+headIterations:headIterations + middleIterations),middleGroupSize,middleIterations/middleGroupSize),1);
    middle_x = headIterations+middleGroupSize:middleGroupSize:headIterations+middleIterations;
end


tail_x = [];
tail_y = [];

tailIterations = size(vect,2)-headIterations-middleIterations; 
if(tailIterations > 0)
    tail_y = mean(reshape(vect(1,1+headIterations + middleIterations:size(vect,2)),tailGroupSize,tailIterations/tailGroupSize),1);
    tail_x = headIterations+middleIterations+tailGroupSize:tailGroupSize:size(vect,2);
end


X = [head_x,middle_x,tail_x];
Y = [head_y,middle_y,tail_y];


end

