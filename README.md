# Incorporating General Contact Surfaces in the Kinematics of Tendon-Driven Rolling-Contact Joint Mechanisms
<br>

MATLAB implementation of Rolling-Contact Joint Mechanism Kinematics with General Contact Surfaces


## Overview

This is a MATLAB code of Rolling-Contact Joint Mechanism Kinematics with General Contact Surfaces, the detailed algorithm of which is presented in the paper entitled "Incorporating General Contact Surfaces in the Kinematics of Tendon-Driven Rolling-Contact Joint Mechanisms" (under review).

The code is uploaded for review purpose now. The instruction and the code will be cleaned up once the paper is accepted.

* 6/14/2023: Scripts to plot Fig. 1, Fig. 3, Fig 4 in the first submission have been included (e.g., main_fig1.m, main_fig3.m, and main_fig4.m).
* (We express regret for the delayed code update. We believe that the updated code will better assist the reviewers in evaluating the paper.)

## Instruction
(See main_example.m for a simple animated example.)

1. Define cells of links, e.g.,
```
links{1} = buildLinkType1();
links{2} = buildLinkType2();
links{3} = buildLinkType3();
links{4} = buildLinkType4();
links{5} = buildLinkType5();
```
2. Build a robot by
```
robot = BuildRobot(links);
```
3. Define tendon tensions, e.g.,
```
tensions = [1, 2];
```
4. Solve Kinematics of the robot for the given tensions as
```
robot = SolveRJMKin(robot, tensions);
```
5. Plot result by
```
plotRJM(robot);
```
