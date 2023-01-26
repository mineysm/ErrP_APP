function [CAR] = common_average_reference (ch, X)
    for i = 1:1:size(X,1)
        CAR(i) = ch(i) - mean (X(i,:));
    end
end