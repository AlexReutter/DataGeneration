* Set file handle for the location of data_creation_macros.
FILE HANDLE codeDirectory /NAME='C:\Github\DataGeneration\Benchmarking'.

* Choose a random number generator seed in order to create a replicable dataset, or comment this out.
SET RNG=MT MTINDEX=9141998.

* Grab the macros that create random factors.
INSERT FILE="codeDirectory/data_creation_macros.sps".

* Run the macro that creates the data.  Change the parameter values as desired.
* nRecords is the number of records 
* nFactors is the number of underlying unobserved factors used to create the data
* nContinuousPredictors is the number of continuous predictors
* nCategoricalPredictors is the number of categorical predictors
* nPredictorCategories is the number of categories in each categorical predictor
* nShortStringPredictors is the number of categorical string predictors of length 2
* nShortStringCategories is the number of categories in each "short string" predictor
* nLongStringPredictors is the number of categorical string predictors of length 15
* nLongStringCategories is the number of categories in each "long string" predictor
* nTargetCategories is the number of predictor categories in the categorical target
* createSplit is an indicator of whether to create a split field (1 = yes)
* nSplits is the number of categories of the split field.  For now, the split field is uncorrelated with any of the other fields.  This is fine for benchmarking.
.
createData 
	nRecords=1000 
	nFactors=2 
	nContinuousPredictors=0 
	nCategoricalPredictors=0 
	nPredictorCategories=3 
	nShortStringPredictors=10 
	nShortStringCategories=3 
	nLongStringPredictors=10 
	nLongStringCategories=5 
	createSplit=0 
	nSplits=5 
	nTargetCategories=2.

EXECUTE.


