%Function that computes the collision time for a thrown egg
%INPUTS:
%traj_fun: a function that describes the [x,y,theta] trajectory of the egg 
%(takes time t as input)
%egg_params: a struct describing the hyperparameters of the oval
%y_ground: height of the ground
%x_wall: position of the wall
%OUTPUTS:
%t_ground: time that the egg would hit the ground
%t_wall: time that the egg would hit the wall
function [t_ground,t_wall] = collision_func(egg_trajectory01, egg_params, y_ground, x_wall)
    d_g = @(t) ground_dist(t, egg_trajectory01, egg_params, y_ground);
    d_w = @(t) wall_dist(t, egg_trajectory01, egg_params, x_wall);

    x_guess0 = d_w(0);
    x_guess1 = d_w(2);
    y_guess0 = d_g(0);
    y_guess1 = d_g(2);
    
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 100000;
    dxmax = 1e7; %Newton and Secant only

    t_wall = secant_solver(d_w, x_guess0, x_guess1, dxtol, ftol, max_iter, dxmax);
    t_ground = secant_solver(d_g, y_guess0, y_guess1, dxtol, ftol, max_iter, dxmax);
end

function dist_ground = ground_dist(t, egg_trajectory01, egg_params, y_ground)
    [x0, y0, theta] = egg_trajectory01(t);
    [~, y_range] = compute_bounding_box(x0, y0, theta, egg_params);
    dist_ground = min(y_range) - y_ground;
end

function dist_wall = wall_dist(t, egg_trajectory01, egg_params, x_wall)
    [x0, y0, theta] = egg_trajectory01(t);
    [x_range, ~] = compute_bounding_box(x0, y0, theta, egg_params);
    dist_wall = max(x_range) - x_wall;
end