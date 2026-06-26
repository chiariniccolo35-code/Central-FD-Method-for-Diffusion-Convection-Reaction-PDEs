# Documentation

## Report_Numeric_differential_equation.pdf

The complete technical report, co-authored with Natalie Elena Cernei and Alberto Cozzani, University of Bologna, Academic Year 2023/2024.

**Contents:**

### Introduction
States the diffusion-convection-reaction problem and the project's goal: a MATLAB app to plot convergence/conditioning and numerical solutions, in two modalities (exact solution `u` given, or data `f` given).

### Chapter 1 — Central FD for Diffusion-Convection-Reaction
- **1.1 Computation of the matrix A** — Kronecker-product assembly for homogeneous Dirichlet; the `v = u - R_g` decomposition for non-homogeneous Dirichlet; ghost-point treatment of Robin conditions on each side; special handling of corner points where Robin conditions meet on two sides
- **1.2 Accuracy and stability**
  - **1.2.1 Accuracy** — Taylor-expansion derivation of the `O(h²)` local truncation error
  - **1.2.2 Stability** — Von Neumann (Fourier-mode) analysis of the associated time-dependent problem, yielding the `Δt` stability bound in terms of `Δx`, `q`, and `b`

### Chapter 2 — A Brief Guide on How the App Works
- **2.1 First modality** (exact solution `u` known) — three worked examples:
  - Example 1: pure Poisson problem (`b=0, q=0`), homogeneous Dirichlet, `u = sin(2πx)sin(2πy)`
  - Example 2: Dirichlet (left) + Robin (remaining sides), `q = π`, `r = 1.5`, `u = sin(2x)(x²+y²)`
  - Example 3: same as Example 2 but with non-zero convection `b = (2, 1.5)`, `q = 1` — compares error order and conditioning behavior against Example 1's Poisson case
- **2.2 Second modality** (data `f` known) — two worked examples:
  - Example 1: elliptic problem on `[-π/2,π/2]×[-π,0]`, `k=0.4`, homogeneous Dirichlet, with explicit `f` and known true solution `u(x,y) = -e^x cos(x) sin(y)` (used only for the worked example, not entered into the app)
  - Example 2: mixed problem with `q=π`, convection term `∂u/∂x`, Dirichlet on the right side only, Robin (`r=1.5`) elsewhere — with all four boundary functions `gL, gB, gT` and `f` given explicitly as anonymous functions

### Chapter 3 — Conclusions
Confirms the numerical results match the theoretical accuracy/stability analysis of Chapter 1, and that both modalities (exact-solution-driven vs. data-driven) produce consistent results.

## Reading Guide

| If you want to understand... | Read... |
|---|---|
| How the system matrix A is assembled | Report Section 1.1 |
| How Robin BCs and corner points are discretized | Report Section 1.1 (ghost points, corner discussion) |
| Why the method is second-order accurate | Report Section 1.2.1 |
| The time-step stability bound | Report Section 1.2.2 |
| How to use Modality 1 (exact solution) | Report Section 2.1, with 3 worked examples |
| How to use Modality 2 (given data) | Report Section 2.2, with 2 worked examples |
| The overall conclusions | Report Chapter 3 |

## Code ↔ Report Mapping

| Report Section | Code |
|---|---|
| 1.1 Matrix assembly (Kronecker products, Robin/ghost points, corners) | `Lapl2D_Project`, `ellipt2D_FD_project`, `ellipt2D_FD_project2` |
| 1.2.1 Accuracy / convergence study | `FD_conv` (grid-refinement loop, log-log error-vs-h plot) |
| 1.2.2 Stability | (theoretical only — not directly implemented as a runtime check in the app) |
| 2.1 Modality 1 UI & examples | `version1` branch of `projectMainApp`, `dialogApp`/`dialogApp2`/`dialogApp3` |
| 2.2 Modality 2 UI & examples | `version2` branch of `projectMainApp`, `ellipt2D_FD_project2`, `FD2` |

## Authors

**Niccolò Chiari**, Natalie Elena Cernei, Alberto Cozzani — University of Bologna, Academic Year 2023/2024.
