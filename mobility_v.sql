--IDENTIFYING MOBILITY RATES FOR SCHOOLS
WITH STUFAY AS (
		SELECT	 count(GR.STUDENT_ID)	as	stufay_n
				,GR.SCHOOL_YEAR
				,GR.BUILDING_ID
				,GR.SCHOOL_CODE
				,BLD.BUILDING_TYPE
		FROM	SPPF..GRADE			AS	GR
		JOIN	SPPF..BUILDING		AS	BLD
		ON		GR.BUILDING_ID	=	BLD.BUILDING_ID

		WHERE	BLD.BUILDING_TYPE IN ('E', 'EH', 'H', 'IN')
AND		(
		(GR.GRADE IN ('KG', '01', '02', '03', '04', '05', '06', '07', '08') AND
		(GR.SCHOOL_YEAR = 2010 AND entry_date<='10.1.2009' AND withdrawal_date>='5.10.2010') OR
		(GR.SCHOOL_YEAR = 2011 AND entry_date<='10.1.2010' AND withdrawal_date>='5.10.2011') OR
		(GR.SCHOOL_YEAR = 2012 AND entry_date<='10.1.2011' AND withdrawal_date>='5.10.2012') OR
		(GR.SCHOOL_YEAR = 2013 AND entry_date<='10.1.2012' AND withdrawal_date>='5.10.2013') OR
		(GR.SCHOOL_YEAR = 2014 AND entry_date<='10.1.2013' AND withdrawal_date>='5.10.2014') OR
		(GR.SCHOOL_YEAR = 2015 AND entry_date<='10.1.2014' AND withdrawal_date>='5.10.2015') OR
		(GR.SCHOOL_YEAR = 2016 AND entry_date<='10.1.2015' AND withdrawal_date IS NULL)
		) OR
		(GR.GRADE IN ('09', '10', '11', '12') AND
		(GR.SCHOOL_YEAR = 2010 AND entry_date<='10.1.2009' AND withdrawal_date>='3.31.2010') OR
		(GR.SCHOOL_YEAR = 2011 AND entry_date<='10.1.2010' AND withdrawal_date>='3.31.2011') OR
		(GR.SCHOOL_YEAR = 2012 AND entry_date<='10.1.2011' AND withdrawal_date>='3.31.2012') OR
		(GR.SCHOOL_YEAR = 2013 AND entry_date<='10.1.2012' AND withdrawal_date>='3.31.2013') OR
		(GR.SCHOOL_YEAR = 2014 AND entry_date<='10.1.2013' AND withdrawal_date>='3.31.2014') OR
		(GR.SCHOOL_YEAR = 2015 AND entry_date<='10.1.2014' AND withdrawal_date>='3.31.2015') OR
		(GR.SCHOOL_YEAR = 2016 AND entry_date<='10.1.2015' AND withdrawal_date IS NULL)
		)
		)
		GROUP BY	GR.BUILDING_ID, GR.SCHOOL_CODE, GR.SCHOOL_YEAR, BLD.BUILDING_TYPE 
		),

	STUTOT AS (

		SELECT	 count(GR.STUDENT_ID)	AS		stutot_n
				,GR.SCHOOL_YEAR
				,GR.BUILDING_ID
				,GR.SCHOOL_CODE
				,BLD.BUILDING_TYPE
		FROM	SPPF..GRADE			AS	GR
		JOIN	SPPF..BUILDING		AS	BLD
		ON		GR.BUILDING_ID	=	BLD.BUILDING_ID

		WHERE	BLD.BUILDING_TYPE IN ('E', 'EH', 'H', 'IN')
		AND	(
			(GR.SCHOOL_YEAR = 2010 AND WITHDRAWAL_DATE>='10.1.2009') OR
			(GR.SCHOOL_YEAR = 2011 AND WITHDRAWAL_DATE>='10.1.2010') OR
			(GR.SCHOOL_YEAR = 2012 AND WITHDRAWAL_DATE>='10.1.2011') OR
			(GR.SCHOOL_YEAR = 2013 AND WITHDRAWAL_DATE>='10.1.2012') OR
			(GR.SCHOOL_YEAR = 2014 AND WITHDRAWAL_DATE>='10.1.2013') OR
			(GR.SCHOOL_YEAR = 2015 AND WITHDRAWAL_DATE>='10.1.2014') OR
			(GR.SCHOOL_YEAR = 2016 AND (WITHDRAWAL_DATE>='10.1.2015' OR WITHDRAWAL_DATE IS NULL))
			)
		GROUP BY	GR.BUILDING_ID, GR.SCHOOL_CODE, GR.SCHOOL_YEAR, BLD.BUILDING_TYPE 
			)

SELECT	stufay.school_code
		,stufay.building_id
		,stufay.school_year
		,(cast(stutot.stutot_n AS float)-cast(stufay.stufay_n AS float))/cast(stutot.stutot_n AS float) * 100	AS	"mobility"
		,stufay.stufay_n	AS		FAY_student_n
		,stutot.stutot_n	AS		TOTAL_student_n

		/*
	   Name:		Mobility_V
	   Author:	Damico, Nicholas J
	   Purpose:	View to identify the mobility rates of students at district schools for multiple school years
	   Change Log:
	   Date		    Who				   What
	   *************   **********************  ****************
	   17-Dec-2015	    Damico, Nicholas J	   Initial creation
	   18-Dec-2015		Damico, Nicholas J	   QA changes to WHERE statements
*/

FROM STUFAY
LEFT JOIN STUTOT	ON STUFAY.SCHOOL_YEAR = STUTOT.SCHOOL_YEAR 
					AND STUFAY.BUILDING_ID = STUTOT.BUILDING_ID
ORDER BY	STUFAY.building_id, STUFAY.SCHOOL_CODE, STUFAY.SCHOOL_YEAR