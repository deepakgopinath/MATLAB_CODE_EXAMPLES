
meas_ind =  find(mod_odom(:,4) == 0);
%number of control points between measurements
numcp = diff(find(mod_odom(:,4) == 0));

%remove 30% of the control points?

per_numcp = round(0.4999*numcp); %remove 49% of the data points. For computational purposes. 
ind_rem = [];
for i=1:length(meas_ind)-1
    s = meas_ind(i)+1;
    e = meas_ind(i+1)-1;
    indices = datasample(s:e, per_numcp(i), 'Replace', false);
    ind_rem = [ind_rem;indices'];  
end

mod_odom(ind_rem, :) = [];