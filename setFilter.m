function [filter] = setFilter(filter)

for i = 1:length(filter)-1
    filter(i) = filter(i + 1);
end

end