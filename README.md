# Central FD Method for Diffusion-Convection-Reaction PDEs

A MATLAB **App Designer GUI tool** that solves the 2D elliptic **Diffusion-Convection-Reaction** equation with mixed Dirichlet/Robin boundary conditions on a rectangular domain, using the **Central Finite Difference (FD)** method, with two interactive modalities for specifying the problem.

> Group project — co-authored with Natalie Elena Cernei and Alberto Cozzani (University of Bologna).

## Project Overview

The PDE addressed is:

```
-∇·(k∇u) + b·∇u + qu = f,      (x, y) ∈ Ω = [a,b] × [c,d]
```

with mixed boundary conditions: **Dirichlet** (`u = g`) on part of the boundary `Γ_D`, and **Robin** (`∂u/∂ν + ru = h`) on the rest (`∂Ω \ Γ_D`). Throughout, the diffusion coefficient `k` is taken equal to 1 for simplicity.

The app provides **two modalities**:

1. **Modality 1 — "Manufactured solution" mode:** the user specifies the **exact solution** `u(x,y)` directly. The app symbolically differentiates `u` (using the MATLAB Symbolic Math Toolbox) to derive the corresponding right-hand side `f` and boundary data automatically, then solves the FD-discretized problem and compares the numerical solution against the (known) exact one — enabling **convergence** and **matrix-conditioning** studies as the grid is refined.
2. **Modality 2 — "Given data" mode:** the user directly specifies `f` and the boundary data functions (`g_D`, `g_L`, `g_R`, `g_T`, `g_B`) as MATLAB anonymous functions, and the app computes and plots only the **numerical solution** (no exact solution is available for comparison in this mode).

In both modalities, the user sets the convection vector `b = (B_x, B_y)`, the reaction coefficient `q`, the Robin coefficient `r`, the rectangular domain `[a,b] × [c,d]`, and which sides of the boundary carry Dirichlet vs. Robin conditions.

## Mathematical Background

### Discretization

Using a uniform grid `(xᵢ, yⱼ)` with spacing `hx`, `hy`, the central FD scheme for the PDE is:

```
-( (uᵢ₊₁,ⱼ - 2uᵢ,ⱼ + uᵢ₋₁,ⱼ)/hx² + (uᵢ,ⱼ₊₁ - 2uᵢ,ⱼ + uᵢ,ⱼ₋₁)/hy² )
+ b·( (uᵢ₊₁,ⱼ - uᵢ₋₁,ⱼ)/2hx , (uᵢ,ⱼ₊₁ - uᵢ,ⱼ₋₁)/2hy )
+ q·uᵢ,ⱼ = fᵢ,ⱼ
```

### Matrix Assembly via Kronecker Products

The system matrix `A` (for homogeneous Dirichlet conditions) is built from four building blocks via **Kronecker products**:

- `Dxx`, `Dyy` — 1D second-derivative central FD matrices (tridiagonal, `[1, -2, 1]`)
- `Dx`, `Dy` — 1D first-derivative central FD matrices (tridiagonal, `[-1, 0, 1]`)

```
K1 = (Iy ⊗ Dxx) / hx²          K2 = (Dyy ⊗ Ix) / hy²
K3 = b₂·(Dy ⊗ Ix) / 2hy        K4 = b₁·(Iy ⊗ Dx) / 2hx

A = -(K1 + K2) + (K3 + K4) + q·I
```

### Non-Homogeneous Dirichlet & Robin/Mixed Boundary Conditions

For non-homogeneous Dirichlet data `g ≠ 0`, the solution is decomposed as `u = v + R_g` (where `R_g` carries the known boundary values and is zero on free/interior nodes), reducing the problem back to the homogeneous case restricted to the free nodes:

```
A(free, free) · V = F(free) - Z(free),      Z = F - A·R_g
```

