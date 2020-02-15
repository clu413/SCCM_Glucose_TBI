SELECT *
FROM `sccm-datathon.team_5.Patients_info`
LEFT JOIN `sccm-datathon.team_5.glucose_chart`
USING(patientunitstayid)

-- save as Patients_w_glucose

SELECT *
FROM `sccm-datathon.team_5.Patients_w_glucose_plus`
LEFT JOIN `sccm-datathon.team_5.glucose_cohort_deltas`
USING(patientunitstayid)

-- save as Patients_w_glucose_and_deltas
