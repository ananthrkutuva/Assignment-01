function egg_animation(x_wall, y_ground, t_hit, egg_params)
    % sets the filepath
    mypath1 = 'C:\Users\akutuva\Documents\GitHub\Assignment-01\';
    fname='egg_animation.avi';
    input_fname = [mypath1,fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    writerObj.FrameRate = 60;
    open(writerObj); %must call open before writing any frames

    fig1 = figure(1);
    hold on;
    
    % sets the axis for animation
    axis([y_ground*2, x_wall*2, y_ground*2, x_wall*2]);

    % initializes the empty plot object for the egg
    egg_plot = plot(0, 0, 'k', 'LineWidth', 2, 'HandleVisibility', 'off');

    % number of time frames to simulate egg moving based on 
    num_frames = round(60 * t_hit);
    time_span = linspace(0, t_hit, num_frames);

    % plots the starting location of the egg
    [x0, y0, ~] = egg_trajectory01(0);
    plot(x0, y0, 'x', 'MarkerSize', 20, 'MarkerFaceColor', 'blue', ...
        'MarkerEdgeColor', 'blue', ...
        'DisplayName', 'Starting Location of Egg');

    % draws the wall and ground
    plot([x_wall x_wall], [y_ground, abs(x_wall)*2], 'Color', '#A52A2A', 'LineWidth', 3, 'DisplayName', 'Wall')
    plot([y_ground*2 x_wall], [y_ground, y_ground], 'k', 'LineWidth', 3, 'DisplayName', 'Ground')

    lgd = legend('Location', 'northwest', 'Interpreter', 'latex');
    lgd.AutoUpdate = 'off';
    ax = gca;
    ax.FontSize = 30; % Changes tick labels and scales labels
    title('Egg Animation', 'Interpreter', 'latex')
    xlabel('X Location (-)', 'Interpreter', 'latex')
    ylabel('Y Location (-)', 'Interpreter', 'latex')
    grid on;

    % steps through each of the 50 time frames of the simulation
    for i = 1:length(time_span)
        t = time_span(i);

        % calculates the new x0 and y0 of the egg at that time step
        [x0, y0, theta] = egg_trajectory01(t);

        % divides the egg into 50 distinct coords
        s_vals = linspace(0, 1, 50);

        % calculates the x and y coord associated with each s value at that
        % x0 y0
        [V_vals, ~] = egg_func(s_vals, x0, y0, theta, egg_params);

        % updates the egg plotter with these x and y coords
        set(egg_plot, 'xdata', V_vals(1, :), 'ydata', V_vals(2, :));

        % redraws the screen with the updated egg position
        drawnow;
        
        %capture a frame (what is currently plotted)
        current_frame = getframe(fig1);

        %write the frame to the video
        writeVideo(writerObj,current_frame);
    end

    % plotting the final location of the egg
    lgd.AutoUpdate = 'on';
    [x0, y0, ~] = egg_trajectory01(t_hit);
    plot(x0, y0, 'x', 'MarkerSize', 20, 'MarkerFaceColor', 'red', ...
        'MarkerEdgeColor', 'red', ...
        'DisplayName', 'Ending Location of Egg');
    
    %capture a frame (what is currently plotted)
    current_frame = getframe(fig1);

    %write the frame to the video
    for i=1:120
        writeVideo(writerObj,current_frame);
    end
    %must call close after all frames are written
    close(writerObj);
end