# Benchmarking data generation using SPSS syntax

It's always useful to be able to test a new statistical algorithm with some easy-to-generate simulated data that you have some control over and can throw away at the end of the day.  The trouble with some generators I've seen is that the data are completely random, and therefore useless for testing predictive models.  So while working on SPSS, in an [eat your own dog food](https://en.wikipedia.org/wiki/Eating_your_own_dog_food) moment, I wrote one that's a little smarter using pure SPSS syntax (no calling R or Python).  

The basic idea behind it is that we posit a number of underlying, unobserved factors that all of the observed variables are (generalized) linearly related to.  The strength of the relationships is determined by randomly generated regression coefficients.  In this way, we can create a random dataset in which, by chance, *some* of the predictors will be related to the target (and each other), but we don't know in advance which relationships will exist, or how strong they will be (unless we're reusing a random seed).

## Usage

You need the two SPSS syntax files:
* data_creation_macros.sps, which does the actual work.  You shouldn't need to touch this one.
* creating_data.sps, which contains an example of how to use the createData macro defined in the other file.  In order to run this syntax: 
	+ Edit the path in the FILE HANDLE command to point to wherever you've put the code
	+ (Optionally) Set your own random seed or comment out that line in order to get a non-replicable dataset
	+ (Optionally) Edit the parameter values in the createData call to whatever you want
	
After running the creating_data.sps syntax, the Data Editor will contain the benchmarking data and can be used immediately.

## Extensions / Alternatives

Right now, the relationships between the target and predictors is pretty simple.  More generalized relationships could be added.

The structure of the data is also simple: each record is a separate, independent case.  Hierarchical structures could be added.

To be more generally useful, this code could also be ported to Python/R.  

