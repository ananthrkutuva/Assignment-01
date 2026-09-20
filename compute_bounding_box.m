%Function that computes the bounding box of an oval
%INPUTS:
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%x_range: the x limits of the bounding box in the form [x_min,x_max]
%y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)

    %wrapper function that calls egg_wrapper1
    % Single input (S) function to characterize G value
    egg_wrapper_G1 = @(s) egg_wrapper_dxds(s,x0,y0,theta,egg_params);
    egg_wrapper_G2 = @(s) egg_wrapper_dyds(s,x0,y0,theta,egg_params);

    %you'll need to change this
    %you might even need multiple guesses
    %so that you can catch top/bottom/left/right points of egg
    %with multiple guesses, you will probably need a for loop!

    %Grid of Inital Guesses
    s_guesses = linspace(0, 1, 9);

    %apply root finding algorithm here to find value of s
    %corresponding to the top/bottom/left/right point of egg

    % Solver Input Parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 100000;
    dxmax = 1e7;
    
    % Store X and Y cord of local extrema
    x_coords = zeros(length(s_guesses)-1, 1);
    y_coords = zeros(length(s_guesses)-1, 1);

    for i = 1:length(s_guesses)-1
        s0 = s_guesses(i);
        s1 = s_guesses(i+1);

        % Finding Roots for X (Left and right bounds)
        s_root_x =  secant_solver(egg_wrapper_G1, s0, s1, dxtol, ftol, max_iter, dxmax );
    
        % Finding Roots for Y (Top and bottom bounds)
        s_root_y =  secant_solver(egg_wrapper_G2, s0, s1, dxtol, ftol, max_iter, dxmax);

        % Finding Location (X, Y for left right bounds)
        [V_x, ~] = egg_func(s_root_x,x0,y0,theta,egg_params);
        x_coords(i) = V_x(1);

        % Finding Location (X, Y for top bottom bounds)
        [V_y, ~] = egg_func(s_root_y,x0,y0,theta,egg_params);
        y_coords(i) = V_y(2);
    end

    %extract the bounding box from the extrema
    x_range = [min(x_coords), max(x_coords)];
    y_range = [min(y_coords) max(y_coords)];
end

%you may need to make additional wrapper functions
%(you need one for x coord of G and one for y coord)

%wrapper function that calls egg_func
%and only returns one scalar (instead of V and G)
%(single output)

% Wrapper for Finding Left and Right Local Extrema
function dxds = egg_wrapper_dxds(s,x0,y0,theta,egg_params)
    [~, G] = egg_func(s,x0,y0,theta,egg_params);
    
    % calculates the dxds for a given input s
    dxds = G(1);
end

% Wrapper for Finding Top and Bottom Local Extrema
function dyds = egg_wrapper_dyds(s,x0,y0,theta,egg_params)
    [~, G] = egg_func(s,x0,y0,theta,egg_params);
    
    % calculates the dyds for a given input s
    dyds = G(2);
end