DEFINE createFactorMeans(nFactors = !TOKENS(1)).
   DO REPEAT #factorMean=#factorMean_1 TO !CONCAT('#factorMean_',!nFactors).
      COMPUTE #factorMean = rv.normal( 0, 4 ).
   END REPEAT.
!ENDDEFINE.

DEFINE createFactors(nFactors = !TOKENS(1)).
   !DO !iFactors = 1 !TO !nFactors.
      COMPUTE !CONCAT('#factor_',!iFactors) = rv.normal( !CONCAT('#factorMean_',!iFactors), 1 ).
   !DOEND.
!ENDDEFINE.

DEFINE createContinuousPredictorCoefficients(nFactors = !TOKENS(1) 
                                             /nContinuousPredictors = !TOKENS(1)).
   !DO !iFactors = 1 !TO !nFactors.
      DO REPEAT !CONCAT('#coeff_',!iFactors)=!CONCAT('#coeff_',!iFactors,'_1') TO !CONCAT('#coeff_',!iFactors,'_',!nContinuousPredictors).
         COMPUTE !CONCAT('#coeff_',!iFactors) = rv.normal( 0, 1 ).
      END REPEAT.
   !DOEND
!ENDDEFINE.

DEFINE createContinuousPredictors(nFactors = !TOKENS(1) 
                                  /nContinuousPredictors = !TOKENS(1)).
   !DO !iPredictors = 1 !TO !nContinuousPredictors.
      COMPUTE !CONCAT('continuousPredictor_',!iPredictors) = rv.normal(0,2).
      !DO !iFactors = 1 !TO !nFactors.
        COMPUTE !CONCAT('continuousPredictor_',!iPredictors) = !CONCAT('continuousPredictor_',!iPredictors)
             + !CONCAT('#coeff_',!iFactors,'_',!iPredictors) * !CONCAT('#factor_',!iFactors).
      !DOEND.
      COMPUTE !CONCAT('continuousPredictor_',!iPredictors) = 0.01*trunc(100*!CONCAT('continuousPredictor_',!iPredictors))
   !DOEND
!ENDDEFINE.

DEFINE createCategoricalPredictorCoefficients(nFactors = !TOKENS(1) 
                                             /nCategoricalPredictors = !TOKENS(1)
                                             /nPredictorCategories = !TOKENS(1) ).
   !DO !iFactors = 1 !TO !nFactors.
      !DO !iPredictors = 1 !TO !nCategoricalPredictors.
         !DO !iCategories = 1 !TO !nPredictorCategories.
            COMPUTE !CONCAT('#coeff_',!iFactors,'_',!iPredictors,'_',!iCategories) = rv.normal( 0, 1 ).
         !DOEND
      !DOEND
   !DOEND
!ENDDEFINE.

