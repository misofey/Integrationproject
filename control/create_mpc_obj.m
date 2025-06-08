function [mpcobj, state, empcobj, empcstate] = create_mpc_obj(sys_d, Np, Nc, generate_empc)
    
    mpcobj = mpc(sys_d, sys_d.Ts, Np, Nc);
    mpcobj.Weights.ManipulatedVariables = [0.001];      
    % mpcobj1.Weights.ManipulatedVariablesRate = [0.01];
    mpcobj.Weights.OutputVariables = [10, 0.001, 0.001, 0.001];
    mpcobj.Weight.ManipulatedVariablesRate = 0.0;
    mpcobj.MV(1).Min = -1;
    mpcobj.MV(1).Max = 1;
    
    mpcobj.OV(1).Min = -(10/180)*pi;
    mpcobj.OV(1).Max = (10/180)*pi;
    % mpcobj1.OV(2).Min = -100;
    % mpcobj1.OV(2).Max = 100;
    
    % [Kest, L] = kalman(sys_d, Q, R);
    % setEstimator(mpcobj, 'custom');
    % setmpcsignals(mpcobj1, 'MV', 1, 'MO', 1:4);
    
    mpcobj.Model.Nominal.X = [0; 0; 0; 0];
    mpcobj.Model.Nominal.U = 0;
    mpcobj.Model.Nominal.Y = [0; 0; 0; 0];
    state = mpcstate(mpcobj);
    % global mpcobj1
    if generate_empc
        range = generateExplicitRange(mpcobj);
        ubx = [3 10/180*pi 300 1];
        ubdx = [0 0 0 0];
        lbx = -ubx;
        lbdx = [0 0 0 0];
        range.State.Max = [ubx ubdx];
        range.State.Min = [lbx lbdx];
    
        range.ManipulatedVariable.Max = 1;
        range.ManipulatedVariable.Min = -1;
    
        empcobj = generateExplicitMPC(mpcobj, range);
        empcstate = mpcstate(empcobj);
    else
        empcobj = [];
        empcstate = [];
    end
end