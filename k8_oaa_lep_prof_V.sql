WITH	STU_N	AS
		(SELECT	COUNT(student_id)			as student_lep_n
				,SCHOOL_CODE
				,SCHOOL_YEAR
		FROM SPPF..FAY_SUBGROUPS_V
		WHERE GRADE IN ('03', '04', '05', '06', '07', '08')
		AND SCHOOL_YEAR<2015
		AND lep=1
		GROUP BY SCHOOL_CODE, SCHOOL_YEAR
		)
		,

		READING AS
		(
		SELECT	count(FAY.student_id)		AS		prof_read_lep_n
				,FAY.SCHOOL_CODE			AS		school_code
				,FAY.SCHOOL_YEAR			AS		school_year
		FROM SPPF..FAY_SUBGROUPS_V		AS	FAY
		LEFT JOIN SPPF..OAA_OGT_TESTS	AS	OAA
		ON FAY.STUDENT_ID = OAA.STUDENT_ID AND FAY.SCHOOL_YEAR=datepart(YEAR, OAA.TEST_DATE)
		WHERE TEST_TYPE = 'OAA' AND TEST_SUBJECT = 'READING' 
		AND	GRADE IN ('03', '04', '05', '06', '07', '08')
		AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
		AND PERFORMANCE_LEVEL IN (11, 12, 13)
		AND SCHOOL_YEAR<2015
		AND lep=1
		GROUP BY FAY.SCHOOL_CODE, FAY.SCHOOL_YEAR
		)
		,

		MATH AS
		(
		SELECT	count(FAY.student_id)		AS		prof_math_lep_n
				,FAY.SCHOOL_CODE			AS		school_code
				,FAY.SCHOOL_YEAR			AS		school_year
		FROM SPPF..FAY_SUBGROUPS_V		AS	FAY
		LEFT JOIN SPPF..OAA_OGT_TESTS	AS	OAA
		ON FAY.STUDENT_ID = OAA.STUDENT_ID AND FAY.SCHOOL_YEAR=datepart(YEAR, OAA.TEST_DATE)
		WHERE TEST_TYPE = 'OAA' AND TEST_SUBJECT = 'MATH' 
		AND	GRADE IN ('03', '04', '05', '06', '07', '08')
		AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
		AND PERFORMANCE_LEVEL IN (11, 12, 13)
		AND SCHOOL_YEAR<2015
		AND lep=1
		GROUP BY FAY.SCHOOL_CODE, FAY.SCHOOL_YEAR
		)
		,

		SCI AS
		(
		SELECT	count(FAY.student_id)		AS		prof_sci_lep_n
				,FAY.SCHOOL_CODE			AS		school_code
				,FAY.SCHOOL_YEAR			AS		school_year
		FROM SPPF..FAY_SUBGROUPS_V		AS	FAY
		LEFT JOIN SPPF..OAA_OGT_TESTS	AS	OAA
		ON FAY.STUDENT_ID = OAA.STUDENT_ID AND FAY.SCHOOL_YEAR=datepart(YEAR, OAA.TEST_DATE)
		WHERE TEST_TYPE = 'OAA' AND TEST_SUBJECT = 'SCIENCE' 
		AND	GRADE IN ('03', '04', '05', '06', '07', '08')
		AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
		AND PERFORMANCE_LEVEL IN (11, 12, 13)
		AND SCHOOL_YEAR<2015
		AND lep=1
		GROUP BY FAY.SCHOOL_CODE, FAY.SCHOOL_YEAR
		)

SELECT	stu_n.school_code
		,stu_n.school_year
		,isnull(stu_n.student_lep_n, 0)	AS	student_lep_n
		,isnull(prof_read_lep_n, 0)		AS	prof_read_lep_n
		,isnull(prof_math_lep_n, 0)		AS	prof_math_lep_n
		,isnull(prof_sci_lep_n, 0)			AS	prof_sci_lep_n
		,cast(isnull(prof_read_lep_n, 0) as float) / cast(isnull(student_lep_n, 0) as float)*100		
											AS	prof_read_lep_perc
		,cast(isnull(prof_math_lep_n, 0) as float) / cast(isnull(student_lep_n, 0) as float)*100		
											AS	prof_math_lep_perc
		,cast(isnull(prof_sci_lep_n, 0) as float) / cast(isnull(student_lep_n, 0) as float)*100			
											AS	prof_sci_lep_perc

/*
	   Name:		k8_oaa_lep_prof_v
	   Author:	Damico, Nicholas J
	   Purpose:	Query used to identify the percentage of K8 LEP students proficient in different subjects according 
	   to the OAA
	   Change Log:
	   Date		    Who				   What
	   *************   **********************  ****************
	   16-Feb-2016	    Damico, Nicholas J	   Initial creation
	   		
*/
FROM STU_N
LEFT JOIN READING
ON STU_N.SCHOOL_CODE = READING.school_code AND STU_N.SCHOOL_YEAR=READING.school_year
LEFT JOIN MATH
ON STU_N.SCHOOL_CODE = MATH.school_code AND STU_N.SCHOOL_YEAR=MATH.school_year
LEFT JOIN SCI
ON STU_N.SCHOOL_CODE = SCI.school_code AND STU_N.SCHOOL_YEAR=SCI.school_year
ORDER BY SCHOOL_CODE, SCHOOL_YEAR
