% function invT = InvSE2( T )
% 
% R = T(1:2,1:2)';
% p = -R*T(1:2,3);
% 
% invT = [R, p; 0,0,1];
% 
% end


function T = InvSE2( T )

% temp1 = T(1,2);
% temp2 = T(2,1);
% T(1,2) = temp2;
% T(2,1) = temp1;

% T(2) = -T(2);
% T(4) = -T(4);

temp = T(2);
T(2) = T(4);
T(4) = temp;

a = T(1,3); b = T(2,3);

T(1,3) = -T(1,1)*a - T(1,2) * b;
T(2,3) = -T(2,1)*a - T(2,2) * b;

end
