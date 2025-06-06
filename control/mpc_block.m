function u_opt = mpc_block(input_vec)
    n = 4;
    xhat = input_vec(1:n);
    ref = input_vec(n+1:end);

%     persistent mpcobj

   
%     if isempty(mpcobj)
%         h = 0.01;
%         sys_d = load('sys_dupfilter.mat');
% 
% 
%         Np = 10; 
%         Nc = 5;  
%         mpcobj = mpc(sys_d, h, Np, Nc);
% 
%         setmpcsignals(mpcobj, 'MV', 1, 'MO', 1:4);
% 
%         mpcobj.Weights.ManipulatedVariables      = [0.0001];
%         mpcobj.Weights.ManipulatedVariablesRate = [0.1];
%         mpcobj.Weights.OutputVariables          = [0.0001, 10, 0.001, 0.001];
%         
%         mpcobj.MV(1).Min = -1;
%         mpcobj.MV(1).Max =  1;
% 
%         mpcobj.OV(1).Min = -(10/180)*pi;
%         mpcobj.OV(1).Max =  (10/180)*pi;
%         mpcobj.Model.Nominal.X = [0; 0; 0; 0];
%         mpcobj.Model.Nominal.U = 0;
%         mpcobj.Model.Nominal.Y = [0; 0; 0; 0];
%     end
    persistent mpcobj_loaded mpcobj
    if isempty(mpcobj_loaded)
        s = load('mpcobj_model.mat');
        mpcobj = s.mpcobj;
        mpcobj_loaded = true;
    end


    mpcstateobj = mpcstate(mpcobj);
    mpcstateobj.Plant = xhat;   
    mpcstateobj.LastMove = 0;   

    ref_signal = ref'; 

    u_opt = mpcmove(mpcobj, mpcstateobj, xhat, ref_signal);
end
