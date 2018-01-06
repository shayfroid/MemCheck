function lables = generateLevelsLeggendLables(numOfLevels)
values = [0:numOfLevels-1];
%currentValueIndex = 1;
%lables = NaN(1,numOfLevels^2-numOfLevels)
lables=[];
for currentValue = values
    for otherValue = values
        if (otherValue == currentValue)
            continue;
        end
        lables = [lables;sprintf('%d-%d',currentValue,otherValue)];
    end
end