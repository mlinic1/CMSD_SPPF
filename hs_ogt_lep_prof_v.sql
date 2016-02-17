WITH STU_TEST AS
(
SELECT	FAY.student_id
		,FAY.SCHOOL_CODE				AS		school_code
		,FAY.SCHOOL_YEAR				AS		school_year
		,isnull(reading.read_prof, 0)	AS		prof_read
		,isnull(math.math_prof, 0)		AS		prof_math
		,isnull(sci.sci_prof, 0)		AS		prof_sci
		,isnull(soc.soc_prof, 0)		AS		prof_soc
		,isnull(wri.wri_prof, 0)		AS		prof_wri
FROM	SPPF..FAY_SUBGROUPS_V			AS	FAY	 
LEFT JOIN 
	(
	SELECT	DISTINCT
			reading.STUDENT_ID
			,1						AS	'read_prof'
	FROM SPPF..OAA_OGT_TESTS		AS	READING
	LEFT JOIN SPPF..FAY_SUBGROUPS_V	AS	SUB
	ON SUB.STUDENT_ID = READING.STUDENT_ID AND SUB.SCHOOL_YEAR=datepart(YEAR, READING.TEST_DATE)
	WHERE TEST_TYPE = 'OGT' AND TEST_SUBJECT = 'READING' 
	AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
	AND PERFORMANCE_LEVEL IN (11, 12, 13)
	AND	SUB.GRADE IN ('09', '10')
	) reading
ON	FAY.STUDENT_ID = reading.student_id
LEFT JOIN 
	(
	SELECT	math.STUDENT_ID
			,1						AS	'math_prof'
	FROM SPPF..OAA_OGT_TESTS		AS	MATH
	LEFT JOIN SPPF..FAY_SUBGROUPS_V	AS	SUB
	ON SUB.STUDENT_ID = math.STUDENT_ID AND SUB.SCHOOL_YEAR=datepart(YEAR, math.TEST_DATE)
	WHERE TEST_TYPE = 'OGT' AND TEST_SUBJECT = 'MATH' 
	AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
	AND PERFORMANCE_LEVEL IN (11, 12, 13)
	AND	SUB.GRADE IN ('09', '10')
	) math
ON	FAY.STUDENT_ID = math.student_id
LEFT JOIN 
	(
	SELECT	science.STUDENT_ID
			,1						AS	'sci_prof'
	FROM SPPF..OAA_OGT_TESTS		AS	science
	LEFT JOIN SPPF..FAY_SUBGROUPS_V	AS	SUB
	ON SUB.STUDENT_ID = science.STUDENT_ID AND SUB.SCHOOL_YEAR=datepart(YEAR, science.TEST_DATE)	
	WHERE TEST_TYPE = 'OGT' AND TEST_SUBJECT = 'SCIENCE' 
	AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
	AND PERFORMANCE_LEVEL IN (11, 12, 13)
	AND	SUB.GRADE IN ('09', '10')
	) sci
ON	FAY.STUDENT_ID = sci.student_id
LEFT JOIN 
	(
	SELECT	social.STUDENT_ID
			,1						AS	'soc_prof'
	FROM SPPF..OAA_OGT_TESTS		AS	social
	LEFT JOIN SPPF..FAY_SUBGROUPS_V	AS	SUB
	ON SUB.STUDENT_ID = social.STUDENT_ID AND SUB.SCHOOL_YEAR=datepart(YEAR, social.TEST_DATE)	
	WHERE TEST_TYPE = 'OGT' AND TEST_SUBJECT = 'SOCIAL' 
	AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
	AND PERFORMANCE_LEVEL IN (11, 12, 13)
	AND	SUB.GRADE IN ('09', '10')
	) soc
ON	FAY.STUDENT_ID = soc.student_id
LEFT JOIN 
	(
	SELECT	writing.STUDENT_ID
			,1						AS	'wri_prof'
	FROM SPPF..OAA_OGT_TESTS		AS	writing
	LEFT JOIN SPPF..FAY_SUBGROUPS_V	AS	SUB
	ON SUB.STUDENT_ID = writing.STUDENT_ID AND SUB.SCHOOL_YEAR=datepart(YEAR, writing.TEST_DATE)	
	WHERE TEST_TYPE = 'OGT' AND TEST_SUBJECT = 'WRITING' 
	AND (DATEPART(MONTH, test_date)>=3 and DATEPART(month,test_date)<8)
	AND PERFORMANCE_LEVEL IN (11, 12, 13)
	AND	SUB.GRADE IN ('09', '10')
	) wri
ON	FAY.STUDENT_ID = wri.student_id
WHERE FAY.GRADE = '10'
AND FAY.SCHOOL_YEAR<2015
AND lep = 1
)

SELECT	school_code
		,school_year
		,COUNT(student_id)			AS	student_lep_n
		,SUM(prof_read)				AS	prof_read_lep_n
		,SUM(prof_math)				AS	prof_math_lep_n
		,SUM(prof_sci)				AS	prof_sci_lep_n
		,SUM(prof_soc)				AS	prof_soc_lep_n
		,SUM(prof_wri)				AS	prof_wri_lep_n
		,CAST(sum(prof_read) as float) / CAST(count(student_id) as float) *100
									AS	prof_read_lep_perc
		,CAST(sum(prof_math) as float) / CAST(count(student_id) as float) *100
									AS	prof_math_lep_perc
		,CAST(sum(prof_sci) as float) / CAST(count(student_id) as float) *100
									AS	prof_sci_lep_perc
		,CAST(sum(prof_soc) as float) / CAST(count(student_id) as float) *100
									AS	prof_soc_lep_perc
		,CAST(sum(prof_wri) as float) / CAST(count(student_id) as float) *100
									AS	prof_wri_lep_perc
/*
	   Name:		hs_ogt_lep_prof_v
	   Author:	Damico, Nicholas J
	   Purpose:	Query used to identify the percentage of 10th grade LEP students proficient in different subjects 
	   according to the OGT.
	   Change Log:
	   Date		    Who				   What
	   *************   **********************  ****************
	   16-Feb-2016	    Damico, Nicholas J	   Initial creation
	   		
*/
FROM STU_TEST
GROUP BY school_code, school_year
ORDER BY school_code, school_year