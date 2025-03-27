function ret = reciprocal_product(L1, L2)
    ret = dot(L1.z_hat,L2.v)+dot(L2.z_hat,L1.v);
end