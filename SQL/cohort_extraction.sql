-- 1. get counts for different initial admission diagnoses 

SELECT apacheadmissiondx, count(*) as count
FROM `physionet-data.eicu_crd.patient`     
GROUP BY apacheadmissiondx
ORDER BY count desc

-- gave to clinicians to annotate

-- 2. extract relevant information from patient table 
with dx as (
select patientunitstayid, patienthealthsystemstayid, gender, age, ethnicity, hospitalid, apacheadmissiondx, hospitaladmitsource, hospitaldischargeoffset, hospitaldischargestatus, unittype, unitvisitnumber, unitdischargeoffset, unitdischargelocation, unitdischargestatus, uniquepid 
, case
  when apacheadmissiondx in ('CVA, cerebrovascular accident/stroke', 'Hemorrhage/hematoma, intracranial','Cranial nerve, decompression/ligation')
    then 'AIS'
  when apacheadmissiondx in ('Hemorrhage/hematoma, intracranial', 'Hematoma, subdural','Subarachnoid hemorrhage/intracranial aneurysm','Hematoma subdural, surgery for','Subarachnoid hemorrhage/intracranial aneurysm, surgery for','Hemorrhage/hematoma-intracranial, surgery for','Subarachnoid hemorrhage/arteriovenous malformation')
    then 'HEM'
  when apacheadmissiondx in ('Head only trauma','Head/multiple trauma','Head/face trauma','Head/extremity trauma','Head/chest trauma','Head/spinal trauma','Head/abdomen trauma','Head/pelvis trauma')
    then 'TBI'
  when apacheadmissiondx in ('Seizures (primary-no structural brain disease)','Seizures-intractable, surgery for', 'Seizures (primary-no structural brain disease)')
    then 'SZ'  
  when apacheadmissiondx in ('Coma/change in level of consciousness (for hepatic see GI, for diabetic see Endocrine, if related to cardiac arrest, see CV', 'Neoplasm-cranial, surgery for (excluding transphenoidal)','Neoplasm, neurologic', 'Neurologic medical, other','Encephalopathies (excluding hepatic)', 'Neurologic surgery, other','Cranioplasty and complications from previous craniotomies','Transphenoidal surgery','Meningitis','Burr hole placement','Shunts and revisions','Hydrocephalus, obstructive','Biopsy, brain','Encephalitis','Ventriculostomy','Cerebrospinal fluid leak, surgery for','Nontraumatic coma due to anoxia/ischemia')
   then 'Other'
   else 'Not_relevant' end as brain_problem,
   case when apacheadmissiondx in ('Subarachnoid hemorrhage/intracranial aneurysm, surgery for', 'Neoplasm-cranial, surgery for (excluding transphenoidal)','Neurologic surgery, other','Hematoma subdural, surgery for','Subarachnoid hemorrhage/intracranial aneurysm, surgery for','Cranioplasty and complications from previous craniotomies','Transphenoidal surgery','Hemorrhage/hematoma-intracranial, surgery for','Burr hole placement','Shunts and revisions','Biopsy, brain','Cranial nerve, decompression/ligation','Ventriculostomy','Cerebrospinal fluid leak, surgery for','Seizures-intractable, surgery for')
   then 'Yes'
   else 'No' end as surgery
FROM `physionet-data.eicu_crd.patient` )
SELECT *
from dx
WHERE brain_problem NOT LIKE 'Not_relevant'

-- save as Patients_w_brain_problems

-- 3. exclude patients who do not have Apache scores. Use Apacheversion IVa 
SELECT pt.*, apache.apachescore
FROM `sccm-datathon.team_5.Patients_w_brain_problems` as pt 
JOIN `physionet-data.eicu_crd.apachepatientresult` as apache 
USING(patientunitstayid)
WHERE apache.apachescore != -1 AND
apache.apacheversion LIKE 'IVa' AND
SAFE_CAST(age AS NUMERIC) > 17

-- save as 'Patients_w_apache' 

-- 4. add in diabetes info
SELECT pt.*, diabetes.diabetes_flag, diabetes.diabetes_type_1, diabetes.diabetes_type_2 
FROM `sccm-datathon.team_5.Patients_w_apache` as pt
LEFT OUTER JOIN `sccm-datathon.team_5.diabetes` as diabetes
ON pt.patientunitstayid = diabetes.patientunitstayid 

-- save as Patients_info

