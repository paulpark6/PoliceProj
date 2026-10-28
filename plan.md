# Capstone Plan: Use of Force in Mental Health Crisis Calls (RCPS)

> Simulated data, for teaching only. Make no real-world claims. Variable definitions are in `data_dictionary.md`.
>
> **`rules.md` is the source of truth** (assignment instructions + enforced folder rule). Answer style is in `answer_memory.md`. Project overview is in `instruction.md`. If this plan conflicts with `rules.md` or the script, they win.

**How to give feedback:** Write under any `Feedback:` line, or cite an ID in chat (e.g., "3.7: shift should be nominal").

## 0. Overview

| Part | What it does | Feeds into |
|---|---|---|
| **Part 1: Univariate & Cleaning** (Steps 1–7 below) | Clean the data, describe one variable at a time, and evaluate how the data was collected | Variable types decide which tests are allowed in Part 2 |
| **Part 2: Bivariate** | Test the DV against each IV, one pair at a time | Significant IVs move on to Part 3 |
| **Part 3: Multiple Regression** | Put the significant IVs into one model | Use the Part 1 critique to say what the model can and cannot show |

| Step | Title | Status |
|---|---|---|
| 1 | R Project setup | Done |
| 2 | Codebook audit | Done (script STEP 1) |
| 3 | Classify variables | Done (script STEP 1). `shift` changed to nominal |
| 4 | Match tests | Done (script STEP 1) |
| 5 | Inspect & clean | Done (script STEPS 2–3). Script runs start to finish |
| 6 | Univariate results | Done (script STEP 4A/4B) |
| 7 | Critical evaluation | Draft done in `Critical_Evaluation.docx` (topics 7.1 + 7.3). Needs name, student number, course readings |
| P2, P3 | Bivariate, regression | Instructions not given yet |

**Still open for Part 1:** name and student number at top of the script, checking code against the course tutorials, optional plain-language sentences for the IQR/SD answers, and the critical evaluation placeholders.

---

## Step 1: R Project Setup

- 1.1 Folder: `/Users/paulpark/Downloads/PoliceProj/`, which already holds `PolicingMH.csv`.
- 1.2 Done: `Capstone Assignment Pt 1_Student Script.R` is in this folder.
- 1.3 Done: `PoliceProj.Rproj` is in this folder.
- 1.4 R 4.5.3 runs from `.r-env/` (micromamba + conda-forge; epiDisplay from CRAN), with nothing installed system-wide. Run scripts with `.r-env/env/bin/Rscript`. **To uninstall, delete `.r-env/` (1.7 GB).** No other files exist outside it.

Feedback:

---

## Step 2: Codebook Audit

- 2.1 **Research question:** *What factors are associated with the severity of police use of force when responding to mental health crisis calls?*
- 2.2 **Admin IDs, excluded from analysis:** `case_id` (row number from compiling the extract) and `call_ref` (dispatch tracking number). Their numbers carry no meaning, so they cannot explain force.
- 2.3 **DV:** `force_severity`.
- 2.4 **IVs (10):** `dispatch_risk`, `weapon`, `co_response`, `backup_units`, `race`, `shift`, `subject_distress`, `disadvantage`, `pov_rate`, `officer_years`.
- 2.5 Check: 13 columns − 2 IDs = 11 variables, split into 6 categorical (script Step 4A) and 5 numeric (script Step 4B). This matches the script.

Feedback:

---

## Step 3: Classify Each Variable

