function recording_newton_method()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 0.5;
    target_root = fzero(@test_func01,x0_ref);

    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 10000;
    dxmax = 1e7; %Newton and Secant only
    
    %Create an instance of the input_recorder
    my_recorder = input_recorder();
    
    %Use input_recorder to generate a version of the test function
    %that records the input after every iteration
    %Since test_fun is defined using function keyword
    f_record = my_recorder.generate_recorder_fun(@test_func01);
    
    %number of trials we would like to perform
    num_iter = 1000;
    
    %list for the initial guesses that we would like
    %to use each trial. These guesses have all been chosen
    %so that each trial will converge to the same root
    %because the root is somewhere between-5 and 5.
    x0_list = linspace(-5,5,num_iter);
    
    %list of estimate at current iteration (x_{n})
    %compiled across all trials
    x_current_list = [];
    
    %list of estimate at next iteration (x_{n+1})
    %compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial
    %each data point was collected from
    index_list = [];
    
    %loop through each trial
    for n = 1:num_iter
        %pull out the left and right guess for the trial
        x0 = x0_list(n);
    
        %reset input_list for the next test
        my_recorder.clear_input_list();
    
        %Call your root finder using the recording function:
        newton_solver(f_record, x0, dxtol, ftol, max_iter, dxmax);
    
        %See what input values were used when f_record was called:
        input_list = my_recorder.get_input_list();
    
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
        %append the collected data to the compilation
    
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
    end
    
    %At this point, x_current_list corresponds to many many
    %measurements of x_{n} across many trials
    %and x_next_list corresponds to many many measurements of
    %the corresponding value of x_{n+1} across many trials
    %this is the data the you want to clean and analyze
      
    % current and next error lists
    e_n = abs(x_current_list - target_root);
    e_n1 = abs(x_next_list - target_root);
    
    % trim boundaries
    xmin = 2.06399e-6;
    xmax = 0.0189298;
    
    % mask to remove all values outside boundary
    mask = (e_n >= xmin) & (e_n <= xmax);
    
    % new trimmed error values
    e_n_new = e_n(mask);
    e_n1_new = e_n1(mask);
    
    % plotting the error values
    loglog(e_n, e_n1,'ro','markerfacecolor','r','markersize',5);
    hold on;
    
    % generating and plotting the fit line
    [p, k] = generate_error_fit(e_n_new, e_n1_new);
    fit_line_x = 10.^(-6:.01:-1);
    fit_line_y = k * fit_line_x .^ p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth', 3)
    hold off;
    ax = gca;
    ax.FontSize = 30; % Changes tick labels and scales labels
    title("Newton's Method Convergence Rate Plot")
    xlabel("\epsilon_{n} (-)")
    ylabel("\epsilon_{n+1} (-)")
    legend("Newton's Method Raw Error", "Filtered Convergence Fit Line", location="southeast")
    
    clf
    %example for how to plot fit line
    %generate x data on a logarithmic range
    fit_line_x = 10.^[-16:.01:1];
    %compute the corresponding y values
    fit_line_y = k*fit_line_x.^p;
    %plot on a loglog plot.
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
end