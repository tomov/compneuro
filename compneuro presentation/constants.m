classdef constants
    properties (Constant = true)
        TIME_DELTA = 0.01;  % seconds
        X_DELTA = 0.01;
        MAX_X = 100;
        TIME_LAG_COEF = 1.3;
        TIME_FRAME = 5;
        X_FRAME = 20;
        MAX_TIME = 100;
        THETA = 10; % Hz
        BETA = 1;
        SPEED_DELTA = 0.2;
        SPEED_FACTOR = 1.1;
        SPEED_THRES = 0.1;
    end
end
