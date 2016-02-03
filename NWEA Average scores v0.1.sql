,

NWEA_K8 AS
		(
		SELECT	NWEA_SCORE.STUDENT_ID
				,NWEA_SCORE.SCHOOL_YEAR
				,NWEA_SCORE.SUBJECT_AREA
				,NWEA_SCORE.RIT_SCORE
		FROM SPPF..NWEA_SCORE
		RIGHT JOIN ENROLL_OCT ON ENROLL_OCT.STUDENT_ID = NWEA_SCORE.student_id 
		AND ENROLL_OCT.school_year = NWEA_SCORE.school_year
		WHERE enroll_oct.GRADE IN (1, 2) 
		AND TERM = 'Fall'
		AND ENROLL_OCT.BUILDING_TYPE IN ('E', 'EH')
		),

NWEA_HS AS
		(
		SELECT	NWEA_SCORE.STUDENT_ID
				,NWEA_SCORE.SCHOOL_YEAR
				,NWEA_SCORE.SUBJECT_AREA
				,NWEA_SCORE.RIT_SCORE
		FROM SPPF..NWEA_SCORE
		RIGHT JOIN ENROLL_OCT ON ENROLL_OCT.STUDENT_ID = NWEA_SCORE.student_id 
		AND ENROLL_OCT.school_year = NWEA_SCORE.school_year
		WHERE enroll_oct.GRADE IN (8) 
		AND TERM = 'Fall'
		AND ENROLL_OCT.BUILDING_TYPE IN ('H', 'EH')
		)