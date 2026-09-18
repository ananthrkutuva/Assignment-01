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

    %you may need to make additional wrapper functions
    %(you need one for x coord of G and one for y coord)

    %wrapper function that calls egg_wrapper1
    %but only takes s as an input (other inputs are fixed)
    %(single input)
    egg_wrapper2 = @(s) egg_wrapper1(s,x0,y0,theta,egg_params);

    %you'll need to change this
    %you might even need multiple guesses
    %so that you can catch top/bottom/left/right points of egg
    %with multiple guesses, you will probably need a for loop!
    s_guess = 0; 

    %apply root finding algorithm here to find value of s
    %corresponding to the top/bottom/left/right point of egg
    s_root =  newton_solver(egg_wrapper2, s_guess, )

    %plug s_root back into egg_func to find boundary point
    %[V_extrema,~] = egg_func(...


    %once you have computed a bunch of extrema points

    %You'll probably need additional code to determine if V_extrema
    %corrsponds to the top coord, bottom coord, left coord, or right coord
    %the sort function will be useful here

    %extract the bounding box from the extrema
    x_range = []; %you'll need to change this
    y_range = []; %you'll need to change this

    
end

%you may need to make additional wrapper functions
%(you need one for x coord of G and one for y coord)

%wrapper function that calls egg_func
%and only returns one scalar (instead of V and G)
%(single output)
function output_val = egg_wrapper1(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    
    output_val = V(1); %change this to be the correct thing!
end