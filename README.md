# Fortran implementation of Least-squares fit

##### This repo is for a Fortran practical in the M1 CompuPhys 2023/2024 Besancon






### Files / folder

**main.f90** is the main fortran program. It is responsible for handling the heavy calculations. Any questions about the computations will be answered here

**out.a** is a precompiled version of main.f90. 

**main_wrapper.py** is the python code handling automatic execution for the fits of graphs. It does not compile the code and uses the out.a present in the directory. 

**linear_reg.py** takes care of the linear regression part of the practical. Due to the lightweight nature of the calculations with only 5 pressures, we did not use fortran. It's quick and dirty but works.

**PDFs** you will find multiple PDFs in this repo, namely the subject, the seminar and the lab report that I made.

***.sh files** are helper files to compile and run the fortran program using a single line of code. They were used during development, I left them here in case someone needs something like that.

**output folder** is already populated with pre-computed data. You can delete the files and Fortran will regenrate them itself, or wherever you specified the output.

**readme_ress** contains the image for the readme.md

**data folder** contains the data provided for the practical.


### Usage

The main python wrapper can be used as is and will output the graphs itself. 

The fortran program, once compiled will need some arguments :
  the way that work is :
  compiled.out weight_type input_file output_file
  weight_type : ones or square
  input_file : path to the file
  output_file : path to the file

if weight_type is set to anything but square, it will compute the fits with 1 as weights, check your parameters.


### Additional note

The Fortran program works for spectrum of any lengths, as long as you have the RAM.