#import <Foundation/Foundation.h>

#ifndef BCMIdentifiers_h
#define BCMIdentifiers_h

/* Intervention Groups */
static NSString *const _Nonnull BCMIdentifierExerciseInterventionsGroup   = @"BCMExerciseInterventions";
static NSString *const _Nonnull BCMIdentifierMedicationInterventionsGroup = @"BCMMedicationInterventions";

/* Intervention Activities */
static NSString *const _Nonnull BCMIdentifierInterventionHamstringStretch = @"BCMHamstringStretch";
static NSString *const _Nonnull BCMIdentifierInterventionBriskWalk        = @"BCMBriskWalk";
static NSString *const _Nonnull BCMIdentifierInterventionWarmCompress     = @"BMCWarmCompress";
static NSString *const _Nonnull BCMIdentifierInterventionPainKiller       = @"BCMPainKiller";

/* Assessment Groups */
static NSString *const _Nonnull BCMIdentifierSubjectiveAssessmentsGroup = @"BCMSubjectiveAssessments";
static NSString *const _Nonnull BCMIdentifierObjectiveAssessmentsGroup  = @"BCMObjectiveAssessments";

/* Assessment Activities */
static NSString *const _Nonnull BCMIdentifierAssessmentPainTrack   = @"BCMPainTrack";
static NSString *const _Nonnull BCMIdentifierAssessmentMoodTrack   = @"BCMMoodTrack";
static NSString *const _Nonnull BCMIdentifierAssessmentWeightTrack = @"BMCWeightTrack";

#endif
