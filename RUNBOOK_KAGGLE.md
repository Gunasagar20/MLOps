# Kaggle Runbook: Explainable RL Controller for Energy Assets (Phase 1)

This runbook documents the exact compute requirements, specifications, measured runtimes, and step-by-step procedures for running the Phase 1 pipeline on **Kaggle Notebooks**.

---

## 1. Kaggle Hardware Specifications & Limits

| Specification | Kaggle Default (CPU) | Kaggle GPU (T4 x 2) | Kaggle GPU (P100) | Notes & Strategy |
|---|---|---|---|---|
| **vCPUs** | 4 cores | 4 cores | 4 cores | Multi-processing enabled for CityLearn & SB3 |
| **System RAM** | 30 GB | 29 GB | 29 GB | Generous memory for 17-building year-long time series |
| **GPU / VRAM** | None | 2x 15 GB (30 GB total) | 16 GB | CityLearn simulation is CPU-bound; PyTorch SAC benefits from GPU |
| **Disk Space** | 20 GB (`/kaggle/working`) | 20 GB | 20 GB | Datasets require ~35 MB; models & artifacts require ~100 MB |
| **Max Run Time** | 12 hours (Batch / Save & Run) | 12 hours | 12 hours | Pipeline executes in < 30 minutes in full mode |
| **Weekly Quota** | Unlimited | 30 hours / week | 30 hours / week | CPU tier is free and unmetered; fast mode takes only ~3.5 min |
| **Internet Access** | Must be toggled **ON** | Must be toggled **ON** | Must be toggled **ON** | Required for initial pip packages and GitHub dataset sync |

> [!IMPORTANT]
> **Kaggle Setting:** In the right-hand panel of your Kaggle notebook, make sure **Internet is toggled to ON**.
> Kaggle notebooks disable internet by default for competitions; enabling internet is mandatory for downloading packages and dataset files.

---

## 2. Measured Stage Runtimes & Compute Map

Measured on 4-core virtual machines (comparable to Kaggle CPU/GPU kernels):

| Pipeline Stage | Fast Mode (`P1_FAST=1`) | Full Mode (`P1_FAST=0`) | Resource Bottleneck |
|---|---|---|---|
| **Environment & Package Setup** | 30 – 45 s | 30 – 45 s | Network bandwidth / wheel unzipping |
| **Dataset Acquisition (89 files, 6 scenarios)** | 15 – 20 s | 15 – 20 s | GitHub Raw API / Disk I/O |
| **Exploratory Data Analysis (EDA + figures)** | 18 – 25 s | 18 – 25 s | Pandas dataframes / Matplotlib |
| **Feature Engineering (`build_features.py`)** | 12 – 15 s | 12 – 15 s | Memory / lag rolling operations |
| **Next-Hour Load Forecasting Baselines** | 10 – 15 s | 10 – 15 s | Scikit-learn CPU (Ridge / HistGBM) |
| **Rule-Based Simulation Baselines (6 scenarios)** | 60 – 80 s | 60 – 80 s | CityLearn hourly step loop (Python/C) |
| **SAC RL Agent Training & Eval (`hvac_cz1`)** | 35 – 45 s (1.5k steps) | 18 – 22 min (50k steps) | PyTorch gradient steps + simulation steps |
| **Report Generation & KPI compilation** | 2 – 3 s | 2 – 3 s | Markdown formatting |
| **Total Pipeline Wall Clock** | **~3.5 minutes** | **~24 minutes** | **Well within Kaggle 12-hour limit** |

---

## 3. Step-by-Step Kaggle Execution

### Method 1: Uploading the Self-Contained Notebook (Recommended)
1. Go to [kaggle.com/code](https://www.kaggle.com/code) and click **New Notebook**.
2. In the top menu, click **File -> Import Notebook**.
3. Upload `notebooks/kaggle_phase1_run.ipynb` from this repository.
4. In the right-side Settings sidebar:
   - **Accelerator:** Select **None (CPU)** or **GPU T4 x2**.
   - **Internet:** Toggle to **On** (mandatory).
5. Click **Run All** (or use Shift+Enter through the cells).
6. The notebook will:
   - Verify Python environment and dependencies.
   - Download the 6 CityLearn datasets.
   - Run EDA and display the daily profile curves.
   - Verify feature engineering without data leakage.
   - Run forecasting models (Persistence, Seasonal Naive, Ridge, HistGBM).
   - Evaluate all baseline simulation controllers (No-Control, Basic RBC, TimeOfUse RBC).
   - Train and evaluate the SAC RL agent.
   - Display the complete Phase 1 KPI comparison table.
7. Click **Save Version -> Save & Run All (Commit)** to generate a permanent Kaggle run with downloadable HTML/PDF report and CSV output artifacts.

---

## 4. Output Artifacts Generated on Kaggle

At the conclusion of the notebook run, the following deliverables will be available in `/kaggle/working/`:
- `reports/PHASE1_EVALUATION.md`: Markdown evaluation table summarizing all KPIs against no-control baseline.
- `reports/baseline_kpis.csv`: Raw KPI dataframe (cost, carbon, peak, discomfort, unserved energy).
- `reports/forecast_metrics.csv`: Load forecasting metrics (MAE, RMSE, nMAE).
- `reports/eda/EDA_SUMMARY.md`: Data exploration summary.
- `reports/eda/*_daily_profiles.png`: 24-hour mean profile figures for all climate zones and scenarios.
- `data/processed/*_features.csv`: Engineered feature datasets.
- `configs/features.yaml`: Feature registry schema for Phase 2 explainability.
