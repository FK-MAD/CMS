%% input

%group_l={[1,3,5],[2,4,6],7,8,[9,10],11,12,13,14,15,16,17,18,19,20,21,[22,23],24,25,[26,28,30],[27,29,31]}->21 interfaces
%group_l={[1:6],7,[8:11],12,13,[14:16],17,18,19,20,[21:24],25,[26:31]}->13 interfaces


% ---parallelization settings---
indata.num_workers=6; % number of workers to use
% ---


% ---optimization settings---
indata.num_modes=20; % number of first modes to use in error term between unreduced and reduced model
% ---


% ---matrix assembly settings---
% method of building the block-diagonal matrices. It might help with very
% big matrices that may not fit in RAM.
% 1 -> use files mats_S_k.mat, read variables in a for-loop and build the block-diagonal incrementally
% 2 -> use files mats_S_k.mat, read variables in a for-loop and build the block-diagonal once
% 3 -> use file mats_S.mat and build the block-diagonal once
indata.blkdiag_method=2;
% ---


% ---reduction method---
% without parametrization: 1=no interface reduction | 2=global interface reduction | 3=local interface reduction
% with parametrization:    4=no interface reduction | 5=global interface reduction | 6=local interface reduction
indata.reduction_I=6;
% ---


% ---use of static correction---
% 0=without static correction | 1=with static correction
indata.static=0;
% ---


% ---kept modes for component groups---
% method of calculating the kept modes
% 0=explicitly using n_id_S | 1=until the target eigenfrequency for each group is reached
indata.eigf.group.method=1; 

% all vectors have:
% rows=1
% columns>=number of component groups (will run normally if more columns than component groups exist)

% this is used if method=0
indata.n_id_S=50*ones(1,100); % kept fixed-interface normal modes for each group of components 

% this is used if method=1
r=2.5*ones(1,100); % multiplication constant used to define the target frequency
%r=2->max error=1.7%
%r=2.2->max error=1.7%
%r=2.3->max error=1.05%
%r=2.4->max error=0.85% | n_id_S=[1 1 1 5 3 3 3 2 3 3 5 1 3 3 2 1 1 1 1 1 1 1]
%r=2.5->max error=0.85% | n_id_S=[1 1 1 5 3 3 3 2 3 3 5 1 3 3 2 1 1 1 1 1 1 1]
%r=3->max error=0.56%

indata.eigf.group.multiplier=r;
indata.eigf.group.target=r*4.5; % target eigenfrequency (Hz) for each group of components

% this controls the way modes are searched
indata.eigf.group.max=500*ones(1,100); % maximum allowed number of modes
indata.eigf.group.step=50*ones(1,100); % increase in the number of calculated modes if target is not reached
indata.eigf.group.init=50*ones(1,100); % initial number of calculated modes
% ---


% ---stored modes for component groups---
% they are computed once and used when updating matrices during
% optimization of r. They should be enough to avoid solving the eigenproblem
% during optimization.
% If you don't want any stored modes select:
% indata.eigf.group.method_store=0 and
% indata.n_id_S_store=0*ones(1,100)

% everything here works similarly to kept modes (same logic)

indata.eigf.group.method_store=1; % 0 or 1

% this is used if method_store=0
indata.n_id_S_store=50*ones(1,100); % large values

% this is used if method_store=1
indata.eigf.group.target_store=20*4.5*ones(1,100); % large cutoff frequency

% this controls the way modes are searched
indata.eigf.group.max_store=500*ones(1,100); % large values
indata.eigf.group.step_store=50*ones(1,100); % large values
indata.eigf.group.init_store=50*ones(1,100); % large values
% ---


% ---kept modes for interfaces---
% method of calculating the kept modes
% 0=explicitly using n_IR (for global reduction) or n_IR_l (for local reduction) | 1=until the target eigenfrequency for each interface is reached
indata.eigf.interface.method=0;

% all vectors have:
% rows=1
% columns>=number of interfaces (will run normally if more columns than interfaces exist)

% if global interface reduction is selected:
% only the first element of the target, max, step and init vectors is used
% (there is only one interface)

