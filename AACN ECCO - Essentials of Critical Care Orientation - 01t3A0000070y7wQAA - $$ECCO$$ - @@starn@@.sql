

-------AACN ECCO: Essentials of Critical Care Orientation--------

drop table if exists #courses


Drop table if exists #t1
Drop table if exists #t2

--------------------------------------------------------------------------------------------------------

select distinct

cccm.course_id

into #courses

from dbo.course_category_course_mapping cccm
inner join dbo.course c on c.course_id = cccm.course_id and c.is_deleted = 0

where course_category_id in (


'1480B613-363A-E611-A1DA-005056B141CC',
'2DB25850-363A-E611-A1DA-005056B141CC',
'B105BBBD-363A-E611-A1DA-005056B141CC',
'1C0D87C4-363A-E611-A1DA-005056B141CC',
'323C3E06-F96A-DB11-8DC9-00137250EF26',
'8A821549-D0CC-DF11-80A1-001517135401',
'7FDF84C7-1D30-E711-9B4C-005056B12B9C',
'D4BC1DDA-1D30-E711-9B4C-005056B12B9C',
'C2BEC9C6-3A82-E011-B8A9-001517135213')



and c.course_id not in (

'B5C33CD5-24A5-E611-8934-005056B14D10',
'8E77790F-05A8-11DD-8A29-001517135123'
)

 
  

  and cccm.is_deleted = 0


set @PriorPurchases = 1 --IF Prior Purchases type 1, if no Prior Purchases type 0

If @PriorPurchases = 1
Begin

set @PriorYearStart = dateadd(year, -1, @Query_Start_Date)
set @PriorYearEnd = @query_Start_Date


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
and ci.enrollment_datetime>= @PriorYearStart
and ci.enrollment_datetime < @PriorYearEnd
and ((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))
and o.external_org_id = @ao_key
and ci.course_instance_interaction_mode_id <> 6
and ((ci.unenrollment_reason_type_id is NULL) or (ci.unenrollment_reason_type_id in ('0', '2', '3', '4')))
and u.username not like '%test%'
and u.last_name not like '%test%'
and ci.course_id in (select course_id from #courses)




group by 
u.username,
ci.enrollment_datetime


-------------------------
select distinct
case 
 when ci.course_name_at_time_of_enrollment  is not NULL then 'AACN ECCO: Essentials of Critical Care Orientation'
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
and ci.enrollment_datetime>= @Query_Start_Date-- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date
and ((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))
and o.external_org_id = @AO_Key
and ci.course_instance_interaction_mode_id <> 6
and ((ci.unenrollment_reason_type_id is NULL) or (ci.unenrollment_reason_type_id in ('0','2', '3', '4')))
and u.username not like '%test%'
and u.last_name not like '%test%'
and ci.course_id in (select course_id from #courses)

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
ELSE
BEGIN






select distinct

case 
 when ci.course_name_at_time_of_enrollment  is not NULL then 'AACN ECCO: Essentials of Critical Care Orientation'
 End as Product_Name,
----------------------------------------------------------------------
u.username,
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
----------------------------------------------------------------------
inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id
inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0

inner join dbo.org_node on3 with (nolock)
on inst.parent_org_node_id = on3.org_node_id

inner join dbo.org_node on4 with (nolock)
on on3.parent_org_node_id = on4.org_node_id

inner join dbo.org_node on5 with (nolock)
on on4.parent_org_node_id = on5.org_node_id
----------------------------------------------------------------------

where
((ci.unenrollment_reason_type_id is NULL) or (ci.unenrollment_reason_type_id in ('0', '2', '3', '4')))
and ((ci.completion_datetime >= ci.enrollment_datetime) or (ci.completion_datetime is NULL))

and o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date
and o.external_org_id = @AO_Key
and ci.course_instance_interaction_mode_id <> 6
and ci.course_id in (select course_id from #courses)


END