| ID | Variable | Role | Type | Scale | Values | Reason |
|---|---|---|---|---|---|---|
| 3.1 | `force_severity` | DV | Numeric | Continuous / ratio | 0–100 | 0 = no force (true zero) |
| 3.2 | `dispatch_risk` | IV | Categorical | **Ordinal** | Low < Moderate < High | Risk has a natural rank |
| 3.3 | `weapon` | IV | Categorical | Nominal (binary) | No, Yes | Two unranked groups |
| 3.4 | `co_response` | IV | Categorical | Nominal (binary) | No, Yes | Two unranked groups |
| 3.5 | `backup_units` | IV | Categorical | Nominal (binary) | No, Yes | Two unranked groups |
| 3.6 | `race` | IV | Categorical | Nominal | White, Black, Other | No rank |
| 3.7 | `shift` | IV | Categorical | **Nominal** (user decision) | Day, Evening, Overnight | Shifts are treated as unranked groups |
| 3.8 | `subject_distress` | IV | Numeric | Continuous / ratio | 0–100 | 0 = no distress |
| 3.9 | `disadvantage` | IV | Numeric | Continuous (**strictly interval**) | 0–100 | 0 = *least* disadvantaged relative to other neighbourhoods, not *zero* disadvantage, so there is no true zero |
| 3.10 | `pov_rate` | IV | Numeric | Continuous / ratio | 0–100 % | 0 % = nobody in poverty |
| 3.11 | `officer_years` | IV | Numeric | Continuous / ratio | Years | 0 = no service |

Feedback:

---

## Step 4: Bivariate Test for Each DV–IV Pair (used in Part 2)

The DV `force_severity` is continuous and close to normal (skew 0.36, kurtosis −0.40), so the default is the parametric test.

| ID | IV | IV type | Test (parametric) | Non-parametric alternative |
|---|---|---|---|---|
| 4.1 | `weapon` | Binary | Independent-samples t-test | Mann-Whitney U |
| 4.2 | `co_response` | Binary | Independent-samples t-test | Mann-Whitney U |
| 4.3 | `backup_units` | Binary | Independent-samples t-test | Mann-Whitney U |
| 4.4 | `dispatch_risk` | 3 groups (ordinal) | One-way ANOVA | Kruskal-Wallis (or Spearman, since it is ordinal) |
| 4.5 | `race` | 3 groups | One-way ANOVA | Kruskal-Wallis |
| 4.6 | `shift` | 3 groups (nominal) | One-way ANOVA | Kruskal-Wallis |
| 4.7 | `subject_distress` | Continuous | Pearson's r | Spearman's ρ |
| 4.8 | `disadvantage` | Continuous | Pearson's r | Spearman's ρ |
| 4.9 | `pov_rate` | Continuous | Pearson's r | Spearman's ρ |
| 4.10 | `officer_years` | Continuous, **skewed** | Pearson's r | **Spearman's ρ may be the better fit** (skew 1.19) |

Feedback:

---

## Step 5: Inspect & Clean

**What the raw file shows (checked in Python):**

- 5.1 The file has 450 rows × 13 columns.
- 5.2 The file starts with a UTF-8 BOM. Base `read.csv()` may rename the first column to `X.U.FEFF.case_id` or `ï..case_id`. Use `readr::read_csv()` or `read.csv(..., fileEncoding = "UTF-8-BOM")`.
- 5.3 `-999` counts per variable: force_severity 6, dispatch_risk 4, backup_units 3, race 8, subject_distress 5, disadvantage 4, pov_rate 3, officer_years 6, shift 4. The other columns have none.
- 5.4 After recoding, **407 of 450 rows are complete**: 43 rows have at least one NA. Regression in Part 3 will drop those rows.
- 5.5 Apart from `-999`, every value is inside the codebook ranges.
- 5.6 `call_ref` 955957 appears twice (cases 8 and 288), but every other field differs between the two rows. These are two different calls sharing a reference number, i.e., a data-entry quality issue. No action needed, because `call_ref` is excluded.

**Cleaning steps in R (done in script STEP 3):**

- 5.7 Make a copy: `df_clean <- df`, and keep the raw data untouched.
- 5.8 Recode: `df_clean[df_clean == -999] <- NA`. This one line works for both numeric and text columns. NA counts match 5.3.
- 5.9 Convert the 6 categorical variables to factors with `as.factor()`, one line each.
- 5.10 Set level order:
  - `dispatch_risk`: Low, Moderate, High (done, the only re-ordered variable)
  - `shift`: nominal, so not re-ordered (alphabetical Day, Evening, Overnight)
  - binaries: No, Yes (alphabetical order is already correct)
  - `race`: not re-ordered in Part 1 (nominal). For Part 3, consider setting White as the reference group. The alphabetical default makes Black the reference.
