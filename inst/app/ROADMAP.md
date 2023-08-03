# Roadmap for gMCPShiny

1. Initial features for initial graph setup (release 1)
   - Refactor Shiny code for extensibility (modularization).
   - Replace unstable dependency `rhandsontable` with `shinyMatrix` for more robust performance, allowing to add/delete/reset rows.
   - Ensure the core graph output and code template directly depends on `gMCPLite::hGraph()`.
   - Save and reload `.rds` file for a single hGraph output.

1. Add features to refine UI
   - Only keep core inputs of **hypotheses/node position** and **transition weight** under "Hypothesis" and "Transition" tabs.
   - Add pop-up window feature for other node or edge customization.
   - Add an adaptive palette module as a better way of color selection.
   - Use "Labels" tab to customize graph's legend, title and caption/footnote.

1. Add flexibility of input text/numeric
   - Support Unicode escape sequence for text input, i.e., hypothesis name, alpha symbol and labels (legend, title, caption/footnote).
   - Support arithmetic formula for numeric input, i.e., alpha and transition weight.

1. Add features for loading example gallery
   - Practical graph examples in clinical trial.
   - Classical unstructured/ungrouped examples.
   - Advanced structured/grouped examples.

1. Download plot in PNG format
   - Pop-up window feature.
   - Allow user to set weight, height, DPI and scaling factor.

1. Internal/external users testing
   - Deploy the initial graph features to shinyapps.io.
   - Periodic notice or announcement for advertising.

1. Release plan
   - Compile as an R package structure.

1. Iterative graphs update (release 2)
   - Bonferroni based iteration
     - Allow user reject hypothesis directly.
     - or input observed p-value (simple fixed design) to make decision.
     - connect with `gsDesign` object to obtain each IA's p-value bounds (WIP).
