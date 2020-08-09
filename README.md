![splash image](.demo_images/splash-06.png)
# SOS-hex: Hexehedral Quality and Repair with Sum-of-Squares

Source code for the paper ["Hexahedral Mesh Repair via SOS Relaxation"](http://people.csail.mit.edu/jsolomon/assets/sos_hex.pdf) by Zoë Marschner, David Palmer, Paul Zhang, and Justin Solomon from Symposium on Geometry Processing 2020.

> 1. [Installation](#installation)
> 2. [Examples](#examples)
> 3. [Documentation](#documentation)

## Installation
Clone this repository and then run the following commands in matlab
```
addpath(genpath(<SOS-hex>))
savepath
```
where `SOS-hex` is the path to the root of this repository.
### Dependencies
This code uses the library **Yalmip**, which can be downloaded [here](https://yalmip.github.io/download/) and the solver **Mosek**, which can be downloaded [here](https://www.mosek.com/downloads/).
## Examples
### Validity of a Single Hex
The following code will calculate the minimum jacobian determinant and the point at which this minimum occurs for a single random hex
```
V = rand_hex;
res = SOS_jacobian_single_hex(V);
disp("min of |D(x)| is %0.5e", res.lambda);
disp("the argmin of |D(x)| is " + mat2str(res.opt_pt(1)));
``` 
### Validity of vtk Model
### Validity of Subset Mesh Hexes
### Repairing vtk Model

## Documentation
### I/O and Visualization
### Validity
### Repair
