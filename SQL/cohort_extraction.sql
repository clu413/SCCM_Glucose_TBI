# get counts for different initial admission diagnoses 

SELECT apacheadmissiondx, count(*) as count
FROM `physionet-data.eicu_crd.patient`     
GROUP BY apacheadmissiondx
ORDER BY count desc

# extract relevant information from patient table 
with test as (
select patientunitstayid, patienthealthsystemstayid, gender, age, ethnicity, hospitalid, apacheadmissiondx, hospitaladmitsource, hospitaldischargeoffset, hospitaldischargestatus, unittype, unitvisitnumber, unitdischargeoffset, unitdischargelocation, unitdischargestatus, uniquepid 
, case
  when apacheadmissiondx in ('CVA, cerebrovascular accident/stroke', 'Seizures (primary-no structural brain disease)', 'Hemorrhage/hematoma, intracranial','Cranial nerve, decompression/ligation')
    then 'AIS'
  when apacheadmissiondx in ('Hemorrhage/hematoma, intracranial', 'Hematoma, subdural','Subarachnoid hemorrhage/intracranial aneurysm','Hematoma subdural, surgery for','Subarachnoid hemorrhage/intracranial aneurysm, surgery for','Hemorrhage/hematoma-intracranial, surgery for','Subarachnoid hemorrhage/arteriovenous malformation')
    then 'HEM'
  when apacheadmissiondx in ('Head only trauma','Head/multiple trauma','Head/face trauma','Head/extremity trauma','Head/chest trauma','Head/spinal trauma','Head/abdomen trauma','Head/pelvis trauma')
    then 'TBI'
  when apacheadmissiondx in ('Seizures (primary-no structural brain disease)','Seizures-intractable, surgery for')
    then 'SZ'  
  when apacheadmissiondx in ('Coma/change in level of consciousness (for hepatic see GI, for diabetic see Endocrine, if related to cardiac arrest, see CV', 'Neoplasm-cranial, surgery for (excluding transphenoidal)','Neoplasm, neurologic', 'Neurologic medical, other','Encephalopathies (excluding hepatic)', 'Neurologic surgery, other','Cranioplasty and complications from previous craniotomies','Transphenoidal surgery','Meningitis','Burr hole placement','Shunts and revisions','Hydrocephalus, obstructive','Biopsy, brain','Encephalitis','Ventriculostomy','Cerebrospinal fluid leak, surgery for','Nontraumatic coma due to anoxia/ischemia')
   then 'Other'
   else 'Not_relevant' end as brain_problem,
   case when apacheadmissiondx in ('Subarachnoid hemorrhage/intracranial aneurysm, surgery for', 'Neoplasm-cranial, surgery for (excluding transphenoidal)','Neurologic surgery, other','Hematoma subdural, surgery for','Subarachnoid hemorrhage/intracranial aneurysm, surgery for','Cranioplasty and complications from previous craniotomies','Transphenoidal surgery','Hemorrhage/hematoma-intracranial, surgery for','Burr hole placement','Shunts and revisions','Biopsy, brain','Cranial nerve, decompression/ligation','Ventriculostomy','Cerebrospinal fluid leak, surgery for','Seizures-intractable, surgery for')
   then 'Yes'
   else 'No' end as surgery
FROM `physionet-data.eicu_crd.patient` )
SELECT *
from test
WHERE brain_problem NOT LIKE 'Not_relevant'
