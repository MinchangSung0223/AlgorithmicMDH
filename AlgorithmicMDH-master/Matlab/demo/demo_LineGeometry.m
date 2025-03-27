
%% Collinear
L1=Line([0,0,1],[0,0,0])
L2=Line([0,0,1],[0,0,1])

LG = LineGeometry(L1,L2,0.00001);
figure;drawLineGeometry(LG);

%% Distant
L1=Line([0,0,1],[0,0,0])
L2=Line([0,0,1],[1,0,0])

LG = LineGeometry(L1,L2,0.00001);
figure;drawLineGeometry(LG);


%% Intersected
L1=Line([0,0,1],[0,0,1])
L2=Line([0,1,0.5],[0,0,1])

LG = LineGeometry(L1,L2,0.00001);
figure;drawLineGeometry(LG);


%% Skewd
L1=Line([0,0,1],[0,0,1])
L2=Line([1,0,1],[1,0.5,1])

LG = LineGeometry(L1,L2,0.00001);
figure;drawLineGeometry(LG);

