function [count] = num_of_classes(data,ccolumn)
    temp = zeros(1);
    count = 0;
    for i = 1:size(data,1)
        item = data(i,ccolumn);
        if(sum(temp == item) == 0)
            temp(size(temp,1)+1) = item;
            count = count+1;
        end
    end
end