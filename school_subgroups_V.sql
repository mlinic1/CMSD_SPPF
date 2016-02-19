with ENROLL_OCT as
		(
		SELECT		gr.student_id
					,gr.school_year
					,bld.school_code
					,GR.grade
					,BLD.BUILDING_TYPE
		FROM SPPF..GRADE			AS	GR
		JOIN	SPPF..BUILDING			AS	BLD
		ON		GR.BUILDING_ID	=	BLD.BUILDING_ID

		WHERE	BLD.BUILDING_TYPE IN ('E', 'EH', 'H', 'IN')
AND		(
		(GR.SCHOOL_YEAR = 2010 AND entry_date<='10.1.2009' AND withdrawal_date>'10.1.2009') OR
		(GR.SCHOOL_YEAR = 2011 AND entry_date<='10.1.2010' AND withdrawal_date>'10.1.2010') OR
		(GR.SCHOOL_YEAR = 2012 AND entry_date<='10.1.2011' AND withdrawal_date>'10.1.2011') OR
		(GR.SCHOOL_YEAR = 2013 AND entry_date<='10.1.2012' AND withdrawal_date>'10.1.2012') OR
		(GR.SCHOOL_YEAR = 2014 AND entry_date<='10.1.2013' AND withdrawal_date>'10.1.2013') OR
		(GR.SCHOOL_YEAR = 2015 AND entry_date<='10.1.2014' AND withdrawal_date>'10.1.2014') OR
		(GR.SCHOOL_YEAR = 2016 AND entry_date<='10.1.2015' AND (withdrawal_date>'10.1.2015' OR WITHDRAWAL_DATE IS NULL))
		)
		) ,