For **Robin conditions**, **ghost points** are introduced just outside the domain; the Robin condition is discretized with a central first-order FD approximation of the normal derivative, and the ghost-point value is substituted back into the interior stencil equation — modifying the corresponding rows of `A` and `F`. **Corner points** where Robin conditions meet on two adjacent sides require special handling (since the normal derivative isn't well defined at a corner), using a combination of the two directional derivatives.

### Accuracy

By Taylor expansion, the local truncation error of the central FD scheme is `O(hx² + hy²)`. Since the app uses `hx ≈ hy`, the method is **second-order accurate**: `τᵢ,ⱼ = O(h²)` — so the error-vs-`h` convergence plot is expected to be a straight line parallel to `h²` on a log-log scale.

### Stability (Von Neumann Analysis)

Considering the associated time-dependent problem and applying Von Neumann (Fourier-mode) stability analysis to the explicit time-stepping scheme, the amplification factor `G` must satisfy `|G| ≤ 1`. Splitting `G` into a diffusion-reaction term `A` and a convection term `B` (with `Δx ≈ Δy`), the analysis yields the time-step stability conditions:

```
Δt ≤ 2Δx² / (8 + qΔx²)        Δt ≤ Δx / min(|b₁|, |b₂|)
```

i.e. `Δt ≤ min( 2Δx²/(8+qΔx²), Δx/min(|b₁|,|b₂|) )`.

## The MATLAB GUI Tool

Built with **MATLAB App Designer** as a main app plus three modal dialog windows:

| File | Role |
|---|---|
| `projectMainApp.mlapp` | **Main window** — menu bar (Set app mode / Set problem parameters / Set boundary conditions / Set domain), grid-size fields (N, M), `f`/`u` input field, plot-type selector (Convergence plot / Matrix conditioning / Numerical solution), plot axes, and a data table |
| `dialogApp.mlapp` | **"Set problem parameters" dialog** — pop-up for entering `B_x`, `B_y`, `q` |
| `dialogApp2.mlapp` | **"Set boundary conditions" dialog** — choose Dirichlet vs. Robin (and on which sides: Left/Right/Top/Bottom), Robin coefficient `r`, and — in Modality 2 only — the explicit boundary data functions `g_D, g_L, g_R, g_T, g_B` |
| `dialogApp3.mlapp` | **"Set domain" dialog** — pop-up for entering the rectangle extremes `a, b, c, d` |

Each dialog communicates back to `projectMainApp` via stored references and `update*` methods (`updateparameters`, `updateBC`/`updateBC2`, `updateABCD`), so the main app's internal state is updated as soon as a dialog is confirmed.

### Modality 1 — Manufactured Solution

The user enters the exact solution `u(x,y)` as a symbolic expression in the main window's edit field. The app uses the **Symbolic Math Toolbox** (`diff`, `matlabFunction`) to automatically derive:

```
f = -Δu + q·u + b·∇u            (the right-hand side)
g_L = -∂u/∂x + r·u,  g_R = ∂u/∂x + r·u,  g_B = -∂u/∂y + r·u,  g_T = ∂u/∂y + r·u   (Robin data)
```

so the user never has to manually compute `f` or the boundary data — only `u` is needed. Three plot types are available:
- **Convergence plot** — runs the FD solver at grid sizes `N = 2^k` for `k = 2,...,5`, plotting the infinity-norm error against `h` on a log-log scale (with an `h²` reference line)
- **Matrix conditioning** — same grid-refinement loop, plotting `condest(A)` against `h`
- **Numerical solution** — a single-grid solve, visualized as a surface plot

A data table (N, M, hx, hy, error norm, condition number) accompanies the convergence/conditioning plots.

### Modality 2 — Given Data

The user enters `f` and the boundary data functions directly as MATLAB anonymous-function strings (e.g. `@(x,y) y*exp(2*x) - ...`). The app solves the FD-discretized problem once, for the user-specified grid size `N × M`, and plots only the resulting numerical solution surface (no exact solution exists to compare against in this mode).

## Project Structure

```
.
├── README.md                          # This file
├── docs/
│   ├── README.md
│   └── Report_Numeric_differential_equation.pdf   # Full technical report
└── src/
    ├── README.md
    ├── projectMainApp.mlapp            # Main GUI app — run this in MATLAB
    ├── dialogApp.mlapp                 # "Set problem parameters" dialog
    ├── dialogApp2.mlapp                # "Set boundary conditions" dialog
    ├── dialogApp3.mlapp                # "Set domain" dialog
    └── source/                         # Plain-text extractions of the above, for GitHub readability only
        ├── projectMainApp_source.m
        ├── dialogApp_source.m
        ├── dialogApp2_source.m
        └── dialogApp3_source.m
```

## How to Use

### Prerequisites

- MATLAB R2019b or later
- **Symbolic Math Toolbox** (required for Modality 1, which symbolically differentiates the user-supplied exact solution)

### Running the Tool

1. Open MATLAB
2. Open `src/projectMainApp.mlapp` and press **Run**
3. From the menu bar:
   - **Set app mode** → choose Modality 1 (exact solution known) or Modality 2 (data `f`/boundary functions known)
   - **Set problem parameters** → enter `B_x`, `B_y`, `q`
   - **Set boundary conditions** → choose Dirichlet/Robin sides, Robin coefficient `r`, and (Modality 2 only) the boundary data functions
   - **Set domain** → enter the rectangle extremes `a, b, c, d`
4. Enter `N`, `M` (grid size) and `u` (Modality 1) or `f` (Modality 2) in the main panel
5. Choose a plot type (Convergence plot / Matrix conditioning number / Numerical solution) and press **Plot**

## Summary of Findings (from the report)

- The method achieves the expected **second-order accuracy** (`O(h²)`), confirmed by the convergence plots matching the `h²` reference line
- Adding a non-zero convection term `b` and reaction coefficient `q` increases the error relative to the pure-diffusion (Poisson) case, but the matrix conditioning behaves similarly to the Poisson-with-homogeneous-Dirichlet case
- Numerical results were consistent across both modalities — whether the exact solution `u` or the data `f` (plus boundary functions) is provided, the FD solver produces consistent, theoretically-expected behavior

## Author

**Niccolò Chiari**, with Natalie Elena Cernei and Alberto Cozzani  
University of Bologna — Academic Year 2023/2024

## License

Educational project. Available for academic use.
