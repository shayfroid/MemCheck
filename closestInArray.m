function x = closestInArray(arr,n)
% CLOSESTINARRAY search for the item in arr which is closest to n
% x = CLOSESTINARRAY(arr,n) returns arr's item closest to n as x.
% arr	1XN array of numbers
% n		number which acts as the pivot we search around

x = arr(1);
diff = abs(n-x);
for i = 2:size(arr,2)
    if(abs(n - arr(i)) < diff)
        x = arr(i);
        diff = abs(n - x);
    end
end
