

-------Checklist Management-------

	SELECT DISTINCT

Case 
    when ci.course_name_at_time_of_enrollment is not NULL then 'Checklist Management'
    End as Product_Name,
		u.username,
		u.first_name,
		u.last_name,
ci.enrollment_datetime as Enrollment_Date,
ci.completion_datetime as Completion_Date,

cm.Course_Module_Name as Checklist_Name,

o.external_org_id as AO_Key,
o.org_name,
onode_parent.org_node_name AS Institution,
onode.org_node_id as Department,
ci.course_id,
 ci.course_instance_id,
ci.course_instance_status_id,
cis.description as course_instance_status,
ci.estimated_completion_seconds,
us.user_student_id,
onode_parent.org_node_id as Institution_ID,
onode.org_node_code as Dept_ID,
ci.course_name_at_time_of_enrollment as Course_Name,
cmi.course_module_instance_id


	from dbo.assessment_instance asi  WITH (NOLOCK)
	INNER JOIN dbo.assessment_type at WITH (NOLOCK)
				ON asi.assessment_type_id = at.assessment_type_id
	INNER JOIN dbo.assessment_instance_mapping aim WITH (NOLOCK)
		  ON aim.assessment_instance_id = asi.assessment_instance_id 
		  AND aim.is_deleted = 0
	INNER JOIN dbo.course_module_instance cmi WITH (NOLOCK)
		  ON cmi.course_module_instance_id = aim.course_module_instance_id 
		 AND cmi.is_deleted = 0
	INNER JOIN dbo.course_instance ci WITH (NOLOCK)
		  ON cmi.course_instance_id = ci.course_instance_id 
		  and ci.is_deleted = 0
	

	INNER JOIN dbo.user_student us WITH (NOLOCK) 
		  ON ci.user_student_id = us.user_student_id
		  AND us.is_deleted=0

	INNER JOIN dbo.[user] u WITH (NOLOCK)
		  ON us.[user_id] = u.[user_id]
		  AND u.is_deleted = 0
	INNER JOIN dbo.[user] ue WITH (NOLOCK)
		  ON asi.evaluator_user_id = ue.[user_id]
		  AND ue.is_deleted = 0   
	left JOIN dbo.org_node onode WITH (NOLOCK) --DEPT
		  ON us.org_node_id = onode.org_node_id
		  AND onode.is_deleted=0
	left JOIN dbo.org_node onode_parent WITH (NOLOCK)--INST 
		  ON onode.parent_org_node_id = onode_parent.org_node_id
		  AND onode_parent.is_deleted=0
    --left JOIN dbo.org_node Division WITH (NOLOCK)--division
		  --ON division.org_node_id = onode_parent.parent_org_node_id
		  --AND Division.is_deleted=0
	INNER JOIN dbo.org o WITH (NOLOCK) 
		  ON onode.org_id = o.org_id
		  AND o.is_deleted = 0
	INNER JOIN dbo.course c WITH (NOLOCK)
		  ON c.course_id = ci.course_id
		  AND c.course_version = ci.course_version
		  AND (c.course_module_types & 524288) = 524288 
		  AND c.is_deleted = 0
	INNER JOIN dbo.course_module_mapping cmm WITH (NOLOCK)
		on cmi.course_module_Id=cmm.course_module_Id
		and cmm.is_deleted=0
	INNER JOIN dbo.course_module cm WITH (NOLOCK)
		ON cmm.course_module_Id=cm.course_module_Id
		and cm.is_deleted=0
	INNER JOIN dbo.course_instance_status cis WITH (NOLOCK)
		ON ci.course_instance_status_ID=cis.course_Instance_Status_Id
	--LEFT JOIN dbo.org_node on1 WITH (NOLOCK)--division
	--	  ON on1.org_node_id = Division.parent_org_node_id
	--	  AND on1.is_deleted=0
	--LEFT JOIN dbo.org_node on2 WITH (NOLOCK)--division
	--	  ON on2.org_node_id = on1.parent_org_node_id
	--	  AND on2.is_deleted=0
	--LEFT JOIN dbo.org_node on3 WITH (NOLOCK)--division
	--	  ON on3.org_node_id = on2.parent_org_node_id
	--	  AND on3.is_deleted=0
	WHERE asi.is_deleted = 0
			AND   asi.assessment_type_id in (3,4)
			AND o.org_type_id = 1 

	AND c.owner_org_node_id <>  'FFFFFFFF-FFFF-FFFF-FFFF-000000000002'
	AND cmi.course_module_instance_status_id in (2,3,4,5) 

		  AND ci.course_instance_interaction_mode_id in (3,5,9)
		and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) 

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null))
	and ((ci.enrollment_datetime >= @query_start_Date) and (ci.enrollment_datetime <= @query_end_date))

	and u.username not like '%test%'
and u.last_name not like '%test%'
	
	and o.external_org_id = @AO_Key 


	and (c.course_name not like 'EBSCO%' or c.course_name not like 'NRSRES%' or c.course_name not like 'PRECDV%' or c.course_name not like 'JANE%')

	
