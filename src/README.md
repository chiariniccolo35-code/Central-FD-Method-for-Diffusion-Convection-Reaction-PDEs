# Source Code

Four MATLAB App Designer apps. **`projectMainApp.mlapp` is the one to run** — the other three are modal dialog windows it launches internally.

## projectMainApp.mlapp — Main Application

The core app, containing all the numerical methods plus the main UI (menu bar, grid-size/function input fields, plot-type selector, plot axes, data table).

### Key Properties

| Property | Meaning |
|---|---|
| `version1` | Boolean: `1` = Modality 1 (exact solution known), `0` = Modality 2 (data `f` known) |
| `B_x`, `B_y`, `q` | Convection vector components and reaction coefficient |
| `robin`, `r` | Whether Robin BCs are active, and the Robin coefficient |
| `BC` | Struct recording which sides (L/R/T/B) carry Robin vs. Dirichlet conditions |
| `u` | (Modality 1) the user's exact-solution symbolic expression |
| `f`, `gL`, `gR`, `gB`, `gT`, `gD` | (Modality 2) the user-supplied data/boundary functions, as anonymous-function strings |
| `a`, `b`, `c`, `d` | Rectangle domain extremes |

### Key Methods

| Method | Role |
|---|---|
| `updateparameters(app, Bx, By, Q, ~)` | Callback target for `dialogApp` — stores `B_x`, `B_y`, `q` |
| `updateBC(app, robin, r, L, R, B, T)` | Callback target for `dialogApp2` in Modality 1 — stores which sides are Robin/Dirichlet and `r` |
| `updateBC2(app, robin, r, L, R, B, T, gL, gR, gB, gT, gD)` | Callback target for `dialogApp2` in Modality 2 — also stores the explicit boundary data functions |
| `updateABCD(app, A, B, C, D)` | Callback target for `dialogApp3` — stores the domain extremes |
| `Lapl2D_Project(app, N, M, hx, hy, Bc, gamma, r, B)` | Builds the 1D derivative matrices `Dx`, `Dy` and assembles the full system matrix `A` via Kronecker products (see main README for the formula) |
| `ellipt2D_FD_project(app, u, q, r, Bc, a, b, c, d, N, M, count, B)` | **Modality 1 solver.** Symbolically differentiates the exact solution `u` (via `diff`, `matlabFunction`) to derive `f` and the Robin boundary data `g_L, g_R, g_B, g_T`, assembles and solves the FD system, and returns the numerical and exact solutions for comparison |
| `ellipt2D_FD_project2(app, f, q, r, Bc, a, b, c, d, N, M, B, gL, gR, gB, gT, gD)` | **Modality 2 solver.** Same FD assembly, but using the user-supplied `f` and boundary functions directly (no symbolic differentiation, no exact solution to compare against) |
| `FD_conv(app, u, a, b, c, d, B, gamma, corner, r, plot)` | Runs `ellipt2D_FD_project` over grid sizes `N = 2^k`, `k = 2..5`, collecting `(N, M, hx, hy, ‖error‖∞, condest(A))` into a table, and plots error/conditioning vs. `h` on a log-log scale |
| `FD(app, u, a, b, c, d, B, gamma, Bc, r, plot)` | Modality 1 orchestrator — calls `FD_conv` (for convergence/conditioning plots) or a single solve (for the numerical-solution plot), depending on the selected radio button |
| `FD2(app, f, a, b, c, d, B, gamma, Bc, r, gL, gR, gB, gT, gD)` | Modality 2 orchestrator — single solve + numerical-solution surface plot |
| `PlotButtonPushed` / `plotButtonPushed` | Button callbacks wiring the UI to `FD`/`FD2` |

### Menu Callbacks (launch the dialogs)

- `SetproblemparametersMenuSelected` → opens `dialogApp`
- `SetboundaryconditionsMenuSelected` → opens `dialogApp2`
- `SetdomainMenuSelected` → opens `dialogApp3`
- `version1MenuSelected` / `version2MenuSelected` → switch between Modality 1 / Modality 2

## dialogApp.mlapp — "Set Problem Parameters" Dialog

A small pop-up with three numeric fields: `B_x`, `B_y`, `q`. On confirmation (`ButtonPushed`), it calls `updateparameters` on the main app and closes itself.

## dialogApp2.mlapp — "Set Boundary Conditions" Dialog

The most complex of the three dialogs. Contains:
- A radio-button group: **Dirichlet** vs. **Mixed/Robin**
- Checkboxes for **Left / Right / Top / Bottom**, to choose which sides carry Robin conditions (the rest default to Dirichlet)
- A numeric field for the Robin coefficient `r`
- **Only visible in Modality 2** (checked via `app.MainApp.version1`): edit fields for the explicit boundary data functions `g_D`, `g_L`, `g_R`, `g_T`, `g_B`

Its `startupFcn` dynamically shows/hides the relevant fields depending on both the Dirichlet/Robin choice and the current modality. On confirmation, it calls `updateBC` (Modality 1) or `updateBC2` (Modality 2) on the main app.

## dialogApp3.mlapp — "Set Domain" Dialog

A small pop-up with four numeric fields: `a`, `b`, `c`, `d` (the rectangle's extremes, so the domain is `[a,b] × [c,d]`). On confirmation (`okayButton`), it calls `updateABCD` on the main app.

## source/ — Plain-Text Code Extractions

App Designer apps store their source code inside a zipped XML container (`matlab/document.xml`) that GitHub cannot render. The four files in `source/` are plain-text extractions of the code embedded in the corresponding `.mlapp` files, provided **purely for readability/review on GitHub**.

**These are not runnable on their own** — the actual GUI layout/component wiring lives inside the `.mlapp` containers. To run the tool, always use the `.mlapp` files directly in MATLAB (see the main `README.md`).

## Dependencies

- Core MATLAB (`uifigure`, `uitabgroup`/`uitab`, `uiaxes`, `uitable`, menus, dialogs, `contour`/`surf`-style plotting, `condest`, sparse linear algebra)
- **Symbolic Math Toolbox** — required for Modality 1's automatic derivation of `f` and the Robin boundary data from the user's exact solution `u` (`syms`, `diff`, `matlabFunction`)
