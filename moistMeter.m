function [moistLevel] = moistMeter(average)

moistLevel = (-1/1.7)*average + (37/17);

end