- 5.11 Use `factor(x, levels = ...)`, **not** `ordered = TRUE`, unless the tutorial says otherwise. Ordered factors give polynomial contrasts (`.L`, `.Q`) in `lm()`, which are hard to interpret in Part 3.
- 5.12 Verify with `colSums(is.na(df_clean))`, `str(df_clean)`, and `levels(df_clean$dispatch_risk)`.

Feedback:

---

## Step 6: Univariate Results (NAs excluded; confirmed in R and written into script STEP 4)

### 6A: Categorical (frequency table + bar chart with `tab1()`)

| ID | Variable | Counts (valid %) | Mode | Unimodal? |
|---|---|---|---|---|
| 6A.1 | `dispatch_risk` | Low 164 (36.8), **Moderate 186 (41.7)**, High 96 (21.5) | Moderate | Yes |
| 6A.2 | `weapon` | **No 342 (76.0)**, Yes 108 (24.0) | No | Yes |
| 6A.3 | `co_response` | **No 243 (54.0)**, Yes 207 (46.0) | No | Yes |
| 6A.4 | `backup_units` | **No 225 (50.3)**, Yes 222 (49.7) | No | Technically yes, but it is a near tie (only 3 apart), so effectively an even split |
| 6A.5 | `race` | **White 283 (64.0)**, Black 84 (19.0), Other 75 (17.0) | White | Yes |
| 6A.6 | `shift` | Day 150 (33.6), **Evening 159 (35.7)**, Overnight 137 (30.7) | Evening | Yes, but nearly even |

### 6B: Numeric (histogram + `psych::describe()` + `summary()` / `IQR()`)

| ID | Variable | n | Mean | Median | SD | Min–Max (Range) | Q1–Q3 (IQR) | Skew | Kurt | Mean ± 2SD | % inside |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 6B.1 | `force_severity` | 444 | 49.97 | 48.40 | 11.32 | 25.9–82.4 (56.5) | 41.48–58.02 (16.55) | 0.36 | −0.40 | 27.3–72.6 | 95.9 % |
| 6B.2 | `subject_distress` | 445 | 49.22 | 48.40 | 20.73 | 5.1–92.9 (87.8) | 33.40–65.80 (32.40) | 0.12 | −0.91 | 7.8–90.7 | 98.4 % |
| 6B.3 | `disadvantage` | 446 | 49.73 | 49.15 | 18.31 | 9.4–89.7 (80.3) | 36.02–62.75 (26.72) | 0.07 | −0.73 | 13.1–86.3 | 98.2 % |
| 6B.4 | `pov_rate` | 447 | 20.88 | 20.80 | 7.10 | 1.5–37.5 (36.0) | 15.40–25.85 (10.45) | 0.04 | −0.54 | 6.7–35.1 | 96.2 % |
| 6B.5 | `officer_years` | 444 | 4.74 | **3.00** | 4.30 | 0.6–18.9 (18.3) | 1.30–7.03 (5.73) | **1.19** | 0.47 | **−3.9**–13.3 | 93.5 % |

**Interpretation draft:**

- 6B.1 `force_severity`: mean ≈ median, slight right skew, close to normal. **No zero scores** (minimum 25.9), because only calls where force was used are in the data (see 7.1).
- 6B.2 `subject_distress`: symmetric, but flat (kurtosis −0.91), with a very wide spread.
- 6B.3 `disadvantage` and 6B.4 `pov_rate`: symmetric and close to normal.
- 6B.5 `officer_years`: **right-skewed**. Most officers are junior, with a long tail of veterans. The median (3.0) describes the typical officer better than the mean (4.74). Mean − 2SD gives a negative number of years, which is impossible, so the empirical rule fails for this skewed variable.
- 6B.6 Normality cutoff options (kurtosis here is excess kurtosis, as `psych::describe` reports it):

