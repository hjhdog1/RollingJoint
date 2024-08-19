function [robot, disp_error, tensions] = SolveRJMKin_disp(robot, displacements, tensions0)
% robot: robot struct
% tensions0: initial guess for tensions
% disp_error: tendon displacement error between input and computed
% tensions: tensions computed for given tendon displacements


    % numerical parameters
    stepsize_err = 1e-0;
    stepsize_tension = 1e-0;

    % looping
    tensions = tensions0;
    for i = 1:200
        
        % link transformations and load errors
        robot = propagateTransforms(robot);
        err = propagateLoadErrors(robot, tensions);
        
        % state updates
        [ds, df] = getUpdates(robot, err, tensions);

        % update robot
        robot.s = robot.s - stepsize_err*ds;
        robot.f = robot.f - stepsize_err*df;

        % gradient calculation of tendon lengths w.r.t. tensions
        robot = propagateTransforms(robot);
        err = propagateLoadErrors(robot, tensions);

        dt = 1e-3;
        tensions_l = tensions + [dt, 0];
        tensions_r = tensions + [0, dt];

        err_l = propagateLoadErrors(robot, tensions_l);
        err_r = propagateLoadErrors(robot, tensions_r);

        err_l = cellfun(@(x, y) x - y, err_l, err, 'UniformOutput', false);
        err_r = cellfun(@(x, y) x - y, err_r, err, 'UniformOutput', false);

        [ds_l, df_l] = getUpdates(robot, err_l, tensions_l);
        [ds_r, df_r] = getUpdates(robot, err_r, tensions_r);

        robot_l = robot;
        robot_l.s = robot_l.s - ds_l;
        robot_l.f = robot_l.f - df_l;
        robot_l = propagateTransforms(robot_l);
        tendon_lengths_l = getTendonLengths(robot_l);

        robot_r = robot;
        robot_r.s = robot_r.s - ds_r;
        robot_r.f = robot_r.f - df_r;
        robot_r = propagateTransforms(robot_r);
        tendon_lengths_r = getTendonLengths(robot_r);

        tendon_lengths = getTendonLengths(robot);

        g_l = (tendon_lengths_l - tendon_lengths)/dt;
        g_r = (tendon_lengths_r - tendon_lengths)/dt;
        G = [g_l; g_r];

        % update tensions
        dL = displacements - tendon_lengths;
        % tensions = tensions + 3e-1 * dL ./ [g_l(1), g_r(2)];
        % tensions = tensions +  (inv([g_l', g_r']) * dL')';
        % tensions = tensions +  dL/([g_l; g_r] + 1e3*eye(2));
        
        % dtau = dL * [g_l', g_r'];
        dtau = -stepsize_tension * dL/(G + 1e1*norm(G, 'fro')*eye(2));
        max_ratio = max(abs(dtau) ./ tensions);
        step_tau = 0.1;
        if max(abs(dtau) ./ tensions) > step_tau
            dtau = step_tau / max_ratio * dtau;
        end
        
        % update tensions, s, f
        tensions = tensions + dtau;

        robot.s = robot.s - dtau/dt * [ds_l; ds_r];
        robot.f = robot.f - dtau(1)/dt * df_l - dtau(2)/dt * df_r;


        
        % limit s
        for j = 1:robot.nLinks-1
            robot.s(j) = max(robot.s(j), robot.links{j}.child_surf_limit(1) + 1e-12);
            robot.s(j) = min(robot.s(j), robot.links{j}.child_surf_limit(2) - 1e-12);
        end
        
        % print
%         norm(err{3})

        % stepsize adjustment
        if i == 100
            stepsize_tension = 1e1*stepsize_tension;
        end
        
    end
    
    cell2mat(err)
    
    % final link transformations
    robot = propagateTransforms(robot);

    disp_error = dL;

end