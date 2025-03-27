function drawT(T,line_lenth,line_width)
    p0= T*[0,0,0,1]';
    p0x= T*[line_lenth,0,0,1]';
    p0y= T*[0,line_lenth,0,1]';
    p0z= T*[0,0,line_lenth,1]';
    
    arrow3D([p0(1),p0(2) ,p0(3)] ,[p0x(1)-p0(1),p0x(2)-p0(2),p0x(3)-p0(3)], 'r', 0.9,line_width,1);  
    hold on;
    arrow3D([p0(1),p0(2) ,p0(3)] ,[p0y(1)-p0(1),p0y(2)-p0(2),p0y(3)-p0(3)], 'g', 0.9,line_width,1);  
    arrow3D([p0(1),p0(2) ,p0(3)] ,[p0z(1)-p0(1),p0z(2)-p0(2),p0z(3)-p0(3)], 'b', 0.9,line_width,1);  
    daspect([1,1,1])
end
function arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio,cylinderRadiusRatio,alpha)
% arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Used to plot a single 3D arrow with a cylindrical stem and cone arrowhead
%     pos = [X,Y,Z] - spatial location of the starting point of the arrow (end of stem)
%     deltaValues = [QX,QY,QZ] - delta parameters denoting the magnitude of the arrow along the x,y,z-axes (relative to 'pos')
%     colorCode - Color parameters as per the 'surf' command.  For example, 'r', 'red', [1 0 0] are all examples of a red-colored arrow
%     stemRatio - The ratio of the length of the stem in proportion to the arrowhead.  For example, a call of:
%                 arrow3D([0,0,0], [100,0,0] , 'r', 0.82) will produce a red arrow of magnitude 100, with the arrowstem spanning a distance
%                 of 82 (note 0.82 ratio of length 100) while the arrowhead (cone) spans 18.  
% 
%     Example:
%       arrow3D([0,0,0], [4,3,7]);  %---- arrow with default parameters
%       axis equal;
% 
%    Author: Shawn Arseneau
%    Created: September 14, 2006
%    Updated: September 18, 2006
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<2 || nargin>6
        error('Incorrect number of inputs to arrow3D');     
    end
    if numel(pos)~=3 || numel(deltaValues)~=3
        error('pos and/or deltaValues is incorrect dimensions (should be three)');
    end
    if nargin<3                 
        colorCode = 'interp';                               
    end
    if nargin<6                 
        stemRatio = 0.75;    
        cylinderRadiusRatio=1;
        alpha = 1;
    end    

    X = pos(1); %---- with this notation, there is no need to transpose if the user has chosen a row vs col vector
    Y = pos(2);
    Z = pos(3);
    
    [sphi, stheta, srho] = cart2sph(deltaValues(1), deltaValues(2), deltaValues(3));  
    
    %******************************************* CYLINDER == STEM *********************************************
    cylinderRadius = 0.01*cylinderRadiusRatio*srho;
    cylinderLength = srho*stemRatio;
    [CX,CY,CZ] = cylinder(cylinderRadius);      
    CZ = CZ.*cylinderLength;    %---- lengthen
    
    %----- ROTATE CYLINDER
    [row, col] = size(CX);      %---- initial rotation to coincide with X-axis
    
    newEll = rotatePoints([0 0 -1], [CX(:), CY(:), CZ(:)]);
    CX = reshape(newEll(:,1), row, col);
    CY = reshape(newEll(:,2), row, col);
    CZ = reshape(newEll(:,3), row, col);
    
    [row, col] = size(CX);    
    newEll = rotatePoints(deltaValues, [CX(:), CY(:), CZ(:)]);
    stemX = reshape(newEll(:,1), row, col);
    stemY = reshape(newEll(:,2), row, col);
    stemZ = reshape(newEll(:,3), row, col);

    %----- TRANSLATE CYLINDER
    stemX = stemX + X;
    stemY = stemY + Y;
    stemZ = stemZ + Z;
    
    %******************************************* CONE == ARROWHEAD *********************************************
    coneLength = srho*(1-stemRatio);
    coneRadius = cylinderRadius*1.5;
    incr = 4;  %---- Steps of cone increments
    coneincr = coneRadius/incr;    
    [coneX, coneY, coneZ] = cylinder(cylinderRadius*2:-coneincr:0);  %---------- CONE 
    coneZ = coneZ.*coneLength;
    
    %----- ROTATE CONE 
    [row, col] = size(coneX);    
    newEll = rotatePoints([0 0 -1], [coneX(:), coneY(:), coneZ(:)]);
    coneX = reshape(newEll(:,1), row, col);
    coneY = reshape(newEll(:,2), row, col);
    coneZ = reshape(newEll(:,3), row, col);
    
    newEll = rotatePoints(deltaValues, [coneX(:), coneY(:), coneZ(:)]);
    headX = reshape(newEll(:,1), row, col);
    headY = reshape(newEll(:,2), row, col);
    headZ = reshape(newEll(:,3), row, col);
    
    %---- TRANSLATE CONE
    V = [0, 0, srho*stemRatio];    %---- centerline for cylinder: the multiplier is to set the cone 'on the rim' of the cylinder
    Vp = rotatePoints([0 0 -1], V);
    Vp = rotatePoints(deltaValues, Vp);
    headX = headX + Vp(1) + X;
    headY = headY + Vp(2) + Y;
    headZ = headZ + Vp(3) + Z;
    %************************************************************************************************************    
    hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none','FaceAlpha',alpha); 
    hold on;  
    hHead = surf(headX, headY, headZ, 'FaceColor', colorCode, 'EdgeColor', 'none','FaceAlpha',alpha);
    
    if nargout==1   
        arrowHandle = [hStem, hHead]; 
    end
    

