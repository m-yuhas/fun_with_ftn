% test_channel_matrix.m
%
% Test cases for channel_matrix.m.  If you are using MATLAB, these tests can
% be executed with the built-in runtests() function.  If you are using Octave,
% you will have to execute this script manually.

%% test_no_args
assert(Throws(channel_matrix()), '');

