

-------Essentials of Pediatric Acute Care Orientation (EPACO)-------

Drop table if exists #t1
Drop table if exists #t2


--------------------------------------------------------------------------------------------------------
set @PriorPurchases = 1 
Begin

set @PriorYearStart = dateadd(year, -1, @Query_Start_Date)
set @PriorYearEnd = dateadd(day, -1, @Query_Start_Date)



select distinct
ci.enrollment_datetime,
u.username

into #t1

from
dbo.org o with (nolock)

inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0
inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id 
inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id
inner join dbo.course_category_course_mapping cccm with (nolock)
on ci.course_id = cccm.course_id
inner join dbo.course_category cc with (nolock)
on cccm.course_category_id = cc.course_category_id
inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id
inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0

where o.is_deleted = 0
and ci.enrollment_datetime >= @PriorYearStart
and ci.enrollment_datetime <= @PriorYearEnd
and ((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))
and o.external_org_id = @ao_key
and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted


and ci.course_instance_interaction_mode_id not in ('1','6','7') 
and u.username not like '%test%'
and u.last_name not like '%test%'
and cccm.course_category_id in (

'15042364-D61C-E811-8806-005056B10652',
'DB13DF00-D91C-E811-8740-005056B12710')

and ci.course_id not in (

'2381A770-8569-DF11-9D81-001517135351', 
'FE3E4FB8-E65B-E311-9299-001517135400', 
'B2351D74-EF5B-E311-9299-001517135400', 
'38BB7A9B-13AA-DF11-8A59-001517135511', 
'B22A5288-7969-DF11-91E1-001517135511', 
'B911FA19-746C-DF11-91E1-001517135511', 
'D54A0C4C-766C-DF11-91E1-001517135511', 
'989CEE3B-7D6C-DF11-91E1-001517135511', 
'B6523F50-806C-DF11-91E1-001517135511', 
'4F2C51E4-846C-DF11-91E1-001517135511', 
'27E60A2F-946C-DF11-91E1-001517135511', 
'E4871402-E45B-E311-80E3-0015171C1A75', 
'4638C60E-E45B-E311-80E3-0015171C1A75', 
'BCEF821C-E45B-E311-80E3-0015171C1A75', 
'471DBAB7-EB5B-E311-80E3-0015171C1A75', 
'3ED2A771-5F69-DF11-A530-0015171C1A75', 
'C577E26B-3E6A-DF11-A530-0015171C1A75', 
'123FA2FE-A799-DF11-B74C-0015171C5BB1', 
'1FE4666D-326A-DF11-B520-0015171C5BB3', 
'57C46FAA-466A-DF11-B520-0015171C5BB3', 
'CFCC5D8D-8C6C-DF11-B520-0015171C5BB3', 
'98A7B54C-8F6C-DF11-B520-0015171C5BB3', 
'F84151B6-976C-DF11-B520-0015171C5BB3', 
'E702D6F2-2AA6-DF11-B882-0015171C5BB3', 
'D47B736A-6D69-DF11-98C2-00151729CB2F', 
'E6705D78-7869-DF11-93F1-00188B39EB5C', 
'44CBDCC9-7D69-DF11-93F1-00188B39EB5C', 
'835A4815-1A6A-DF11-93F1-00188B39EB5C', 
'CAC3A877-D7E9-E911-90B9-005056B10F02', 
'94544E52-F1E9-E911-90B9-005056B10F02', 
'03693AF5-F2E9-E911-90B9-005056B10F02', 
'97D7D313-D798-ED11-80FB-005056B14E20', 
'F048E3C0-DA98-ED11-80FB-005056B14E20', 
'61A42DF7-DF98-ED11-80FB-005056B14E20', 
'528ED2DA-8969-DF11-9D81-001517135351', 
'1F806226-8C69-DF11-9D81-001517135351', 
'B2821698-7869-DF11-91E1-001517135511', 
'A6CFAE6D-916C-DF11-91E1-001517135511', 
'DA77784A-6D69-DF11-A530-0015171C1A75', 
'1BF49662-276A-DF11-B520-0015171C5BB3', 
'BBE6DC8E-406A-DF11-B520-0015171C5BB3', 
'30A70684-946C-DF11-B520-0015171C5BB3', 
'DFE93A3D-7469-DF11-93F1-00188B39EB5C', 
'96277191-1B6A-DF11-93F1-00188B39EB5C', 
'BABEF5BD-EBE9-E911-90B9-005056B10F02', 
'85BFBBB5-EDE9-E911-90B9-005056B10F02', 
'382495D0-EEE9-E911-90B9-005056B10F02', 
'1DEC600E-D898-ED11-80FB-005056B14E20', 
'AF6BCCE6-37A3-E911-AB90-005056B16BE3', 
'889C1C06-FD7E-E311-8219-0015171350B3', 
'48CD3D15-9761-DF11-89E9-0015171350B3', 
'FE47BCD1-E65B-E311-9299-001517135400', 
'989420C2-DE5B-E311-80E3-0015171C1A75', 
'D9BEEAF5-E35B-E311-80E3-0015171C1A75', 
'BD60B975-A699-DF11-B74C-0015171C5BB1', 
'F50529EB-966C-DF11-B520-0015171C5BB3', 
'FB15381B-F0E9-E911-90B9-005056B10F02', 
'C5B96E33-DA98-ED11-80FB-005056B14E20', 
'4B2CF5D0-DB98-ED11-80FB-005056B14E20', 
'52CA6A9B-EF5B-E311-9299-001517135400', 
'682BA8AB-EB5B-E311-80E3-0015171C1A75', 
'EBEC3CFB-E4E9-E911-90B9-005056B10F02', 
'173ADFA7-F0E9-E911-90B9-005056B10F02', 
'854D2A15-F2E9-E911-90B9-005056B10F02', 
'03726C21-D332-E811-A509-005056B133C3', 
'BDC3242A-3298-ED11-80FD-005056B135DF', 
'E340A834-DD98-ED11-80FB-005056B14E20', 
'1ACEBFC5-DF98-ED11-80FB-005056B14E20', 
'03726C21-D332-E811-A509-005056B133C3'
)