% this is used if method=0 and global reduction is selected
indata.n_IR=36; % kept interface modes for all interfaces (global reduction)
% n_IR=31->max error=1.06%
% n_IR=32->max_error=1.06%
% n_IR=33->max_error=1.06%
% n_IR=34->max_error=1.06%
% n_IR=35 (v=2.36)->max_error=0.92%
% n_IR=36 (v=2.4)->max_error=0.92%

% this is used if method=0 and local reduction is selected
indata.n_IR_l=[9     8    28    39    12    59    37    33    21     5    37    11     5];%100*ones(1,100); % kept interface modes for each interface (local reduction)
% optimization for ub with cutoff (5 times)
% n_IR_l=[8     1    62    39     1    92    40    23    23     1    77   21     6]
% n_IR_l=[3     1    66    38     1    80    38    35    21     1    52   6    12]
% n_IR_l=[4     1    43    40     1    76    40    30    32     1    73   39    10]
% n_IR_l=[12     1    58    32     1    83    37    35    27     1    43   41    10]
% n_IR_l=[9     1    44    38     1    78    41    28    28     1    86   30     9]

% optimization for flat ub =100 for each (5 times)
% n_IR_l=[5     1    28    38     1    59    37    33    23    11    37    22     4]
% n_IR_l=[10     1    33    38     2    59    37    33    19     3    40     7     9]
% n_IR_l=[10     6    28    38     8    60    37    33    19     1    40    23     5]
% n_IR_l=[9     8    28    39    12    59    37    33    21     5    37    11     5]
% n_IR_l=[9     8    28    39    12    59    37    33    21     5    37    11     5]


% this is used if method=1
v=70.5*ones(1,100); % multiplication constant used to define the target frequency
% ~1% error-> dummy bridge: 3.5 for global=10 for local  | metsovo: 3 for global=70 for local | ten_param: 2 for global=13 for local
indata.eigf.interface.multiplier=v;
indata.eigf.interface.target=v*4.5; % target eigenfrequency (Hz) for each interface
% v=80 -> max error=0.85%
% v=70.5 -> max error=1.07% | n_IR_l=[11 1 63 37 1 92 36 33 37 1 78 38 11]

% this controls the way modes are searched
indata.eigf.interface.max=1000*ones(1,100); % maximum allowed number of modes
indata.eigf.interface.step=100*ones(1,100); % increase in the number of calculated modes if target is not reached
indata.eigf.interface.init=100*ones(1,100); % initial number of calculated modes
% ---


% ---stored modes for interfaces---
% they are computed once and used when updating matrices during
% optimization of v. They should be enough to avoid solving the eigenproblem
% during optimization.
% If you don't want any stored modes select:
% indata.eigf.interface.method_store=0 and indata.n_IR_l_store=0*ones(1,100)

% everything here works similarly to kept modes (same logic)

indata.eigf.interface.method_store=0; % 0 or 1

% this is used if method_store=0 and global reduction is selected
indata.n_IR_store=50; % for global reduction, large value

% this is used if method_store=0 and local reduction is selected
indata.n_IR_l_store=100*ones(1,100); % for local reduction, large values

% this is used if method_store=1
indata.eigf.interface.target_store=80*4.5*ones(1,100); % large cutoff frequency

% this controls the way modes are searched
indata.eigf.interface.max_store=500*ones(1,100); % large values
indata.eigf.interface.step_store=100*ones(1,100); % large values
indata.eigf.interface.init_store=100*ones(1,100); % large values
% ---


% ---material properties---
% all vectors have:
% rows>=number of component groups (will run normally if more columns than component groups exist)
% columns=1

indata.E=37*10^9*ones(22,1); % Young's modulus [Pa] for each group of components. most groups are deck components -> 37 GPa
indata.E([6,11,14])=34*10^9; % groups 6, 11 and 14 are piers -> 34 GPa
indata.E(18:22)=10^20; % groups 18 through 22 are soil -> 10^11 GPa

indata.nu=.2*ones(22,1); % Poisson's ratio. for deck and piers -> 0.2
indata.nu(18:22)=.3; % groups 18 through 22 are soil -> 0.3

