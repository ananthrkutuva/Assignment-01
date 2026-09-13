function newton_sigmoid_convergence_plot()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 26;
    target_root = fzero(@test_function03,x0_ref);

    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-12;
    max_iter = 10000;
    dxmax = 1e7; %Newton and Secant only
    
    %Create an instance of the input_recorder
    my_recorder = input_recorder();
    
    %Use input_recorder to generate a version of the test function
    %that records the input after every iteration
    %Since test_fun is defined using function keyword
    f_record = my_recorder.generate_recorder_fun(@test_function03);
    
    %number of trials we would like to perform
    num_iter = 200;
    
    %list for the initial guesses that we would like
    %to use each trial. These guesses have all been chosen
    %so that each trial will converge to the same root
    %because the root is somewhere between-5 and 5.
    x0_list = linspace(0, 50, num_iter);
    
    %list of estimate at current iteration (x_{n})
    %compiled across all trials
    x_current_list = [];
    
    %list of estimate at next iteration (x_{n+1})
    %compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial
    %each data point was collected from
    index_list = [];

    % list of exit flags
    exit_flag_list = [];

    % list of function outputs
    % fun_outputs = [];
    
    %loop through each trial
    for n = 1:num_iter
        %pull out the guess for the trial
        x0 = x0_list(n);
    
        %reset input_list for the next test
        my_recorder.clear_input_list();
    
        %Call your root finder using the recording function:
        [~, exit_flag] = newton_solver(f_record, x0, dxtol, ftol, max_iter, dxmax);
    
        %See what input values were used when f_record was called:
        input_list = my_recorder.get_input_list();
    
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
        %append the collected data to the compilation
        
        exit_flag_list = [exit_flag_list, exit_flag];
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
        % fun_outputs = [fun_outputs, x_next_list(end)];
    end
    
    % plotting the new sigmoid test function
    figure; hold on;
    ax = gca;
    ax.FontSize = 30; % Changes tick labels and scales labels
    xvals = linspace(-50, 50, 201);
    [yvals,~] = test_function03(xvals);
    plot(xvals, yvals,'k','linewidth', 4, "DisplayName", "Sigmoid Function");
    xlabel('Function Input: x'); ylabel('Function Output: f(x)'); title("Newton's Method Guess Convergence Plot");
    xlim([0 50])
    ylim([-8 8])
    legend(location="southeast");
    
    % plotting the horizontal line for y = 0
    plot(xvals, 0*xvals,'k--','linewidth',1, "DisplayName", "Y = 0 Line");

    % plotting the actual root calculated by fzero
    scatter(target_root, test_function03(target_root), 300, "blue", "filled", DisplayName="Calculated Root Location")
    
    % for every iteration in the run, if the exit flag of that iteration is
    % a 1, plot the initial guess in cyan, if its 0, then plot the initial
    % guess in red
    for i = 1:num_iter
        if (exit_flag_list(i) == 1)
            scatter(x0_list(i), test_function03(x0_list(i)), 75, "cyan", "filled", "HandleVisibility", "off");
        else
            scatter(x0_list(i), test_function03(x0_list(i)), 75, "red", "filled", "HandleVisibility", "off");
        end
    end

    % makes only two legend entries for the successes and failures
    scatter(NaN, NaN, 75, "cyan", "filled", "DisplayName", "Successful Solver Run");
    scatter(NaN, NaN, 75, "red", "filled", "DisplayName", "Failed Solver Run");
end