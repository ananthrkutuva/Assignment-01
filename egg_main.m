function egg_main()
    close all;
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    % set ground and wall distances
    y_ground = -15;
    x_wall = 50;
    
    % calculating time to either hit ground or wall
    [t_ground, t_wall] = collision_func(@egg_trajectory01, egg_params, y_ground, x_wall);

    if t_wall < t_ground
        t_hit = t_wall;
    else
        t_hit = t_ground;
    end

    egg_animation(x_wall, y_ground, t_hit, egg_params)
end