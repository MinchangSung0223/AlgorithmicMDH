classdef Line
    %LINE 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        z
        z_hat
        p        
        p_perp
        v
        z_ceil
        v_ceil
    end
    
    methods
        function obj = Line(z,p)
            obj.z = reshape(z,[3,1]);
            obj.z_hat = reshape(normvec(z),[3,1]);
            obj.p = reshape(p,[3,1]);
            obj.v = cross(obj.p,obj.z_hat);
            obj.z_ceil=vecToso3(obj.z);
            obj.v_ceil=vecToso3(obj.v);
            obj.p_perp = cross(obj.z_hat,obj.v);
        end
        
    end
end
function ret = normvec(vec)
    ret = vec/norm(vec);
end
