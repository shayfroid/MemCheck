function lables = generateLevelsLeggendLables(numOfLevels)
values = 0:numOfLevels-1;
lables=[];
for currentValue = values
    for otherValue = values
        if (otherValue == currentValue)
            continue;
        end
        lables = [lables;sprintf('%d-%d',currentValue,otherValue)];
    end
end