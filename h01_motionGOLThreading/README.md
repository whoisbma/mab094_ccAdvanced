## Homework 1
#### 09.11.14
#### Creative Coding Advanced

_Pick a former project in either Open Frameworks or Processing._

_Using the topics discussed in class, enhance your project using two of the following:_

_Memory Retention_
_Threads_
_Dynamic Data Structures_

This Processing sketch is a combined motion-differencer and Conway's game of life simulation (cobbled together from Golan Levin and the default Processing GOL example) where new cells are generated based on motion picked up by the computer's camera over a certain threshold.

- Added thread process for the main analysis of the camera data
- Added a blur effect in a GLSL shader, loosely modified off the Processing blur example (for fun)
