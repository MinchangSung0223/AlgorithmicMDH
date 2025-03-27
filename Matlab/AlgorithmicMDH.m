classdef AlgorithmicMDH
    
    % AlgorithmicMDH Class
    % 
    % 
    % 
    % Author: Minchang Sung 
    % E-mail: wdrac331@hanyang.ac.kr
    % Date: November 30, 2023    
    properties(Access=private)
        COLLINEAR = 1;
        DISTANT = 2;
        INTERSECTED = 3;
        SKEWED = 4;
        type_str_list = {'COLLINEAR','DISTANT','INTERSECTED','SKEWED'};
    end
    properties
        z_list;
        p_list;
        x_list;
        L_list;
        LG_list;
        x0
        epsilon
        MDH
    end
    
    methods
        function obj = AlgorithmicMDH(z_list,p_list,x0,epsilon)
            obj.z_list = z_list;
            obj.p_list = p_list;
            obj.x_list = {x0};
            obj.x0 =x0;
            obj.epsilon = epsilon;
            N = length(z_list)-2;
            obj.MDH.alpha=zeros(N-1,1);
            obj.MDH.a=zeros(N-1,1);
            obj.MDH.d=zeros(N-1,1);
            obj.MDH.theta=zeros(N-1,1);
            for i=2:1:N+1
                for j=i-1:1:i+1
                    p_j = p_list{j};
                    z_j = z_list{j};
                    obj.L_list{j}=Line(z_j,p_j);
                end
                LG_prev_i_i = LineGeometry(obj.L_list{i-1},obj.L_list{i},obj.epsilon);
                LG_i_next_i = LineGeometry(obj.L_list{i},obj.L_list{i+1},obj.epsilon);
                [alpha_prev_i_i,a_prev_i_i,n_prev_i_i,t_prev_i_prev_i,t_prev_i_i]=LG_prev_i_i.get_parameters();
                [alpha_i_next_i,a_i_next_i,n_i_next_i,t_i_i,t_i_next_i]=LG_i_next_i.get_parameters();
                z_prev_i = LG_prev_i_i.L1.z_hat;
                z_i = LG_prev_i_i.L2.z_hat;
                obj.LG_list{i-1}=LG_prev_i_i;

                x_prev_i = obj.x_list{end};
                x_i=zeros(3,1);
                if(LG_i_next_i.type==obj.COLLINEAR)
                    x_i=obj.x_list{end};
                else
                    x_i=n_i_next_i;
                end
                obj.x_list{end+1} = x_i;
                s_ix=1;
                if(norm(cross(z_prev_i,z_i))>obj.epsilon)
                    s_ix = dot(x_prev_i,n_prev_i_i)/norm(dot(x_prev_i,n_prev_i_i));
                end
                s_iz=1;
                if(norm(cross(x_prev_i,x_i))>obj.epsilon)
                    s_iz = dot(z_i,(cross(x_prev_i,x_i)))/norm(dot(z_i,(cross(x_prev_i,x_i))));
                end
                obj.MDH.alpha(i-1) = s_ix*alpha_prev_i_i;
                obj.MDH.a(i-1) = s_ix*a_prev_i_i;
                obj.MDH.d(i-1)= dot(z_i ,(t_i_i-t_prev_i_i));
                obj.MDH.theta(i-1) = s_iz*atan2(norm(cross(x_prev_i,x_i)),dot(x_prev_i,x_i));

            end
            

        end
    end
end
function ret = normvec(vec)
    ret = vec/norm(vec);
end

function ret = reciprocal_product(L1, L2)
    ret = dot(L1.z_hat,L2.v)+dot(L2.z_hat,L1.v);
end