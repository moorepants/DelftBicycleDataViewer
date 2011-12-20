%---------------------------------------------------------------------%
%    FILE: SENSOR_SUBTRACT.AL
%    DATE: JANUARY 8, 2009
%  AUTHOR: JASON MOORE
% PROBLEM: DERIVES THE EQUATIONS NECESSARY TO DETERMINE THE STEER,
%          LEAN, AND YAW RATES OF THE INSTRUMENTED BICYCLE
%   NOTES: 
%---------------------------------------------------------------------%
%         DEFAULT SETTINGS
%---------------------------------------------------------------------%

BEEPSOUND OFF
AUTOZ OFF
AUTORHS OFF
OVERWRITE ALL

%---------------------------------------------------------------------%
%         NEWTONIAN, BODIES, FRAMES, PARTICLES, POINTS
%---------------------------------------------------------------------%

% DECLARE THE INERTIAL REFERENCE FRAME

NEWTONIAN N

% DECLARE THREE INTERMEDIATE FRAMES
% A: YAW FRAME
% B: ROLL FRAME
% E: HEAD TUBE ANGLE FRAME

FRAMES A,B,E

% DECLARE SIX BODIES
% C: REAR WHEEL
% D: FRAME
% F: FORK
% G: FRONT WHEEL

BODIES C,D,F,G

%---------------------------------------------------------------------%
%         CONSTANTS AND VARIABLES
%---------------------------------------------------------------------%

% LAMBDA: STEER AXIS TILT                   [RAD]

CONSTANTS LAMBDA,YAW,ROLL,STEER

% DECLARE THE GENERALIZED COORDINATES
% Q1:  PERPENDICULAR DISTANCE FROM THE N2> AXIS TO THE REAR CONTACT
%      POINT IN THE GROUND PLANE
% Q2:  PERPENDICULAR DISTANCE FROM THE N1> AXIS TO THE REAR CONTACT
%      POINT IN THE GROUND PLANE
% Q3:  FRAME YAW ANGLE
% Q4:  FRAME ROLL ANGLE
% Q5:  REAR WHEEL ROTATION ANGLE
% Q6:  FRAME PITCH ANGLE
% Q7:  STEERING ROTATION ANGLE

VARIABLES Q{7}'

%---------------------------------------------------------------------%
%         ANGULAR RELATIONSHIPS                                       %
%---------------------------------------------------------------------%

% FRAME YAW

SIMPROT(N,A,3,Q3)

% FRAME ROLL

SIMPROT(A,B,1,Q4)

% REAR WHEEL ROTATION

SIMPROT(B,C,2,Q5)

% FRAME PITCH

SIMPROT(B,D,2,0)

% HEAD TUBE ANGLE

SIMPROT(D,E,2,LAMBDA)

% STEERING ANGLE

SIMPROT(E,F,3,Q7)


W_D_N> = -ROLL*D1> + YAW*D3>
W_F_N> = STEER*E3>

