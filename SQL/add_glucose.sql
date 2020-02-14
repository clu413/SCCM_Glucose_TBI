SELECT *
FROM `sccm-datathon.team_5.Patients_info`
LEFT JOIN `sccm-datathon.team_5.glucose_chart`
USING(patientunitstayid)

-- save as Patients_w_glucose
