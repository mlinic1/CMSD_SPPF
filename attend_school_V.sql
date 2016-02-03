--School Attendance and Chronic Absenteeism
WITH	FAY_ATT		AS
(
SELECT		FAY.STUDENT_ID
			,FAY.SCHOOL_YEAR
			,FAY.SCHOOL_CODE
			,isnull(ATT.MEMBERSHIP_DAYS, 0)			AS	MEMBERSHIP_DAYS
			,isnull(ATT.ABSENCES_UNEXCUSED, 0)		AS	ABSENCES_UNEXCUSED
			,isnull(ATT.ABSENCES_EXCUSED, 0)		AS	ABSENCES_EXCUSED
			,"CHRONIC"	=
			CASE
				WHEN (isnull(ATT.ABSENCES_UNEXCUSED, 0)+ isnull(ATT.ABSENCES_EXCUSED, 0)) / 
				ATT.MEMBERSHIP_DAYS > .1 THEN 1
				ELSE 0
			END
			,"TenDaysOrLess" =
			CASE
				WHEN(ISNULL(ATT.ABSENCES_UNEXCUSED, 0) + ISNULL(ATT.ABSENCES_EXCUSED, 0)) <=10
				THEN 1
				ELSE 0
			END
FROM	SPPF..FAY_SUBGROUPS_V		AS	FAY
LEFT JOIN SPPF..ATTENDANCE		AS	ATT
ON FAY.STUDENT_ID = ATT.STUDENT_ID AND FAY.SCHOOL_YEAR = ATT.SCHOOL_YEAR
WHERE MEMBERSHIP_DAYS>10
)

SELECT		FAY_ATT.SCHOOL_CODE
			,FAY_ATT.SCHOOL_YEAR
			,(sum(FAY_ATT.MEMBERSHIP_DAYS)-(sum(FAY_ATT.ABSENCES_UNEXCUSED)+sum(FAY_ATT.ABSENCES_EXCUSED)))
				/ sum(FAY_ATT.MEMBERSHIP_DAYS) * 100
												AS	ATTENDANCE_RATE
			,SUM(cast(FAY_ATT.chronic AS float))/COUNT(cast(FAY_ATT.STUDENT_ID as float)) * 100
												AS	CHRONIC_PERCENT
			,100-(SUM(cast(FAY_ATT.chronic AS float))/COUNT(cast(FAY_ATT.STUDENT_ID as float))) * 100
												AS	CHRONICNOT_PERCENT
			,(SUM(cast(FAY_ATT.TenDaysorLess AS float))/COUNT(cast(FAY_ATT.STUDENT_ID as float))) * 100
												AS	TenDaysorLess_PERCENT
/*
	   Name:		attend_school_V
	   Author:	Damico, Nicholas J
	   Purpose:	View the attendance rates and chronic absenteeism rates of schools across multiple years
	   Change Log:
	   Date		    Who				   What
	   *************   **********************  ****************
	   21-Dec-2015	    Damico, Nicholas J	   Initial creation
	   14-Jan-2016		Damico, Nicholas J	   QA edits
	   22-Jan-2016		Damico, Nicholas J	   Updated tables selecting FROM			
*/

FROM	FAY_ATT
GROUP BY	FAY_ATT.SCHOOL_CODE, FAY_ATT.SCHOOL_YEAR
ORDER BY	FAY_ATT.SCHOOL_CODE, FAY_ATT.SCHOOL_YEAR