end

function rotatedData = rotatePoints(alignmentVector, originalData)

% rotatedData = rotatePoints(alignmentVector, originalData) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Rotate the 'originalData' in the form of Nx2 or Nx3 about the origin by aligning the x-axis with the alignment vector
% 
%       Rdata = rotatePoints([1,2,-1], [Xpts(:), Ypts(:), Zpts(:)]) - rotate the (X,Y,Z)pts in 3D with respect to the vector [1,2,-1]
% 
%       Rotating using spherical components can be done by first converting using [dX,dY,dZ] = cart2sph(theta, phi, rho);  alignmentVector = [dX,dY,dZ];
% 
% Example:
%   %% Rotate the point [3,4,-7] with respect to the following:
%   %%%% Original associated vector is always [1,0,0]
%   %%%% Calculate the appropriate rotation requested with respect to the x-axis.  For example, if only a rotation about the z-axis is
%   %%%% sought, alignmentVector = [2,1,0] %% Note that the z-component is zero
%   rotData = rotatePoints(alignmentVector, [3,4,-7]);
% 
%     Author: Shawn Arseneau
%     Created: Feb.2, 2006
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    alignmentDim = numel(alignmentVector);
    DOF = size(originalData,2); %---- DOF = Degrees of Freedom (i.e. 2 for two dimensional and 3 for three dimensional data)
    
    if alignmentDim~=DOF    
        error('Alignment vector does not agree with originalData dimensions');      
    end
    if DOF<2 || DOF>3      
        error('rotatePoints only does rotation in two or three dimensions');        
    end
    
        
    if DOF==2  % 2D rotation...        
        [rad_theta, rho] = cart2pol(alignmentVector(1), alignmentVector(2));    
        deg_theta = -1 * rad_theta * (180/pi);
        ctheta = cosd(deg_theta);  stheta = sind(deg_theta);
        
        Rmatrix = [ctheta, -1.*stheta;...
                   stheta,     ctheta];
        rotatedData = originalData*Rmatrix;        
        
    else    % 3D rotation...        
        [rad_theta, rad_phi, rho] = cart2sph(alignmentVector(1), alignmentVector(2), alignmentVector(3));
        rad_theta = rad_theta * -1; 
        deg_theta = rad_theta * (180/pi);
        deg_phi = rad_phi * (180/pi); 
        ctheta = cosd(deg_theta);  stheta = sind(deg_theta);
        Rz = [ctheta,   -1.*stheta,     0;...
              stheta,       ctheta,     0;...
              0,                 0,     1];                  %% First rotate as per theta around the Z axis
        rotatedData = originalData*Rz;

        [rotX, rotY, rotZ] = sph2cart(-1* (rad_theta+(pi/2)), 0, 1);          %% Second rotation corresponding to phi
        rotationAxis = [rotX, rotY, rotZ];
        u = rotationAxis(:)/norm(rotationAxis);        %% Code extract from rotate.m from MATLAB
        cosPhi = cosd(deg_phi);
        sinPhi = sind(deg_phi);
        invCosPhi = 1 - cosPhi;
        x = u(1);
        y = u(2);
        z = u(3);
        Rmatrix = [cosPhi+x^2*invCosPhi        x*y*invCosPhi-z*sinPhi     x*z*invCosPhi+y*sinPhi; ...
                   x*y*invCosPhi+z*sinPhi      cosPhi+y^2*invCosPhi       y*z*invCosPhi-x*sinPhi; ...
                   x*z*invCosPhi-y*sinPhi      y*z*invCosPhi+x*sinPhi     cosPhi+z^2*invCosPhi]';

        rotatedData = rotatedData*Rmatrix;        
    end

end