indata.rho=2548*ones(22,1); % density [kg/m^3]. for deck and piers -> 2548 [kg/m^3]
indata.rho(18:22)=1800; % groups 18 through 22 are soil -> 1800 [kg/m^3]
% ---


% ---general parametrization settings---
% interpolation scheme used in interpolation of interface modes (global or local reduction)
indata.quad_interp=0; % 0=linear interpolation | 1=quadratic interpolation

% static correction method
indata.invariant=0; % 0=full static correction | 1=invariant assumption


% functions of the model parameters -> one entry for each model parameter
% func_g applies on mass matrix (see Eq. (2.3))
indata.func_g=repmat({@(x) 1},1,22);

% func_h applies on stiffnes matrix (see Eq. (2.4))
indata.func_h=repmat({@(x) x},1,22);


% vectors have:
% rows=number of model parameters
% columns=1

% sample point where reduced matrices are calculated [1.1 0.9 0.85 1.15]'.
% This is used to test the code. Normally, every sample point is generated
% during the stochastic simulation process.
indata.theta_k=[1 1 1 1 1 1 1 1 1 1]';

% nominal point used in the invariant assumption of static correction. See
% page 42.
indata.theta_nom=ones(22,1);

% nominal point used in interpolation of interface modes (global or local
% reduction). See page 50.
indata.theta_0=ones(22,1);
% ---


% ---settings concerning support points (if parametrization is used)---
% used in interpolation of interface modes (global or local reduction)

% 'scatter_theta_l' is the fraction of theta_0 that the support points are
% scattered around theta_0 (can be different for each parameter)
% e.g. for a model with 2 parameters and theta_0=[1;1]:
% scatter_theta_l(1)=.1 -> support of parameter 1=[.9,1.1]
% scatter_theta_l(2)=.2 -> support of parameter 2=[.8,1.2]
indata.scatter_theta_l=1*ones(length(indata.theta_0),1);

% 'simplex' -> for dimension n there are needed n+1 vertices to create the convex hull
% 1D -> 2 points -> line segment
% 2D -> 3 points -> triangle
% 3D -> 4 points -> tetrahedron
% 4D -> 5 points -> 5-cell (4-simplex)
% ...

% 'hypercube' -> for dimension n there are needed 2^n vertices to create the convex hull
% 1D -> 2 points -> line segment
% 2D -> 4 points -> square
% 3D -> 8 points -> cube
% 4D -> 16 points -> 4-cube (hypercube,tesseract)
% ...

% both methods provide as few support points as possible using smart 
% merging rules
indata.method_theta_l='simplex'; % 'simplex' or 'hypercube'

%indata.theta_l=mvnrnd(indata.theta_0,.02*eye(length(indata.theta_0)),10)'; % random sampling
%indata.theta_l=lhsnorm(indata.theta_k,.1*eye(length(indata.theta_0)),20)'; % latin hypercube sampling
%theta_l=[1.2 0.8 0.8 0.8;0.8 1.2 0.8 0.8;0.8 0.8 1.2 0.8;0.8 0.8 0.8 1.2]';
% ---


%% pass additional input data to structure "indata"

indata.filename=filename;
indata.save_dir=save_dir;

indata.S_0=S_0; % groups that are independent of model parameters
indata.S_j=S_j; % groups that depend of model parameters. cell 1,2,... contains the groups that depend on parameter 1,2,...
indata.n_theta=length(indata.S_j); % number of parameters. n_theta=length(func_g);
%indata.L=size(indata.theta_l,2); % number of support points

indata.group_S=group_S; % grouping of geometrical domains. cell 1,2,... contains the domains that make up group 1,2,...
indata.n_id=sum(indata.n_id_S); % total number of kept fixed-interface normal modes
indata.N_S=length(indata.group_S); % number of groups of components
indata.n_IRL=sum(indata.n_IR_l); % total number of kept interface modes using local reduction

indata.n_DIL=indata.n_id+indata.n_IRL; % dimension of reduced matrices if local reduction is used
indata.n_DI=indata.n_id+indata.n_IR; % dimension of reduced matrices if global reduction is used