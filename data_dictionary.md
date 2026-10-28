# Data Dictionary: `PolicingMH.csv`

> **Simulated data, for teaching only.** The variables are modeled on administrative measures that police services commonly release, and the patterns follow trends reported in the research literature. This dataset is **not real**, so make **no real-world claims** from it.

## About the Dataset

River City Police Service (RCPS) is a mid-sized urban police service serving about 650,000 residents. After public concern about how police respond to people in mental health crises, RCPS compiled this extract of its administrative records to review use of force in these calls.

- **Scope:** One year of police-attended mental health crisis calls in which a use-of-force report was filed.
- **Unit of analysis:** One row is one call, with one primary responding officer and one individual in crisis.
- **Independence:** Repeat calls involving the same individual were removed, so each individual appears only once.
- **Rows:** 450 calls. **Columns:** 13.

### Sources

| Source | Description |
|---|---|
| Computer-Aided Dispatch (CAD) records | Created by the dispatcher when a call is received. Information recorded at dispatch is passed to responding officers before they arrive. |
| Occurrence reports | Completed by the responding officer. |
| Use-of-force reports | Completed by the responding officer. |
| RCPS personnel records | Officer service history. |
| Census tract data | Linked to each call by incident location. |

## Variables

Variables are listed in the order they appear in the dataset.

| # | Variable | Type | Description | Values | Source |
|---|---|---|---|---|---|
| 1 | `case_id` | Integer (ID) | Unique number for each call in this extract. | Whole numbers, 1 to 450 | Dataset compilation |
| 2 | `force_severity` | Numeric | Overall severity of force used by police during the call. A composite score combining the type of force used (e.g., physical restraint, intermediate weapons), officer-reported intensity, and the resulting level of injury to the individual in crisis. | 0 to 100, one decimal place. 0 = no force used. Higher = more severe force. | Use-of-force reports |
| 3 | `dispatch_risk` | Categorical (ordinal) | Risk level the dispatcher assigned to the call, based on information from the caller. | `Low`, `Moderate`, `High` | CAD records |
| 4 | `weapon` | Binary | Whether the individual in crisis was reported to have a weapon, either by the caller or as observed by officers. | `No`, `Yes` | Occurrence and use-of-force reports |
| 5 | `co_response` | Binary | Whether a mental health co-response team (a police officer paired with a mental health clinician) attended the call. | `No`, `Yes` | CAD records |
| 6 | `backup_units` | Binary | Whether additional police units were called to assist the primary responding officer. | `No`, `Yes` | CAD records |
| 7 | `race` | Categorical (nominal) | Race of the individual in crisis, as perceived and recorded by the responding officer. RCPS uses only three categories, so anyone not recorded as White or Black is recorded as Other. | `White`, `Black`, `Other` | Officer-reported demographic field |
| 8 | `subject_distress` | Numeric | Level of distress shown by the individual in crisis, as rated by the responding officer. | 0 to 100, one decimal place. 0 = no distress. Higher = greater distress. | Occurrence reports |
| 9 | `disadvantage` | Numeric | Structural disadvantage of the neighbourhood where the call took place. A composite index combining household income, unemployment, housing instability, and educational attainment. | 0 to 100, one decimal place. Scores are relative to other River City neighbourhoods. 0 = least disadvantaged. Higher = more disadvantaged. | Census tract data, linked by incident location |
| 10 | `pov_rate` | Numeric | Percentage of residents in the neighbourhood where the call took place who live below the poverty line. | Percentage (0 to 100), one decimal place | Census tract data, linked by incident location |
| 11 | `officer_years` | Numeric | The primary responding officer's years of service at the time of the call. | Years, one decimal place (e.g., 2.5 = two and a half years) | RCPS personnel records |
| 12 | `shift` | Categorical (ordinal by time) | Shift during which the call was received. | `Day` (07:00 to 15:00), `Evening` (15:00 to 23:00), `Overnight` (23:00 to 07:00) | CAD records |
| 13 | `call_ref` | Integer (ID) | Reference number the dispatch system assigned to the call. | Six-digit number | CAD records |

## Missing Data

Not every field was completed for every call. Missing entries were **not** left blank. They were filled with the placeholder code **`-999`**, which appears in both numeric and text variables. **Recode `-999` to missing (NA) before any analysis.** Otherwise it will distort means, ranges, and models, and it will show up as a fake fourth category in categorical variables.

## Additional Notes

- **Selection on the outcome:** The extract includes only calls where a use-of-force report was filed. Calls that ended without any force are not in the data.
- **Police-recorded measures:** Information about the call and the individual in crisis (`dispatch_risk`, `weapon`, `subject_distress`) reflects what police and dispatch staff recorded, often based on officer judgment rather than independent observation.
- **Neighbourhood measures:** `disadvantage` and `pov_rate` describe the neighbourhood where the call took place, which may not be where the individual in crisis lives.

## Observed in the File (checked 2026-10-27)

These checks were run directly on `PolicingMH.csv`. They are not part of the official codebook.

| Variable | `-999` count | Observed range / counts (excluding `-999`) |
|---|---|---|
| `case_id` | 0 | 1 to 450, all unique |
| `force_severity` | 6 | 25.9 to 82.4 (no 0 values) |
| `dispatch_risk` | 4 | Low 164, Moderate 186, High 96 |
| `weapon` | 0 | No 342, Yes 108 |
| `co_response` | 0 | No 243, Yes 207 |
| `backup_units` | 3 | No 225, Yes 222 |
| `race` | 8 | White 283, Black 84, Other 75 |
| `subject_distress` | 5 | 5.1 to 92.9 |
| `disadvantage` | 4 | 9.4 to 89.7 |
| `pov_rate` | 3 | 1.5 to 37.5 |
| `officer_years` | 6 | 0.6 to 18.9 |
| `shift` | 4 | Day 150, Evening 159, Overnight 137 |
| `call_ref` | 0 | 102710 to 998751. **449 unique values across 450 rows (one duplicate).** |

**File quirks:**
- The file starts with a UTF-8 BOM, so read it with `encoding='utf-8-sig'` (Python) or `fileEncoding = "UTF-8-BOM"` (R). Otherwise the first column name becomes `﻿case_id`.
- Use `case_id`, not `call_ref`, as the row key.
