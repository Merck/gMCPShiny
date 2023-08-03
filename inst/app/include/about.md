This is a web interface to the open-source R package
<a href="https://cran.r-project.org/package=gMCPLite" target="_blank">gMCPLite</a>
for multiple testing using graphical approach built with Shiny.

### Features

**Create an initial multiplicity graph**

- Designs for creating a multiplicity graph with `ggplot2` visualization.
- Flexible customization options for hypothesis node, transition edge, and labels.
- Example gallery including typical and advanced graph examples.
- Generates R code that allows one to save the `gMCPLite::hGraph()` and `ggplot2` logic and re-ran later to fully reproduce the multiplicity graph.

**Iterative graphs update (WIP)**

- Allow users to choose updating strategy, including reject hypothesis directly or based on actual observed p-value (non-parametric method).
- Each hypothesis can be fixed design or group sequential design.
- Group sequential design can compare nominal p-value with p-value boundary for each IA, or compare sequential p-value with available alpha.
- Manually input p-value boundary/sequential p-value or upload gsDesign data to obtain them automatically.
- Tabular design output for group sequential design (if applicable) and rmarkdown report for graphs update code.

**Save and restore graphs**

- Save and restore all parameters when creating the initial graph or updating iterative graphs.
- Save the graph output as PNG or PDF.

### Contributors

Creator & Maintainer

- Yalin Zhu, PhD \<yalin.zhu at merck.com\>

Project Manager

- Keaven Anderson, PhD \<keaven_anderson at merck.com\>

Developers

- Xuan Deng, PhD \<xuan.deng at merck.com\>
- Yalin Zhu, PhD \<yalin.zhu at merck.com\>
- Nan Xiao, PhD \<nan.xiao1 at merck.com\>

### License

gMCPShiny is licensed under <a href="https://cran.r-project.org/web/licenses/GPL-3" target="_blank" title="License information">GPL-3</a>.
