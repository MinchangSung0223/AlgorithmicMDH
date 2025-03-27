function omg = vecToso3(w)
% @Brief: Ceil opreator on so3
% @Params: 
%   w: A angular velocity (3 by 1 vector)
% @Returns:
%   omg: The corresponding matrix so(3) (3 by 3 matrix)
%
% @Example: 
% clear; clc;
% w= [1; 2; 3];
% omg = vecToso3(w)
%
% Output:
% omg =
% 
%      0    -3     2
%      3     0    -1
%     -2     1     0

x = w(1);
y = w(2);
z = w(3);

omg = [ 0, -z,  y;
        z,  0, -x;
        -y, x, 0 ];
end