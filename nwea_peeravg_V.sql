WITH	ENROLL_OCT AS
		(SELECT	GR.STUDENT_ID
				,GR.SCHOOL_YEAR
				,GR.GRADE
				,GR.BUILDING_ID
				,GR.SCHOOL_CODE
				,BLD.BUILDING_TYPE
		FROM	SPPF..GRADE			AS	GR
		JOIN	SPPF..BUILDING		AS	BLD
		ON		GR.BUILDING_ID	=	BLD.BUILDING_ID

		WHERE	BLD.BUILDING_TYPE IN ('E', 'EH', 'H')
		AND		
		(
		(GR.GRADE IN ('KG', '01', '02', '09') 
		AND
		(GR.SCHOOL_YEAR = 2010 AND entry_date<='10.1.2009' AND withdrawal_date>='10.1.2009') OR
		(GR.SCHOOL_YEAR = 2011 AND entry_date<='10.1.2010' AND withdrawal_date>='10.1.2010') OR
		(GR.SCHOOL_YEAR = 2012 AND entry_date<='10.1.2011' AND withdrawal_date>='10.1.2011') OR
		(GR.SCHOOL_YEAR = 2013 AND entry_date<='10.1.2012' AND withdrawal_date>='10.1.2012') OR
		(GR.SCHOOL_YEAR = 2014 AND entry_date<='10.1.2013' AND withdrawal_date>='10.1.2013') OR
		(GR.SCHOOL_YEAR = 2015 AND entry_date<='10.1.2014' AND withdrawal_date>='10.1.2014') OR
		(GR.SCHOOL_YEAR = 2016 AND entry_date<='10.1.2015' AND withdrawal_date>='10.1.2015')
		)
		)
		)
		,

		NWEA_K8 AS
		(
		SELECT	ENROLL_OCT.SCHOOL_CODE			AS	SCHOOL_CODE
				,NWEA_SCORE.SCHOOL_YEAR			AS	SCHOOL_YEAR
				,NWEA_SCORE.SUBJECT_AREA		AS	SUBJECT_AREA
				,AVG(NWEA_SCORE.RIT_SCORE)		AS	RIT_SCORE_AVG
				,'K8'							AS	'PEER_TYPE'
		FROM SPPF..NWEA_SCORE
		INNER JOIN ENROLL_OCT ON ENROLL_OCT.STUDENT_ID = NWEA_SCORE.student_id 
		AND ENROLL_OCT.school_year = NWEA_SCORE.school_year
		WHERE ENROLL_OCT.GRADE IN ('KG', '01', '02') 
		AND TERM = 'Fall'
		AND ENROLL_OCT.BUILDING_TYPE IN ('E', 'EH')
		GROUP BY NWEA_SCORE.SCHOOL_YEAR, NWEA_SCORE.SUBJECT_AREA, ENROLL_OCT.SCHOOL_CODE
		)
		,

		NWEA_HS AS
		(
		SELECT	ENROLL_OCT.SCHOOL_CODE			AS	SCHOOL_CODE
				,NWEA_SCORE.SCHOOL_YEAR			AS	SCHOOL_YEAR
				,NWEA_SCORE.SUBJECT_AREA		AS	SUBJECT_AREA
				,AVG(NWEA_SCORE.RIT_SCORE)		AS	RIT_SCORE_AVG
				,'HS'							AS	'PEER_TYPE'
		FROM SPPF..NWEA_SCORE
		INNER JOIN ENROLL_OCT ON ENROLL_OCT.STUDENT_ID = NWEA_SCORE.student_id 
		AND ENROLL_OCT.school_year = (NWEA_SCORE.school_year-1)
		WHERE enroll_oct.GRADE IN ('09') 
		AND TERM = 'Fall'
		AND ENROLL_OCT.BUILDING_TYPE IN ('H', 'EH')
		GROUP BY NWEA_SCORE.SCHOOL_YEAR, NWEA_SCORE.SUBJECT_AREA, ENROLL_OCT.SCHOOL_CODE
		)

SELECT	NWEA_K8.SCHOOL_CODE
		,NWEA_K8.SCHOOL_YEAR
		,NWEA_K8.SUBJECT_AREA
		,NWEA_K8.RIT_SCORE_AVG
		,NWEA_K8.PEER_TYPE
FROM NWEA_K8
UNION
SELECT	NWEA_HS.SCHOOL_CODE
		,NWEA_HS.SCHOOL_YEAR
		,NWEA_HS.SUBJECT_AREA
		,NWEA_HS.RIT_SCORE_AVG
		,NWEA_HS.PEER_TYPE

/*
	   Name:		nwea_peeravg_V
	   Author:	Damico, Nicholas J
	   Purpose:	View to identify the average NWEA MAP baseline test scores for schools. This data is used in peer group calculations. 
	   These are the test scores of KG, 1, and 2nd graders for K8 buildings. 
	   They are the 8th grade test scores of 9th graders for the HS buildings. 
	   Change Log:
	   Date		    Who				   What
	   *************   **********************  ****************
	   03-Feb-2016	    Damico, Nicholas J	   Initial creation		
*/
FROM NWEA_HS
ORDER BY SCHOOL_CODE
