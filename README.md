# International tax minimization algorithm
This repository contains the source code for an algorithm designed to optimize international tax strategies, particularly focusing on the implications of Dutch tax treaties with developing countries. The work is grounded in the findings of the publication [Dutch tax treaties and developing countries](https://www.cpb.nl/en/dutch-tax-treaties-and-developing-countries-a-network-analysis), which provides a comprehensive network analysis of such treaties.

## Overview
International businesses often face significant tax liabilities when transferring funds across borders. Direct transfers between countries can incur substantial taxes, which can be minimized through strategic routing via one or more intermediary countries. This repository's scripts are developed to identify the least expensive tax paths between country pairs, highlighting nations that frequently serve as hubs in these financial networks.

## Key Features

- **Tax path identification:** automates the discovery of cost-effective routes for transferring funds internationally, minimizing tax liabilities.
- **Network analysis:** offers insights into countries that act as central nodes in the global tax optimization landscape.
- **Optimization algorithm:** Utilizes graph theory to model international tax scenarios, facilitating the identification of optimal transfer strategies.

### Technical Specifications
The algorithm conceptualizes the global tax system as a directed graph where nodes represent countries, and edges signify the tax percentage applicable to money transfers between these countries. It implements [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm).

- **Pathfinding:** for any two countries `s`(tart) and `d`(estination), the algorithm determines the set `P_sd` of shortest paths, minimizing tax implications.
- **Route analysis:** each country appears no more than once in any given route. Routes are compared and deduplicated based on the sorted order of countries they pass through, ensuring unique pathway identification.