group by 
u.username,
ci.enrollment_datetime


-------------------------
select distinct
Case 
    when ci.course_name_at_time_of_enrollment is not NULL then 'Essentials of Pediatric Acute Care Orientation (EPACO)'
    End as Product_Name,
u.username,
u.first_name,
u.last_name,
convert(char(10),ci.enrollment_datetime,110) as Enrollment_Date,
convert(char(10),ci.completion_datetime,110) as Completion_Date,
ci.course_name_at_time_of_enrollment,
o.external_org_id as AO_Key,
o.org_name,
inst.org_node_name as Institution,
dept.org_node_name as Department,
ci.course_id,
ci.course_instance_id,
ci.course_instance_status_id,
cis.description as course_instance_status,
ci.estimated_completion_seconds,
us.user_student_id,
inst.org_node_id as Institution_ID,
dept.org_node_code as Dept_ID

from
dbo.org o with (nolock)
inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0
inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id 
inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id
inner join dbo.course_category_course_mapping cccm with (nolock)
on ci.course_id = cccm.course_id
inner join dbo.course_category cc with (nolock)
on cccm.course_category_id = cc.course_category_id
inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id
inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0

where 
u.username not in (select username from #t1)
and o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date-- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date
and ((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))
and o.external_org_id = @AO_Key
and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted


and ci.course_instance_interaction_mode_id not in ('1','6','7') 
and u.username not like '%test%'
and u.last_name not like '%test%'
and cccm.course_category_id in (

'15042364-D61C-E811-8806-005056B10652',
'DB13DF00-D91C-E811-8740-005056B12710')

and ci.course_id not in ('03726C21-D332-E811-A509-005056B133C3') --removing implementation guide

group by 
u.username,
u.first_name,
u.last_name,
ci.enrollment_datetime,
ci.completion_datetime,
ci.course_name_at_time_of_enrollment,
o.external_org_id,
o.org_name,
inst.org_node_name,
dept.org_node_name,
ci.course_id,
ci.course_instance_id,
ci.course_instance_status_id,
cis.description,
ci.estimated_completion_seconds,
us.user_student_id,
inst.org_node_id,
dept.org_node_code





END;

------------------------------------------
--ELSE
--BEGIN






--select distinct
--Case 
--    when ci.course_name_at_time_of_enrollment is not NULL then 'Essentials of Pediatric Acute Care Orientation (EPACO)'
--    End as Product_Name,
--u.username,
--u.first_name,
--u.last_name,
--convert(char(10),ci.enrollment_datetime,110) as Enrollment_Date,
--convert(char(10),ci.completion_datetime,110) as Completion_Date,
--ci.course_name_at_time_of_enrollment,
--o.external_org_id as AO_Key,
--o.org_name,
--inst.org_node_name as Institution,
--dept.org_node_name as Department,
--ci.course_id,
--ci.course_instance_id,
--ci.course_instance_status_id,
--cis.description as course_instance_status,
--ci.estimated_completion_seconds,
--us.user_student_id,
--inst.org_node_id as Institution_ID,
--dept.org_node_code as Dept_ID





--from
--dbo.org o with (nolock)
--inner join dbo.[user] u with (nolock)
--on o.org_id = u.org_id and u.is_deleted = 0
--inner join dbo.course_instance ci with (nolock)
--on u.user_id = ci.user_id 
--inner join dbo.course_instance_status cis with (nolock)
--on cis.course_instance_status_id = ci.course_instance_status_id





--inner join dbo.course_category_course_mapping cccm with (nolock)
--on ci.course_id = cccm.course_id

--inner join dbo.course_category cc with (nolock)
--on cccm.course_category_id = cc.course_category_id
------------------------------------------------------------------------
--inner join dbo.user_student us with (nolock)
--on us.user_student_id = ci.user_student_id
--inner join dbo.org_node dept with (nolock)
--on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
--inner join dbo.org_node inst with (nolock)
--on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0

--inner join dbo.org_node on3 with (nolock)
--on inst.parent_org_node_id = on3.org_node_id

--inner join dbo.org_node on4 with (nolock)
--on on3.parent_org_node_id = on4.org_node_id

--inner join dbo.org_node on5 with (nolock)
--on on4.parent_org_node_id = on5.org_node_id
------------------------------------------------------------------------

--where

--((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))

--and o.is_deleted = 0
--and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
--and ci.enrollment_datetime <= @Query_End_Date
--and o.external_org_id = @AO_Key
--and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted


--and ci.course_instance_interaction_mode_id not in ('1','6','7') 
--and cccm.course_category_id in (

--'15042364-D61C-E811-8806-005056B10652',
--'DB13DF00-D91C-E811-8740-005056B12710')

--and ci.course_id not in ('03726C21-D332-E811-A509-005056B133C3') --removing implementation guide


--END
