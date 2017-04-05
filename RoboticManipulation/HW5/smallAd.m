function [ adv ] = smallAd(v)

%input - v - 6 by 1 or 1 by 6
% output - ad(v), 6 by 6 
adv = zeros(6,6);

w = v(1:3);
v = v(4:6);
adv(1:3,1:3) = VecToso3(w);
adv(4:6,4:6) = VecToso3(w);
adv(4:6,1:3) = VecToso3(v);

end