--IDENTIFYING SPED STATUS 		

		SPED	AS 
		(
		SELECT	STUDENT_ID,
		"school_year" = 
		CASE
			WHEN year = 'sped2008' THEN	'2008'
			WHEN year = 'sped2009' THEN	'2009'
			WHEN year = 'sped2010' THEN	'2010'
			WHEN year = 'sped2011' THEN	'2011'
			WHEN year = 'sped2012' THEN	'2012'
			WHEN year = 'sped2013' THEN	'2013'
			WHEN year = 'sped2014' THEN	'2014'
			WHEN year = 'sped2015' THEN	'2015'
			WHEN year = 'sped2016' THEN	'2016'
		END
						AS SCHOOL_YEAR,
		SPED
		FROM (
		SELECT	STUDENT_ID,
				"SPED2008" = 
					CASE
					WHEN (	disability_start_date<='10.15.2007' AND 
					(disability_end_date>'10.15.2007' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2009" = 
					CASE
					WHEN (	disability_start_date<='10.15.2008' AND 
					(disability_end_date>'10.15.2008' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2010" = 
					CASE
					WHEN (	disability_start_date<='10.15.2009' AND 
					(disability_end_date>'10.15.2009' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2011" = 
					CASE
					WHEN (	disability_start_date<='10.15.2010' AND 
					(disability_end_date>'10.15.2010' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2012" = 
					CASE
					WHEN (	disability_start_date<='10.15.2011' AND 
					(disability_end_date>'10.15.2011' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2013" = 
					CASE
					WHEN (	disability_start_date<='10.15.2012' AND 
					(disability_end_date>'10.15.2012' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2014" = 
					CASE
					WHEN (	disability_start_date<='10.15.2013' AND 
					(disability_end_date>'10.15.2013' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2015" = 
					CASE
					WHEN (	disability_start_date<='10.15.2014' AND 
					(disability_end_date>'10.15.2014' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END,
				"SPED2016" = 
					CASE
					WHEN (	disability_start_date<='10.15.2015' AND 
					(disability_end_date>'10.15.2015' OR DISABILITY_END_DATE IS NULL)) THEN 1
					ELSE NULL
					END
		FROM SPPF..SPECIAL_EDUCATION ) p 

		UNPIVOT

		(SPED FOR year IN ([sped2008], [sped2009], [sped2010], [sped2011], [sped2012], 
					[sped2013], [sped2014], [sped2015], [sped2016])
		)	AS unpvt 
		),

--IDENTIFYING LEP STATUS FOR STUDENTS
LEP		AS	
		(
		SELECT	STUDENT_ID,
				school_year,
				"lep" =
					CASE	
					WHEN LAUCODE='A'	THEN	1
					WHEN LAUCODE='B'	THEN	1
					WHEN LAUCODE='C'	THEN	1
					ELSE	NULL
					END
		FROM SPPF..LEP_V
		),

--IDENTIFYING GIFTED STATUS FOR STUDENTS
GIFTED	AS	
		(
		SELECT	STUDENT_ID,
				"school_year" = 
					CASE
					WHEN year = 'gifted2008' THEN	'2008'
					WHEN year = 'gifted2009' THEN	'2009'
					WHEN year = 'gifted2010' THEN	'2010'
					WHEN year = 'gifted2011' THEN	'2011'
					WHEN year = 'gifted2012' THEN	'2012'
					WHEN year = 'gifted2013' THEN	'2013'
					WHEN year = 'gifted2014' THEN	'2014'
					WHEN year = 'gifted2015' THEN	'2015'
					WHEN year = 'gifted2016' THEN	'2016'
					END,
				GIFTED
		FROM 
		(
			SELECT	GIFT.STUDENT_ID,
					"gifted2008" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2007'			OR
								math_idate<='10.15.2007'		OR
								science_idate<='10.15.2007'		OR
								readwrite_idate<='10.15.2007'		OR
								soc_idate<='10.15.2007'			OR
								create_idate<='10.15.2007'		OR
								visual_idate>'10.15.2007') THEN 1
						ELSE NULL
						END,
					"gifted2009" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2008'			OR
								math_idate<='10.15.2008'		OR
								science_idate<='10.15.2008'		OR
								readwrite_idate<='10.15.2008'		OR
								soc_idate<='10.15.2008'			OR
								create_idate<='10.15.2008'		OR
								visual_idate>'10.15.2008') THEN 1
						ELSE NULL
						END,
					"gifted2010" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2009'			OR
								math_idate<='10.15.2009'		OR
								science_idate<='10.15.2009'		OR
								readwrite_idate<='10.15.2009'		OR
								soc_idate<='10.15.2009'			OR
								create_idate<='10.15.2009'		OR
								visual_idate>'10.15.2009') THEN 1
						ELSE NULL
						END,
					"gifted2011" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2010'			OR
								math_idate<='10.15.2010'		OR
								science_idate<='10.15.2010'		OR
								readwrite_idate<='10.15.2010'		OR
								soc_idate<='10.15.2010'			OR
								create_idate<='10.15.2010'		OR
								visual_idate>'10.15.2010') THEN 1
						ELSE NULL
						END,
					"gifted2012" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2011'			OR
								math_idate<='10.15.2011'		OR
								science_idate<='10.15.2011'		OR
								readwrite_idate<='10.15.2011'		OR
								soc_idate<='10.15.2011'			OR
								create_idate<='10.15.2011'		OR
								visual_idate>'10.15.2011') THEN 1
						ELSE NULL
						END,
					"gifted2013" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2012'			OR
								math_idate<='10.15.2012'		OR
								science_idate<='10.15.2012'		OR
								readwrite_idate<='10.15.2012'		OR
								soc_idate<='10.15.2012'			OR
								create_idate<='10.15.2012'		OR
								visual_idate>'10.15.2012') THEN 1
						ELSE NULL
						END,
					"gifted2014" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2013'			OR
							math_idate<='10.15.2013'			OR
							science_idate<='10.15.2013'			OR
							readwrite_idate<='10.15.2013'			OR
							soc_idate<='10.15.2013'				OR
							create_idate<='10.15.2013'			OR
							visual_idate>'10.15.2013') THEN 1
						ELSE NULL
						END,
					"gifted2015" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2014'		OR
							math_idate<='10.15.2014'		OR
							science_idate<='10.15.2014'		OR
							readwrite_idate<='10.15.2014'		OR
							soc_idate<='10.15.2014'			OR
							create_idate<='10.15.2014'		OR
							visual_idate>'10.15.2014') THEN 1
						ELSE NULL
						END,
					"gifted2016" = 
						CASE
						WHEN (	cognitive_idate<='10.15.2015'			OR
								math_idate<='10.15.2015'		OR
								science_idate<='10.15.2015'		OR
								readwrite_idate<='10.15.2015'		OR
								soc_idate<='10.15.2015'			OR
								create_idate<='10.15.2015'		OR
								visual_idate>'10.15.2015') THEN 1
						ELSE NULL
						END
				FROM SPPF..STUDENT_GIFTED	AS GIFT	) p

		UNPIVOT

				(gifted FOR year IN ([gifted2008], [gifted2009], [gifted2010], [gifted2011], [gifted2012], 
				[gifted2013], [gifted2014], [gifted2015], [gifted2016])
		)	AS unpvt
		)
		 
SELECT	ENROLL_OCT.SCHOOL_CODE
		,ENROLL_OCT.SCHOOL_YEAR
		,count(ENROLL_OCT.student_id)						AS student_n	
		,isnull(sum(SPED.SPED), 0)						AS sped_n
		,isnull(sum(LEP.LEP), 0)						AS lep_n
		,isnull(sum(gifted.gifted), 0)						AS gifted_n
		,isnull(SUM(cast(SPED.SPED as float)) /
		count(cast(enroll_oct.student_id AS FLOAT))*100, 0)			AS sped_percent
		,isnull(SUM(cast(LEP.LEP as float)) /
		count(cast(enroll_oct.student_id as float))*100, 0)			AS lep_percent
		,isnull(SUM(cast(gifted.gifted as float)) /
		count(cast(enroll_oct.student_id as float))*100, 0)			AS gifted_percent
/*
	   Name:		school_subgroups_V
	   Author:	Damico, Nicholas J
	   Purpose:	View to identify a set of subgroup populations for schools. Subgroup populations are determined by 
	   percentages of students in each subgroup during an October snapshot. Subgroup populations will be displayed as 
	   part of school demographic information and used in creating school peer groups.
	   Change Log:
	   Date		        Who				        What
	   *************   **********************  ****************
	   14-Jan-2016	    Damico, Nicholas J	   Initial creation
	   03-Feb-2016		Damico, Nicholas J	   Aligned all Dates		
*/

FROM ENROLL_OCT
LEFT JOIN SPED ON ENROLL_OCT.STUDENT_ID = SPED.STUDENT_ID AND ENROLL_OCT.SCHOOL_YEAR = SPED.SCHOOL_YEAR
LEFT JOIN LEP ON ENROLL_OCT.STUDENT_ID = LEP.student_id AND ENROLL_OCT.SCHOOL_YEAR = LEP.SCHOOL_YEAR
LEFT JOIN gifted ON ENROLL_OCT.STUDENT_ID = gifted.student_id AND ENROLL_OCT.SCHOOL_YEAR = gifted.SCHOOL_YEAR 
WHERE SCHOOL_CODE IS NOT NULL
GROUP BY enroll_oct.school_code, enroll_oct.school_year
ORDER BY enroll_oct.SCHOOL_CODE, enroll_oct.SCHOOL_YEAR