DEFINE createCategoricalPredictors(nFactors = !TOKENS(1) 
                                  /nCategoricalPredictors = !TOKENS(1)
                                  /nPredictorCategories = !TOKENS(1) ).
   !DO !iPredictors = 1 !TO !nCategoricalPredictors.
      !DO !iCategories = 1 !TO !nPredictorCategories.
         COMPUTE !CONCAT('#zcat_',!iCategories) = rv.normal( 0,1 ).
         !DO !iFactors = 1 !TO !nFactors.
            COMPUTE !CONCAT('#zcat_',!iCategories) = !CONCAT('#zcat_',!iCategories) 
               + !CONCAT('#coeff_',!iFactors,'_',!iPredictors,'_',!iCategories) * !CONCAT('#factor_',!iFactors).
         !DOEND.
      !DOEND.
      COMPUTE #max_zcat = #zcat_1.
      COMPUTE !CONCAT('categoricalPredictor_',!iPredictors) = 1.
      !DO !iCategories = 2 !TO !nPredictorCategories.
         DO IF ( !CONCAT('#zcat_',!iCategories) > #max_zcat ).
            COMPUTE #max_zcat = !CONCAT('#zcat_',!iCategories).
            COMPUTE !CONCAT('categoricalPredictor_',!iPredictors) = !iCategories.
         END IF.
      !DOEND.
      VARIABLE LEVEL !CONCAT('categoricalPredictor_',!iPredictors) (NOMINAL).
   !DOEND.
!ENDDEFINE.

DEFINE createShortStringPredictorCoefficients(nFactors = !TOKENS(1) 
                                             /nShortStringPredictors = !TOKENS(1)
                                             /nShortStringCategories = !TOKENS(1) ).
   !DO !iPredictors = 1 !TO !nShortStringPredictors.
      !DO !iCategories = 1 !TO !nShortStringCategories.
         !DO !iFactors = 1 !TO !nFactors.
            COMPUTE !CONCAT('#coeffShortString_',!iFactors,'_',!iPredictors,'_',!iCategories) = rv.normal( 0, 1 ).
         !DOEND
         string !CONCAT('#ShortStringValue_',!iPredictors,'_',!iCategories) (a2).
         LOOP #j = 1 to 2.
            COMPUTE substr(!CONCAT('#ShortStringValue_',!iPredictors,'_',!iCategories),#j,1) = substr('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',trunc(uniform(62))+1,1).
         END LOOP.
      !DOEND
   !DOEND
!ENDDEFINE.

DEFINE createShortStringPredictors(nFactors = !TOKENS(1) 
                                  /nShortStringPredictors = !TOKENS(1)
                                  /nShortStringCategories = !TOKENS(1) ).
   !DO !iPredictors = 1 !TO !nShortStringPredictors.
      string !CONCAT('shortStringPredictor_',!iPredictors) (a2).
      !DO !iCategories = 1 !TO !nShortStringCategories.
         COMPUTE !CONCAT('#zcat_',!iCategories) = rv.normal( 0,1 ).
         !DO !iFactors = 1 !TO !nFactors.
            COMPUTE !CONCAT('#zcat_',!iCategories) = !CONCAT('#zcat_',!iCategories) 
               + !CONCAT('#coeffShortString_',!iFactors,'_',!iPredictors,'_',!iCategories) * !CONCAT('#factor_',!iFactors).
         !DOEND.
      !DOEND.
      COMPUTE #max_zcat = #zcat_1.
      COMPUTE !CONCAT('shortStringPredictor_',!iPredictors) = !CONCAT('#ShortStringValue_',!iPredictors,'_1').
      !DO !iCategories = 2 !TO !nShortStringCategories.
         DO IF ( !CONCAT('#zcat_',!iCategories) > #max_zcat ).
            COMPUTE #max_zcat = !CONCAT('#zcat_',!iCategories).
            COMPUTE !CONCAT('shortStringPredictor_',!iPredictors) = !CONCAT('#ShortStringValue_',!iPredictors,'_',!iCategories).
         END IF.
      !DOEND.
      VARIABLE LEVEL !CONCAT('shortStringPredictor_',!iPredictors) (NOMINAL).
   !DOEND.
!ENDDEFINE.


DEFINE createLongStringPredictorCoefficients(nFactors = !TOKENS(1) 
                                            /nLongStringPredictors = !TOKENS(1)
                                            /nLongStringCategories = !TOKENS(1) ).
   !DO !iPredictors = 1 !TO !nLongStringPredictors.
      !DO !iCategories = 1 !TO !nLongStringCategories.
         !DO !iFactors = 1 !TO !nFactors.
            COMPUTE !CONCAT('#coeffLongString_',!iFactors,'_',!iPredictors,'_',!iCategories) = rv.normal( 0, 1 ).
         !DOEND
         string !CONCAT('#LongStringValue_',!iPredictors,'_',!iCategories) (a15).
         LOOP #j = 1 to 15.
            COMPUTE substr(!CONCAT('#LongStringValue_',!iPredictors,'_',!iCategories),#j,1) = substr('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',trunc(uniform(62))+1,1).
         END LOOP.
      !DOEND
   !DOEND
!ENDDEFINE.

DEFINE createLongStringPredictors(nFactors = !TOKENS(1) 
                                 /nLongStringPredictors = !TOKENS(1)
                                 /nLongStringCategories = !TOKENS(1) ).
   !DO !iPredictors = 1 !TO !nLongStringPredictors.
      string !CONCAT('longStringPredictor_',!iPredictors) (a15).
      !DO !iCategories = 1 !TO !nLongStringCategories.
         COMPUTE !CONCAT('#zcat_',!iCategories) = rv.normal( 0,1 ).
         !DO !iFactors = 1 !TO !nFactors.
            COMPUTE !CONCAT('#zcat_',!iCategories) = !CONCAT('#zcat_',!iCategories) 
               + !CONCAT('#coeffLongString_',!iFactors,'_',!iPredictors,'_',!iCategories) * !CONCAT('#factor_',!iFactors).
         !DOEND.
      !DOEND.
      COMPUTE #max_zcat = #zcat_1.
      COMPUTE !CONCAT('longStringPredictor_',!iPredictors) = !CONCAT('#LongStringValue_',!iPredictors,'_1').
      !DO !iCategories = 2 !TO !nLongStringCategories.
         DO IF ( !CONCAT('#zcat_',!iCategories) > #max_zcat ).
            COMPUTE #max_zcat = !CONCAT('#zcat_',!iCategories).
            COMPUTE !CONCAT('longStringPredictor_',!iPredictors) = !CONCAT('#LongStringValue_',!iPredictors,'_',!iCategories).
         END IF.
      !DOEND.
      VARIABLE LEVEL !CONCAT('longStringPredictor_',!iPredictors) (NOMINAL).
   !DOEND.
!ENDDEFINE.


DEFINE createContinuousTargetCoefficients(nFactors = !TOKENS(1) ).
   !DO !iFactors = 1 !TO !nFactors.
      COMPUTE !CONCAT('#targetCoeff_',!iFactors) = rv.normal( 0, 1 ).
   !DOEND
!ENDDEFINE.

DEFINE createContinuousTarget(nFactors = !TOKENS(1) ).
   COMPUTE continuousTarget = rv.normal(0,2).
   !DO !iFactors = 1 !TO !nFactors.
      COMPUTE continuousTarget = continuousTarget + !CONCAT('#targetCoeff_',!iFactors) * !CONCAT('#factor_',!iFactors).
   !DOEND
    COMPUTE continuousTarget = 0.01*trunc(100*continuousTarget).
!ENDDEFINE.

DEFINE createCategoricalTargetCoefficients(nFactors = !TOKENS(1) 
                                          /nTargetCategories = !TOKENS(1) ).
   !DO !iFactors = 1 !TO !nFactors.
      !DO !iCategories = 1 !TO !nTargetCategories.
         COMPUTE !CONCAT('#targetCoeff_',!iFactors,'_',!iCategories) = rv.normal( 0, 1 ).
      !DOEND.
   !DOEND.
!ENDDEFINE.

DEFINE createCategoricalTarget(nFactors = !TOKENS(1) 
                              /nTargetCategories = !TOKENS(1) ).
   !DO !iCategories = 1 !TO !nTargetCategories.
      COMPUTE !CONCAT('#zcat_',!iCategories) = rv.normal( 0,40 ).
      !DO !iFactors = 1 !TO !nFactors.
         COMPUTE !CONCAT('#zcat_',!iCategories) = !CONCAT('#zcat_',!iCategories) 
               + !CONCAT('#targetCoeff_',!iFactors,'_',!iCategories) * !CONCAT('#factor_',!iFactors).
      !DOEND.
   !DOEND.
   COMPUTE #max_zcat = #zcat_1.
   COMPUTE categoricalTarget = 1.
   !DO !iCategories = 2 !TO !nTargetCategories.
      DO IF ( !CONCAT('#zcat_',!iCategories) > #max_zcat ).
         COMPUTE #max_zcat = !CONCAT('#zcat_',!iCategories).
         COMPUTE categoricalTarget = !iCategories.
      END IF.
   !DOEND.
!ENDDEFINE.


* This is the top-level macro called by the user.  
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
DEFINE createData(nRecords = !TOKENS(1)
                 /nFactors = !TOKENS(1)
                 /nContinuousPredictors = !TOKENS(1)
                 /nCategoricalPredictors = !TOKENS(1)
                 /nPredictorCategories = !TOKENS(1)
                 /nShortStringPredictors = !TOKENS(1)
                 /nShortStringCategories = !TOKENS(1)
                 /nLongStringPredictors = !TOKENS(1)
                 /nLongStringCategories = !TOKENS(1)
                 /createSplit = !TOKENS(1)
                 /nSplits = !TOKENS(1)
                 /nTargetCategories = !TOKENS(1) ).

* This is one way to create "unique" IDs.  Add or remove sections of the ID as desired.
INPUT PROGRAM.
   string customer_id (a10).
   VARIABLE LABELS customer_id "Customer ID".
   VARIABLE ROLE /NONE customer_id.
   createFactorMeans nFactors=!nFactors.
   !IF ( !nContinuousPredictors > 0 ) !THEN.
     createContinuousPredictorCoefficients nFactors=!nFactors nContinuousPredictors=!nContinuousPredictors.
   !IFEND.
   !IF ( !nCategoricalPredictors > 0 ) !THEN.
     createCategoricalPredictorCoefficients nFactors=!nFactors nCategoricalPredictors=!nCategoricalPredictors nPredictorCategories=!nPredictorCategories.
   !IFEND.
   !IF ( !nShortStringPredictors > 0 ) !THEN.
     createShortStringPredictorCoefficients nFactors=!nFactors nShortStringPredictors=!nShortStringPredictors nShortStringCategories=!nShortStringCategories.
   !IFEND.
   !IF ( !nLongStringPredictors > 0 ) !THEN.
     createLongStringPredictorCoefficients nFactors=!nFactors nLongStringPredictors=!nLongStringPredictors nLongStringCategories=!nLongStringCategories.
   !IFEND.
   createContinuousTargetCoefficients nFactors=!nFactors .
   createCategoricalTargetCoefficients nFactors=!nFactors nTargetCategories=!nTargetCategories.
   LOOP #I = 1 TO !nRecords.
      LOOP #j = 1 to 4.
         COMPUTE substr(customer_id,#j,1) = substr('0123456789',trunc(uniform(10))+1,1).
      END LOOP.
      COMPUTE substr(customer_id,5,1) = '-'.
      LOOP #j = 6 to 10.
         COMPUTE substr(customer_id,#j,1) = substr('ABCDEFGHIJKLMNOPQRSTUVWXYZ',trunc(uniform(26))+1,1).
      END LOOP.
      END CASE.
   END LOOP.
   END FILE.
END INPUT PROGRAM.

* Underlying Factors.
createFactors nFactors=!nFactors.  

* Continuous Inputs.
!IF ( !nContinuousPredictors > 0 ) !THEN.
  createContinuousPredictors nFactors=!nFactors nContinuousPredictors=!nContinuousPredictors.
!IFEND.

* Categorical Inputs.
!IF ( !nCategoricalPredictors > 0 ) !THEN.
  createCategoricalPredictors nFactors=!nFactors nCategoricalPredictors=!nCategoricalPredictors nPredictorCategories=!nPredictorCategories.
!IFEND.
!IF ( !nShortStringPredictors > 0 ) !THEN.
  createShortStringPredictors nFactors=!nFactors nShortStringPredictors=!nShortStringPredictors nShortStringCategories=!nShortStringCategories.
!IFEND.
!IF ( !nLongStringPredictors > 0 ) !THEN.
  createLongStringPredictors nFactors=!nFactors nLongStringPredictors=!nLongStringPredictors nLongStringCategories=!nLongStringCategories.
!IFEND.

* Continuous Target.
createContinuousTarget nFactors=!nFactors.
VARIABLE ROLE /TARGET continuousTarget.

* Categorical Target.
createCategoricalTarget nFactors=!nFactors nTargetCategories=!nTargetCategories.
VARIABLE ROLE /TARGET categoricalTarget.

* Split field.
!IF ( !createSplit ) !THEN.
   NUMERIC split (F4.0).
   VARIABLE LABELS split "Split Field".
   VARIABLE ROLE /SPLIT split.
   COMPUTE split = 1 + trunc( !nSplits*rv.beta(1,1) ).
!IFEND.

!ENDDEFINE.

