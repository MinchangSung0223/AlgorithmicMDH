classdef LineGeometry
    %LINEGEOMETRY
    
    properties(Access=private)
        COLLINEAR = 1;
        DISTANT = 2;
        INTERSECTED = 3;
        SKEWED = 4;
        type_str_list = {'COLLINEAR','DISTANT','INTERSECTED','SKEWED'};
    end
    properties
        L1;
        L2;
        type;
        epsilon;        
        type_str;
        alpha;
        n_hat;
        t1;
        t2;
        a;
    end
    methods
        function obj = LineGeometry(L1,L2,epsilon)
            obj.epsilon = epsilon;
            obj.L1 = L1;
            obj.L2 = L2;
            obj.type=obj.get_type(obj.L1,obj.L2,obj.epsilon);
            obj.type_str=obj.type_str_list{obj.type};
            obj.alpha=obj.get_alpha(obj.L1,obj.L2,obj.epsilon);
            obj.n_hat = obj.get_n(obj.L1,obj.L2,obj.epsilon);
            obj.a = obj.get_a(obj.L1,obj.L2,obj.epsilon);
            [obj.t1,obj.t2]=obj.get_feets(L1,L2,epsilon);
        end
        function ret=Criterion1(obj,L1,L2,epsilon)
            if (norm(cross(L1.z_hat,L2.z_hat))<epsilon)
                ret = true;
            else
                ret = false;
            end
            
        end
        function ret=Criterion2_1(obj,L1,L2,epsilon)
            if(norm(L1.p_perp-L2.p_perp)<epsilon)
                ret = true;
            else
                ret = false;
            end
        end
        function ret=Criterion2_2(obj,L1,L2,epsilon)
            if(abs(reciprocal_product(L1,L2))<epsilon)
                ret = true;
            else
                ret = false;
            end
        end
        function ret=get_type(obj,L1,L2,epsilon)
                if(obj.Criterion1(L1,L2,epsilon))
                    if(obj.Criterion2_1(L1,L2,epsilon))
                        ret=obj.COLLINEAR;
                    else
                        ret=obj.DISTANT;
                    end
                else
                    if(obj.Criterion2_2(L1,L2,epsilon))
                       ret=obj.INTERSECTED;
                    else
                       ret=obj.SKEWED;
                    end
                end
        end
        function ret=get_alpha(obj,L1,L2,epsilon)
            ret=atan2(norm(cross(L1.z_hat,L2.z_hat)),dot(L1.z_hat,L2.z_hat));
        end
        function ret=get_n(obj,L1,L2,epsilon)
            type=obj.get_type(L1,L2,epsilon);
            if type==obj.COLLINEAR
                ret = zeros(3,1);
            elseif type==obj.DISTANT
                alpha = obj.get_alpha(L1,L2,epsilon);
                ret = L1.z_ceil*(cos(alpha)*L2.v-L1.v)./norm(L1.z_ceil*(cos(alpha)*L2.v-L1.v));                
            elseif type==obj.INTERSECTED
                ret = normvec(cross(L1.z_hat,L2.z_hat));
            elseif type==obj.SKEWED
                ret = normvec(cross(L1.z_hat,L2.z_hat));
            end
        end
        function [t1,t2]=get_feets(obj,L1,L2,epsilon)
            type=obj.get_type(L1,L2,epsilon);
            if type==obj.COLLINEAR
                t1 = L1.p;
                t2 = L1.p;
            elseif type==obj.DISTANT
                alpha = obj.get_alpha(L1,L2,epsilon);
                t1 = L1.p;
                t2 = L1.p+cross(L1.z_hat,(L2.v*cos(alpha)-L1.v));              
            elseif type==obj.INTERSECTED
                t1=(dot(L1.v,L2.z_hat).*eye(3)+L1.z_hat*L2.v'-L2.z_hat*L1.v')*cross(L1.z_hat,L2.z_hat)/norm(cross(L1.z_hat,L2.z_hat))^2;
                t2=t1;
            elseif type==obj.SKEWED
                t1=(cross(L1.v,cross(L2.z_hat,cross(L2.z_hat,L1.z_hat)))-dot(L2.v,cross(L2.z_hat,L1.z_hat))*L1.z_hat)/norm(cross(L1.z_hat,L2.z_hat))/norm(cross(L1.z_hat,L2.z_hat));
                t2=(cross(L2.v,cross(L1.z_hat,cross(L1.z_hat,L2.z_hat)))+dot(L1.v,cross(L2.z_hat,L1.z_hat))*L2.z_hat)/norm(cross(L2.z_hat,L1.z_hat))/norm(cross(L2.z_hat,L1.z_hat));

            % q1 = (L1.v_*L2.z_*L2.z_*L1.z - (L2.v'*L2.z_*L1.z)*L1.z)./norm(L1.z_*L2.z)^2;
            % q2 = (L2.v_*L1.z_*L1.z_*L2.z - (L1.v'*L1.z_*L2.z)*L2.z)./norm(L2.z_*L1.z)^2;                
            end
        end
        function ret=get_a(obj,L1,L2,epsilon)
            type=obj.get_type(L1,L2,epsilon);
            if type==obj.COLLINEAR
                ret = 0;
            elseif type==obj.DISTANT
                alpha = obj.get_alpha(L1,L2,epsilon);
                ret=norm(cross(L1.z_hat,(L2.v*cos(alpha)-L1.v)))  ;
            elseif type==obj.INTERSECTED
                ret=0;
            elseif type==obj.SKEWED
                ret=-reciprocal_product(L1,L2)/norm(cross(L1.z_hat,L2.z_hat));
            end
        end
        function [alpha,a,n_hat,t1,t2]=get_parameters(obj)
            alpha=obj.alpha;
            a=obj.a;
            n_hat=obj.n_hat;
            t1=obj.t1;
            t2=obj.t2;
        end
    end
end
function ret = normvec(vec)
    ret = vec/norm(vec);
end

function ret = reciprocal_product(L1, L2)
    ret = dot(L1.z_hat,L2.v)+dot(L2.z_hat,L1.v);
end