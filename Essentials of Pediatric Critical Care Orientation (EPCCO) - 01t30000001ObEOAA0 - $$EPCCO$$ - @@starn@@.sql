

-------Essentials of Pediatric Critical Care Orientation (EPCCO)-------

Drop table if exists #t1
Drop table if exists #t2

--------------------------------------------------------------------------------------------------------
set @PriorPurchases = 1 
If @PriorPurchases = 1
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
and cccm.course_category_id in
('5ECE2477-B77B-DF11-93F1-00188B39EB5C',
'B7DCC91F-D91C-E811-8740-005056B12710')

and ci.course_id not in ( '38BB7A9B-13AA-DF11-8A59-001517135511') -- removing implementation guide 




group by 
u.username,
ci.enrollment_datetime


-------------------------
select distinct
Case 
    when ci.course_name_at_time_of_enrollment is not NULL then 'Essentials of Pediatric Critical Care Orientation (EPCCO)'
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
and cccm.course_category_id in
('5ECE2477-B77B-DF11-93F1-00188B39EB5C',
'B7DCC91F-D91C-E811-8740-005056B12710')

and ci.course_id not in ( '38BB7A9B-13AA-DF11-8A59-001517135511') -- removing implementation guide 

group by 
u.username,
u.first_name,
u.last_name,
convert(char(10),ci.enrollment_datetime,110),
convert(char(10),ci.completion_datetime,110),
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
ELSE
BEGIN






select distinct
Case 
    when ci.course_name_at_time_of_enrollment is not NULL then 'Essentials of Pediatric Critical Care Orientation (EPCCO)'
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
----------------------------------------------
from
dbo.org o with (nolock)
----------------------------------------------------------------------
inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0

inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id  	and ci.is_deleted in (0,1)

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
----------------------------------------------------------------------

where o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date  -- Replace Date Here
and u.username not like '%test%'
and u.last_name not like '%test%'

and o.external_org_id = @AO_Key 

and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted


and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and cccm.course_category_id in
('5ECE2477-B77B-DF11-93F1-00188B39EB5C',
'B7DCC91F-D91C-E811-8740-005056B12710')

and ci.course_id not in ( '38BB7A9B-13AA-DF11-8A59-001517135511') -- removing implementation guide 

Order by 1



END
