function [ sum_rhs ] = bellman_rhs( currS, currA, V )


p = 0.4;
sh = currS + currA; %if you get heads then current captial goes up by the "action" amount
st = currS - currA;
if sh > 100
    sh =100;
end
if st < 0
    st = 0;
end
st = currS - currA; %if you get tail then current capital goes down by the "action" amount
gamma = 1;
%deal with the possibility of heads
if (sh == 100)
    sum_rhs = p*(1 + gamma*V(sh + 1)); %V(end) is the value for state 100.
else
    sum_rhs = p*(0 + gamma*V(sh + 1));
end

%now add the tails
sum_rhs = sum_rhs + (1-p)*(0 + gamma*V(st+1));

end