| Option | Rule | Source | Result in this data |
|---|---|---|---|
| **A (default)** | \|skew\| < 1 and \|kurt\| < 1 | Common intro-stats rule of thumb | The first four pass; `officer_years` fails (skew 1.19) |
| B | \|skew\| < 2 and \|kurt\| < 2 | George & Mallery (2010) | All five pass |
| C | \|skew\| < 2 and \|kurt\| < 7 | West, Finch & Curran (1995) | All five pass |
| D | skew ÷ SE and kurt ÷ SE within ±1.96 | Significance test | Almost all fail; with n ≈ 445 it flags trivial deviations |

  Whichever option is used, also check the histogram shape. The `officer_years` histogram is clearly skewed.

Feedback:

---

## Step 7: Critical Evaluation (draft points)

Chosen for the paper: **7.1 Selection on the outcome** and **7.3 Who created the numbers** (measurement bias). The other points are not used.

- 7.1 **Selection on the outcome:** Only calls with force are included.
  - We can study *how severe* force was, but not *why force happens at all*.
  - Calls that de-escalated (possibly the co-response successes) are invisible, so the `co_response` effect is probably understated.
  - The DV has a restricted range (no zeros), which weakens correlations.
- 7.2 **Repeat calls removed:**
  - This erases chronic crises and repeated police contact, and the people with the most police contact are often the most marginalized.
  - The codebook does not say which call was kept (first, last, or random), and that choice changes the picture.
- 7.3 **Who created the numbers:**
  - `force_severity` (partly), `subject_distress`, and `weapon` are recorded by the officer who used the force.
  - There is a risk of post-hoc justification: inflating distress or weapon presence, and downplaying force.
  - Shared reporter bias can create a false distress–force correlation.
  - `weapon` mixes caller reports with officer observation.
  - `dispatch_risk` depends on what the caller said.
- 7.4 **Composite DV:** `force_severity` mixes force type, officer-rated intensity, and injury, with unknown weights. Very different incidents can get the same score.
- 7.5 **Race:**
  - Race is officer-perceived, not self-identified, so misclassification is likely.
  - "Other" lumps Indigenous, Asian, Latino, Middle Eastern, and other people into one group. That hides differences between them (e.g., Indigenous overrepresentation in use of force), and opposite effects can cancel out.
- 7.6 **Neighbourhood ≠ person:**
  - `disadvantage` and `pov_rate` describe where the call happened, not where the person lives.
  - Treating them as personal circumstances is an ecological fallacy.
  - The measure may reflect how police patrol an area rather than who the person is.
- 7.7 **Two measures of one concept:** `disadvantage` and `pov_rate` correlate at **r = 0.96** (income is part of the disadvantage index). They measure nearly the same thing, and this matters in Part 3.

Feedback:

---

## Part 2: Bivariate (later)

- P2.1 Run the 10 tests from Step 4 at α = .05, and report the test statistic, p-value, and effect direction for each.
- P2.2 Carry the significant IVs forward.

## Part 3: Multiple Regression (later)

- P3.1 `lm(force_severity ~ <significant IVs>, data = df_clean)`.
- P3.2 If both `disadvantage` and `pov_rate` are significant, check multicollinearity (VIF), keep one, and justify the choice.
- P3.3 n drops to at most 407 complete cases. Report this.
- P3.4 Interpret categorical coefficients against their reference levels (5.10).
- P3.5 Link the limits back to Step 7: no causal claims, a selected sample, and officer-reported measures.

---

## Open Questions

| ID | Question | Answer / default |
|---|---|---|
| Q1 | Research question | **Answered:** see 2.1 |
| Q2 | Skew/kurtosis cutoffs | **Default:** Option A (see 6B.6) |
| Q3 | Empirical rule multiplier | **Answered:** 2 × SD |
| Q4 | `shift` scale | **Answered:** nominal (user changed it from ordinal) |
| Q5 | `disadvantage` scale | **Default:** "Continuous", with a note that it is interval |
| Q6 | Test names | **Default:** parametric, plus Spearman for `officer_years` |
| Q7 | `race` reference level | **Default:** White (largest group) |
| Q8 | Where R runs | **Answered:** project-local env in `.r-env/` (1.4) |
| Q9 | Critical evaluation topics | **Answered:** 7.1 + 7.3 |
