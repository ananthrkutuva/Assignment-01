function egg_animation(x_wall, y_ground, t_hit, egg_params)
    % sets the filepath
    mypath1 = 'C:\Users\akutuva\Documents\GitHub\Assignment-01\';
    fname='egg_animation.avi';
    input_fname = [mypath1,fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    open(writerObj); %must call open before writing any frames

    fig1 = figure(1);
    hold on;
    
    % sets the axis for animation
    axis([y_ground*2, x_wall*2, y_ground*2, x_wall*2]);

    % initial plot for egg and bounding box
    egg_plot = plot(0, 0, 'k', LineWidth=2);
    % box_plot = plot(0, 0, 'k');

    % axis equal;
    % axis square;
    
    % number of frames to simulate egg moving based on time to hit ground
    % or wall
    time_span = linspace(0, t_hit, 60);
    
    % steps through every second of the simulation
    for i = 1:length(time_span)
        t = time_span(i);

        % draws the wall and ground
        plot([x_wall x_wall], [y_ground, abs(x_wall)*2], 'k', LineWidth=2)
        plot([-30 x_wall], [y_ground, y_ground], 'k', LineWidth=2)

        % xline(x_wall, LineWidth=2)
        % yline(y_ground, LineWidth=2)

        % calculates the new x0 and y0 of the egg at that time step
        [x0, y0, theta] = egg_trajectory01(t);

        % divides the egg into 50 distinct coords
        s_vals = linspace(0, 1, 50);

        % calculates the x and y coord associated with each s value at that
        % x0 y0
        [V_vals, ~] = egg_func(s_vals, x0, y0, theta, egg_params);

        % updates the egg plotter with these x and y coords
        set(egg_plot, 'xdata', V_vals(1, :), 'ydata', V_vals(2, :));

        % redraws the screen with the new egg and new wall
        drawnow;

        %capture a frame (what is currently plotted)
        current_frame = getframe(fig1);

        %write the frame to the video
        writeVideo(writerObj,current_frame);
    end
    %must call close after all frames are written
    close(writerObj);
end